//
//  PagingPhotoViewController.m
//  AAOEditor
//
//  Created by Ant on 9/23/10.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PagingPhotoViewController.h"
#import "ImageCache.h"
#import "Photo.h"
#import "BucketOptionsViewController.h"
#import "PhotoMetaViewController.h"
#import "OrganiserDAO.h"
#import "TransparentToolbar.h"

#define PADDING  10


@implementation PagingPhotoViewController


@synthesize photoSet;
@synthesize currentPhotoIndex;



- (id)init {
	if ((self = [super init])) {
		self.title = @"Photo Viewer";
	}
	return self;
}

- (void)dealloc {
	[photoSet release];
	[pagingScrollView release];
	[visiblePages release];
	[recycledPages release];
	[super dealloc];
}


#pragma mark View lifecycle

- (void)loadView {
	
	[super loadView];
	
	// Create a scroll view and make it page
	CGRect psvFrame = [self pagingScrollViewFrame];
	pagingScrollView = [[UIScrollView alloc] initWithFrame:psvFrame];
	pagingScrollView.pagingEnabled = YES;
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
	pagingScrollView.backgroundColor = [UIColor blackColor];
	pagingScrollView.delegate = self;
	self.view = pagingScrollView;
	self.wantsFullScreenLayout = YES; // do we need this?
	
	// Set up initial pages
	recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];	
	
	// Create a toolbar for the top-right-hand buttons
	TransparentToolbar *tools = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 270, 44.01)];
	
	// Create an array to hold the buttons, which then gets added to the toolbar
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:8];
	
	// Create buttons for rating (i.e. 4 buttons with stars on)	
	starButtons = [[NSMutableArray alloc] initWithCapacity:4];
	
	UIImage* starWhite = [UIImage imageNamed:@"starwhite.png"];
	UIImage* starGrey = [UIImage imageNamed:@"stargrey.png"];
	CGRect frame = CGRectMake(0, 0, starWhite.size.width, starWhite.size.height);
	UIButton* starButton = [[UIButton alloc] initWithFrame:frame];
	[starButton setBackgroundImage:starGrey forState:UIControlStateNormal];
	[starButton setBackgroundImage:starWhite forState:UIControlStateSelected];
	[starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[starButton setShowsTouchWhenHighlighted:YES];
	starButton.tag = 1;
	[starButtons addObject:starButton];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:starButton];
	[buttons addObject:button];
	[button release];

	starButton = [[UIButton alloc] initWithFrame:frame];
	[starButton setBackgroundImage:starGrey forState:UIControlStateNormal];
	[starButton setBackgroundImage:starWhite forState:UIControlStateSelected];
	[starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[starButton setShowsTouchWhenHighlighted:YES];
	starButton.tag = 2;
	[starButtons addObject:starButton];
	button = [[UIBarButtonItem alloc] initWithCustomView:starButton];
	[buttons addObject:button];
	[button release];

	starButton = [[UIButton alloc] initWithFrame:frame];
	[starButton setBackgroundImage:starGrey forState:UIControlStateNormal];
	[starButton setBackgroundImage:starWhite forState:UIControlStateSelected];
	[starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[starButton setShowsTouchWhenHighlighted:YES];
	starButton.tag = 3;
	[starButtons addObject:starButton];
	button = [[UIBarButtonItem alloc] initWithCustomView:starButton];
	[buttons addObject:button];
	[button release];
	
	starButton = [[UIButton alloc] initWithFrame:frame];
	[starButton setBackgroundImage:starGrey forState:UIControlStateNormal];
	[starButton setBackgroundImage:starWhite forState:UIControlStateSelected];
	[starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[starButton setShowsTouchWhenHighlighted:YES];
	starButton.tag = 4;
	[starButtons addObject:starButton];
	button = [[UIBarButtonItem alloc] initWithCustomView:starButton];
	[buttons addObject:button];
	[button release];
	
	// Add some fixed space
	UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
																		target:nil action:nil];
	bi.width = 20;
	[buttons addObject:bi];
	[bi release];	
	
	// Create a button for adding to a bucket
	bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bucket.png"]
										  style:UIBarButtonItemStylePlain 
										 target:self
										 action:@selector(bucketsButtonClicked:)];
	[buttons addObject:bi];
	[bi release];
	
	// Create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:bi];
	[bi release];
	
	// Create a button for showing meta data
	bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eye.png"]
										  style:UIBarButtonItemStylePlain 
										 target:self
										 action:@selector(metadataButtonClicked:)];	
	[buttons addObject:bi];
	[bi release];
	
	// stick the buttons in the toolbar
	[tools setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	[tools release];
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	// When you push a controller with the navigationcontroller, it messes with your frame size,
	// so we are going to set the bugger back here to what we expect
	CGRect psvFrame = [self pagingScrollViewFrame];
	pagingScrollView.frame = [self pagingScrollViewFrame];
	
	// Set the content size at the last moment, and the current position
	pagingScrollView.contentSize = [self pagingScrollViewContentSize];
	// Set current position
	pagingScrollView.contentOffset = CGPointMake(psvFrame.size.width * currentPhotoIndex, 0.0);
	
	// Add pages to scroll view
	/*
	for (int i = 0; i < [photoSet.photos count]; i++) {
		ScrollableImageView *page = [[[ScrollableImageView alloc] init] autorelease];
		[self configurePage:page forIndex:i];
		[pagingScrollView addSubview:page];
		[visiblePages addObject:page];
	}
	 */
	[self tilePages];

	// Set rating
	[self setStarButtonsRating];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}



#pragma mark Outer scroll view configuration

// Create the frame for the paging scroll view
- (CGRect)pagingScrollViewFrame {
	CGRect rect = [[UIScreen mainScreen] bounds];
	// Check orientation
	if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
		|| [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
		&& rect.size.height > rect.size.width) {
		CGFloat tempDimension = rect.size.width;
		rect.size.width = rect.size.height;
		rect.size.height = tempDimension;
	}
	// Add left/right padding
	rect.origin.x -= PADDING;
	rect.size.width += (2 * PADDING);
	// Reduce height for nav bar
	rect.size.height -= 44;
	return rect;
}

- (CGSize)pagingScrollViewContentSize {
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [photoSet.photos count], bounds.size.height);
}

-(int)currentPage {
	// Calculate which page is visible 
	CGFloat pageWidth = pagingScrollView.frame.size.width;
	int page = floor((pagingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	return page;
}

#pragma mark Inner scroll view (page) configuration

- (CGRect)pageFrameForIndex:(NSUInteger)index {
	CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
	return pageFrame;
}

- (void)configurePage:(ScrollableImageView *)page forIndex:(NSUInteger)index {
	
	page.index = index;
	page.photoId = [[[photoSet photoAtIndex:index] photoId] copy];
		
	// Size and position of page
    page.frame = [self pageFrameForIndex:index];
	
	// Set the image asynchronously (not tiled)
	[[ImageCache sharedCache] getImage:[[photoSet photoAtIndex:index] photoId]
												   size:ImageSizeWorking delegate:page];
	
	// Set the image asynchronously (tiled!)
	/*
	TiledImageView *tiledImageView = [[TiledImageView alloc] init];
	page.imageView = tiledImageView;
	*/
}

- (void)tilePages {
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds))-1;
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds))+1;
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [photoSet.photos count] - 1);
    NSLog(@"%d %d",firstNeededPageIndex,lastNeededPageIndex);
    // Recycle no-longer-visible pages 
    for (ScrollableImageView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
			[page wipeImageView];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ScrollableImageView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ScrollableImageView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (ScrollableImageView *)dequeueRecycledPage {
    ScrollableImageView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (ScrollableImageView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}


#pragma mark ScrollView delegate methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

	NSLog(@"Ended paging");
	
    [self tilePages];
	
	// Set current photo index (and get it to update toolbar etc)
	currentPhotoIndex = [self currentPage];
	[self setStarButtonsRating];
	
}

#pragma mark View controller rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
    }    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // recalculate contentSize based on current orientation
    pagingScrollView.contentSize = [self pagingScrollViewContentSize];
    
    // adjust frames and configuration of each visible page
    for (ScrollableImageView *page in visiblePages) {
        page.frame = [self pageFrameForIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
		page.zoomScale = page.minimumZoomScale;
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth); //+ (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);

}



#pragma mark Properties

// TODO implement properties for photoSet and currentIndex... then move implementation out of viewDidAppear


- (Photo *)currentPhoto {
	if (currentPhotoIndex >= 0 && currentPhotoIndex < photoSet.photos.count) {
		return [photoSet.photos objectAtIndex:currentPhotoIndex];
	}
	return nil;
}


#pragma mark Navigation bar button methods


- (void)starButtonClicked:(UIButton *)button {
	NSLog(@"Pressed star %d",button.tag);
	
	// Send update to server
	[[OrganiserDAO sharedDAO] ratePhoto:[self currentPhoto].photoId rating:button.tag delegate:self];
	
	// Update local object
	[self currentPhoto].rating = button.tag;
	
	// Update UI
	[self setStarButtonsRating];
}

- (void)setStarButtonsRating {
	for (int i=1; i<=starButtons.count; i++) {
		if ([self currentPhoto].rating >= i)
			((UIButton *)[starButtons objectAtIndex:i-1]).selected = YES;
		else
			((UIButton *)[starButtons objectAtIndex:i-1]).selected = NO;
	}	
}

- (void)bucketsButtonClicked:(UIBarButtonItem *)button {
	
	NSLog(@"Buckets Button Clicked!");
	
	if (! bucketsPopoverController) {
		
		// Create buckets view controller (for selecting a bucket)
		BucketOptionsViewController *bucketOptionsViewController = [[BucketOptionsViewController alloc] initWithStyle:UITableViewStylePlain];
		bucketOptionsViewController.delegate = self;
		
		// Create the popover controller for housing the bucket selector
		bucketsPopoverController = [[UIPopoverController alloc] initWithContentViewController:bucketOptionsViewController];
		bucketsPopoverController.popoverContentSize = CGSizeMake(250, 650);
		
		[bucketOptionsViewController release];		
	}	
	
	if ([bucketsPopoverController isPopoverVisible]) {
		// Remove popover
		[bucketsPopoverController dismissPopoverAnimated:YES];
	}
	else {
		// Show popover
		[bucketsPopoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)metadataButtonClicked:(UIBarButtonItem *)button {
	
	NSLog(@"Metadata button pressed!");

	if (! photoMetaPopoverController) {
		
		// Create buckets view controller (for selecting a bucket)
		PhotoMetaViewController *photoMetaViewController = [[PhotoMetaViewController alloc] initWithNibName:nil bundle:nil];
		
		// Create the popover controller for housing the bucket selector
		photoMetaPopoverController = [[UIPopoverController alloc] initWithContentViewController:photoMetaViewController];
		photoMetaPopoverController.popoverContentSize = CGSizeMake(400, 700);
		
		[photoMetaViewController release];		
	}	
	
	if ([photoMetaPopoverController isPopoverVisible]) {
		// Remove popover
		[photoMetaPopoverController dismissPopoverAnimated:YES];
	}
	else {
		// Show popover
		[((PhotoMetaViewController *)photoMetaPopoverController.contentViewController) loadForPhotoId:self.currentPhoto.photoId];
		[photoMetaPopoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	
}

#pragma mark BucketOptionsViewController delegate method

- (void)didSelectBucket:(NSString *)bucketId {
	
	// Call the dao to add photo to bucket
	[[OrganiserDAO sharedDAO] bucketPhoto:[self currentPhoto].photoId bucketId:bucketId delegate:self];
	
	// Remove popover
	[bucketsPopoverController dismissPopoverAnimated:YES];
	
}

#pragma mark LoadedUpdateResultDelegate method

- (void)didLoadUpdateResult:(UpdateResult *)result {
	
	if (result.success == NO) {
		// Display an error
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error updating" message:[NSString stringWithFormat:@"Failed with message: %@",[result message]] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[someError show];
		[someError release];
	}
	else {
		// Scream and shout
	}
}

@end

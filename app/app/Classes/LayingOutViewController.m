    //
//  vcLayout.m
//  PhotoOrganiser
//
//  Created by JD on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LayingOutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCache.h"
#import "OrganiserDAO.h"
#import "Photo.h"
#import "PhotoSet.h"
#import "AsyncImageView.h"
#import "PagingPhotoViewController.h"
#import "TransparentToolbar.h"

@implementation LayingOutViewController
@synthesize canvasView, scrollView, myPhotoSet;

const BOOL kResizable = FALSE;

#pragma mark lifecycle
- (void)viewDidLoad {
	[super viewDidLoad]; 

	aCanvasPicsSelected = [[NSMutableArray alloc] initWithCapacity:100];
	
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		//iPad (portrait mode)
		kScreenWidth = 1024; kScreenHeight = 768;
		kContentWidth = 3072; kContentHeight = 2304;
	} else {
		//iPad (landscape mode)
		kScreenWidth = 768; kScreenHeight = 1024;
		kContentWidth = 2304; kContentHeight = 3072;
	}

	kScreenSizeX = kScreenWidth; 
	kScreenSizeY = kScreenHeight;
	kContentSizeX = kContentWidth; 
	kContentSizeY = kContentHeight;
	
	NSLog(@"Allocate scrollview: x:%d y:%d w:%d h:%d", kScreenSizeX, kScreenSizeY, kContentSizeX, kContentSizeY);
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeX, kScreenSizeY)];
	scrollView.contentSize=CGSizeMake(kContentSizeX, kContentSizeY);
	scrollView.contentOffset=CGPointMake(kScreenSizeX, kScreenSizeY);
	scrollView.showsHorizontalScrollIndicator = TRUE;
	scrollView.showsVerticalScrollIndicator = TRUE;
	scrollView.maximumZoomScale = 3.0;
	scrollView.minimumZoomScale = 0.33;
	scrollView.contentScaleFactor = 0.33;
	scrollView.clipsToBounds = YES;
	scrollView.delegate = self;
	scrollView.backgroundColor = [UIColor blackColor];
	
	canvasView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kContentSizeX,kContentSizeY)];
	canvasView.backgroundColor = [UIColor darkGrayColor];
	self.view.backgroundColor = [UIColor blackColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[scrollView addSubview:canvasView];
	[self.view addSubview:scrollView];
	
	[self setToolbar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
    [super dealloc];
	[canvasView release];
}

#pragma mark draw
- (void) setToolbar {
	/*
	TransparentToolbar *tools = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.01)];
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:8];
	UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
																		target:nil action:nil];
	bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eye.png"]
										  style:UIBarButtonItemStylePlain 
										 target:self
										 action:@selector(metadataButtonClicked:)];	
	
	UIBarButtonItem *bucketsPopoverButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
																			 style:UIBarButtonItemStyleBordered
																			target:self
																			action:@selector(bucketFilterButtonClicked:)];
	//[buttons addObject:bi];
	[buttons addObject:bucketsPopoverButton];
	[bi release];
	[tools setItems:buttons animated:NO];
	[buttons release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	[tools release];
	*/
	
	// Create a toolbar for the top-right-hand buttons
	TransparentToolbar *tools = [[TransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 380, 44.01)];
	
	// Create an array to hold the buttons, which then gets added to the toolbar
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:8];
	
	// Add some fixed space
	UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
																		target:nil action:nil];
	bi.width = 20;
	[buttons addObject:bi];
	[bi release];	
	 
	
	//UIBarButtonItem *btnRefresh = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh"
	//																		  style:UIBarButtonItemStyleBordered
	//																		 target:self
	//																		 action:@selector(btnRefreshClicked:)] autorelease];
	//[buttons addObject:btnRefresh];
	
	UIBarButtonItem *btnCleanup = [[[UIBarButtonItem alloc] initWithTitle:@"Clear Canvas"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(btnCleanupClicked:)] autorelease];
	[buttons addObject:btnCleanup];
	
	
	// Create a button for adding to a bucket
	bi = [[UIBarButtonItem alloc] initWithTitle:@"Add Pictures" style:UIBarButtonItemStyleBordered target:self action:@selector(bucketFilterButtonClicked:)];
	[buttons addObject:bi];
	[bi release];
	
	// Create a button for adding to a bucket
	bi = [[UIBarButtonItem alloc] initWithTitle:@"Save to Bucket" style:UIBarButtonItemStyleBordered target:self action:@selector(bucketsButtonClicked:)];
	[buttons addObject:bi];
	[bi release];
	
	// Create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:bi];
	[bi release];
	
	// stick the buttons in the toolbar
	[tools setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	[tools release];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return canvasView;
} 

#pragma mark gestures
- (void)addGestureRecognizersToPiece:(UIView *)piece {
	//tap gesture is used to select the pieces
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    tapGesture.numberOfTapsRequired = 1;
	[piece addGestureRecognizer:tapGesture];
    [tapGesture release];
	
	//double tap gesture is used to switch to paging vc
    UITapGestureRecognizer *doubletapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubletapPiece:)];
    doubletapGesture.numberOfTapsRequired = 2;
	[piece addGestureRecognizer:doubletapGesture];
    [doubletapGesture release];

	[tapGesture requireGestureRecognizerToFail: doubletapGesture];
	
	//pinch gesture is used to resize the pics    
	if (kResizable) {
		UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
		[pinchGesture setDelegate:self];
		[piece addGestureRecognizer:pinchGesture];
		[pinchGesture release];
	}
    
	//pan gesture is used to move the pics on the canvas
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
	
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *myPiece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:myPiece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:myPiece.superview];
        
        myPiece.layer.anchorPoint = CGPointMake(locationInView.x / myPiece.bounds.size.width, locationInView.y / myPiece.bounds.size.height);
        myPiece.center = locationInSuperview;
    }
}
- (void)tapPiece:(UITapGestureRecognizer*)gestureRecognizer {
	UIView *piece = [gestureRecognizer view];
	Photo *piecePic = [[myPhotoSet photos] objectAtIndex:piece.tag];
	
	if (piece.layer.borderWidth != 3.0) {
		[piece.layer setBorderColor: [[UIColor grayColor] CGColor]];
		[piece.layer setBorderWidth: 3.0];
		
		Photo *tempPic = [[myPhotoSet photos] objectAtIndex:piece.tag];
		[aCanvasPicsSelected addObject:tempPic];
		NSLog(@"Add selected:%@", tempPic.photoId);
		//[tempPic release];
		
	} else {
		[piece.layer setBorderColor: [[UIColor grayColor] CGColor]];
		[piece.layer setBorderWidth: 0];
		
		NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:1];
		[tempArray addObject:piecePic];
		[aCanvasPicsSelected removeObjectsInArray:tempArray];
		//[tempArray release];
		
	}
	NSLog(@"selected count:%d", aCanvasPicsSelected.count);
	//[piecePic release];
}
- (void)doubletapPiece:(UITapGestureRecognizer*)gestureRecognizer {
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		
		NSLog(@"Double tap on piece");
		
		// Index of the photo tapped
		NSUInteger index = gestureRecognizer.view.tag;
		
		// Create photo view controller and link to our photoset
		PagingPhotoViewController *controller = [[PagingPhotoViewController alloc] initWithNibName:nil bundle:nil];
		controller.photoSet = myPhotoSet;
		controller.currentPhotoIndex = index;
		
		// Push it on the navigation stack
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller	release];
	}
	
}
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *piece = [gestureRecognizer view];
    
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    } 
	
	//time to save it back to the server
	if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		Photo *photo = [[myPhotoSet photos] objectAtIndex:piece.tag];
		
		int pieceXFromCenter, pieceYFromCenter;
		pieceXFromCenter = piece.frame.origin.x + 90 - (kContentSizeX / 2);
		pieceYFromCenter = piece.frame.origin.y + 90 - (kContentSizeY / 2);
		
		NSLog(@"pic %@ (in %@) moved coord are now x:%d y:%d", photo.photoId, photo.bucketId, pieceXFromCenter, pieceYFromCenter);
		
		OrganiserDAO *dao = [OrganiserDAO sharedDAO];
		[dao positionPhoto:photo.photoId 
							bucketId:photo.bucketId	
							point:CGPointMake(pieceXFromCenter, pieceYFromCenter) 
							size:CGSizeMake(piece.bounds.size.width, piece.bounds.size.height) delegate:self];
	} 
}
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
	
	//time to save it back to the server
	if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		UIView *piece = [gestureRecognizer view];
		Photo *photo = [[myPhotoSet photos] objectAtIndex:gestureRecognizer.view.tag];
		
		NSLog(@"pic %@ resized size is now width:%f height:%f", photo.photoId, piece.frame.size.width, piece.frame.size.height);
		
		OrganiserDAO *dao = [OrganiserDAO sharedDAO];
		[dao positionPhoto:photo.photoId 
							bucketId:@"mplrw" 
							point:CGPointMake(piece.frame.origin.x, piece.frame.origin.y) 
							size:CGSizeMake(piece.frame.size.width, piece.frame.size.height) delegate:self];
	} 
	
	
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.view == otherGestureRecognizer.view)
        return YES;
	return NO;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		//iPad (portrait mode)
		kScreenWidth = 1024; kScreenHeight = 768;
		kContentWidth = 3072; kContentHeight = 2304;
	} else {
		//iPad (landscape mode)
		kScreenWidth = 768; kScreenHeight = 1024;
		kContentWidth = 2304; kContentHeight = 3072;
	}
	
	kScreenSizeX = kScreenWidth; 
	kScreenSizeY = kScreenHeight;
	kContentSizeX = kContentWidth; 
	kContentSizeY = kContentHeight;
	
	NSLog(@"Allocate scrollview: x:%d y:%d w:%d h:%d", kScreenSizeX, kScreenSizeY, kContentSizeX, kContentSizeY);

	scrollView.frame = CGRectMake(0, 0, kScreenSizeX, kScreenSizeY);
	scrollView.contentSize = CGSizeMake(kContentSizeX, kContentSizeY);
	canvasView.frame = CGRectMake(0, 0, kContentSizeX, kContentSizeY);
	//scrollView.maximumZoomScale = 3.0;
	//scrollView.minimumZoomScale = 1;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark action
- (void)btnRefreshClicked:(UIBarButtonItem *)button {}
- (void)btnCleanupClicked:(UIBarButtonItem *)button {
	AsyncImageView *tempView;
	for (tempView in canvasView.subviews) {
		[tempView removeFromSuperview];
	}
	[tempView release];
	[aCanvasPicsSelected removeAllObjects];
}
- (void)bucketFilterButtonClicked:(UIBarButtonItem *)button {
	
	NSLog(@"Pictures Button Clicked!");
	
	if (! popoverPictures) {
		
		// Create buckets view controller (for selecting a bucket)
		BucketFilterViewController *bucketFilterViewController = [[BucketFilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
		bucketFilterViewController.delegate = self;
		
		// Create the popover controller for housing the bucket selector
		popoverPictures = [[UIPopoverController alloc] initWithContentViewController:bucketFilterViewController];
		popoverPictures.popoverContentSize = CGSizeMake(250, 650);
		
		[bucketFilterViewController release];
	}
	
	if ([popoverPictures isPopoverVisible]) {
		// Remove popover
		[popoverPictures dismissPopoverAnimated:YES];
	}
	else {
		// Show popover
		[popoverPictures presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}
- (void)bucketsButtonClicked:(UIBarButtonItem *)button {
	
	NSLog(@"Buckets Button Clicked!");
	if (! popoverBuckets) {
		// Create buckets view controller (for selecting a bucket)
		BucketOptionsViewController *bucketOptionsViewController = [[BucketOptionsViewController alloc] initWithStyle:UITableViewStylePlain];
		bucketOptionsViewController.delegate = self;
		
		// Create the popover controller for housing the bucket selector
		popoverBuckets = [[UIPopoverController alloc] initWithContentViewController:bucketOptionsViewController];
		popoverBuckets.popoverContentSize = CGSizeMake(250, 650);
		
		[bucketOptionsViewController release];		
	}	
	
	if ([popoverBuckets isPopoverVisible]) {
		// Remove popover
		[popoverBuckets dismissPopoverAnimated:YES];
	}
	else {
		// Show popover
		[popoverBuckets presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

#pragma mark delegates
- (void)didLoadPhotoSet:(PhotoSet *)ps {
	// Set instance photoset
	myPhotoSet = ps;
	NSLog(@"Count pics in bucket:%d", [[myPhotoSet photos] count]);
	
	int fooX = 0; int fooY = 300; 
	int countPicsLine = 0; 
	int countPicsLineMax = 5; 
	int countPicsInCanvas = 0;
	int countPicsInCanvasMax = 30;
	
	for (int i=0; i<[[myPhotoSet photos] count]; i++) {
		int x; int y;
		
		Photo *photo = [[myPhotoSet photos] objectAtIndex:i];
						
		if (!CGRectIsEmpty(photo.frame)) {
			x = photo.frame.origin.x + (kContentSizeX / 2);
			y = photo.frame.origin.y + (kContentSizeY / 2);
			
		}else {
			if (countPicsLine <= countPicsLineMax ) {					
				fooX += 200;
			} else {
				countPicsLine = 0;
				fooY += 200;
				fooX = 200;
			}
			x = fooX; y = fooY;
			
			countPicsLine++;
			countPicsInCanvas++;
		}
		
		if (countPicsInCanvas <= countPicsInCanvasMax) {
			AsyncImageView* asyncImage;
			asyncImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0)] autorelease];
			asyncImage.tag = i;
			asyncImage.opaque = TRUE;
			asyncImage.userInteractionEnabled = YES;
			[asyncImage loadWithImageId:[photo photoId]];
			[asyncImage setCenter:CGPointMake(x,y)];			
			NSLog(@"Add pic x:%d y:%d", x, y);
			[canvasView addSubview:asyncImage];
			[self addGestureRecognizersToPiece:asyncImage];
			
			[aCanvasPics addObject:photo];
		}
	}		
}
- (void)didLoadUpdateResult:(UpdateResult *)result {
	NSLog(@"New position saved");
}
- (void)didSelectBuckets:(NSArray *)bucketIds ratings:(NSArray *)ratings {
	
	[activityIndicator startAnimating];
	
	// Call DAO to get a new list of photos
	[[OrganiserDAO sharedDAO] getPhotosByBuckets:bucketIds ratings:ratings delegate:self];
	
	// Remove popover
	[popoverPictures dismissPopoverAnimated:YES];
	
}
- (void)didSelectBucket:(NSString *)bucketId {
	
	// Call the dao to add photo to bucket
	Photo *pic; 
	for (pic in aCanvasPicsSelected) {
		NSLog(@"image @% bucketed in %@", pic.photoId, bucketId);
		[[OrganiserDAO sharedDAO] bucketPhoto:pic.photoId bucketId:bucketId delegate:self];
	}
	[pic release];
	
	
	// Remove popover
	[popoverBuckets dismissPopoverAnimated:YES];
	
}
@end

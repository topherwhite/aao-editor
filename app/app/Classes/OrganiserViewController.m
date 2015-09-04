//
//  OrganiserViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 12/09/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "OrganiserViewController.h"
#import "OrganiserGridCell.h"
#import	"OrganiserDAO.h"
#import "ImageCache.h"
#import "Photo.h"
#import "PhotoSet.h"
#import "KeyValuePair.h"
#import "AAOEditorAppDelegate.h"
#import "PagingPhotoViewController.h"
#import "AsyncImageView.h"


@implementation OrganiserViewController


- (id)init {
	if ((self = [super init])) {
		self.title = @"Organiser";
	}
	return self;
}


#pragma mark View lifecycle

- (void)loadView {
	
	[super loadView];
	
	// Create the button to call the popover and add to navigation bar
	UIBarButtonItem *bucketsPopoverButton = [[[UIBarButtonItem alloc] initWithTitle:@"Filter"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(bucketFilterButtonClicked:)] autorelease];
	self.navigationItem.rightBarButtonItem = bucketsPopoverButton;
	
	
	// Set up the grid
	gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    gridView.backgroundColor = [UIColor blackColor];
    //gridView.opaque = YES;
    gridView.dataSource = self;
    gridView.delegate = self;
    //gridView.scrollEnabled = YES;
	emptyCellIndex = NSNotFound;
	[self.view addSubview: gridView];
	
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// Get the initial photo set
	OrganiserDAO *dao = [OrganiserDAO sharedDAO];
	[dao getPhotosByBucket:@"nobucket" delegate:self];
	
	// Set up an activity indicator
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.hidesWhenStopped = YES;
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	activityIndicator.center = self.view.center;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)dealloc {
	[photoSet release];
	[gridView release];
	[bucketsPopoverController release];
	[activityIndicator release];
    [super dealloc];
}


#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gv {
    return [[photoSet photos] count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gv cellForItemAtIndex:(NSUInteger)index {
    static NSString *EmptyIdentifier = @"EmptyIdentifier";
    static NSString *CellIdentifier = @"CellIdentifier";
    
    if (index == emptyCellIndex) {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell *hiddenCell = [gv dequeueReusableCellWithIdentifier:EmptyIdentifier];
        if ( hiddenCell == nil ) {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[[AQGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0)
                                                reuseIdentifier:EmptyIdentifier] autorelease];
        }
        
        hiddenCell.hidden = YES;
        return hiddenCell;
    }
    
    OrganiserGridCell *cell = (OrganiserGridCell *)[gv dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[OrganiserGridCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0) reuseIdentifier:CellIdentifier];
    }
    
	// Get the model
	Photo *photo = [[photoSet photos] objectAtIndex:index];
	
	// Populate the view
	cell.rating = [photo rating];
	
	AsyncImageView* asyncImage = (AsyncImageView *)cell.imageView;
	if (! asyncImage) {
		asyncImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0)] autorelease];
		cell.imageView = asyncImage;
	}
    [asyncImage loadWithImageId:[photo photoId]];
	
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)gridView {
    return ( CGSizeMake(192.0, 192.0) );
}


#pragma mark AQGridView Delegate

- (void) gridView:(AQGridView *)gv didSelectItemAtIndex:(NSUInteger)index {
	
	// Create photo view controller and link to our photoset
	PagingPhotoViewController *controller = [[PagingPhotoViewController alloc] initWithNibName:nil bundle:nil];
	controller.photoSet = photoSet;
	controller.currentPhotoIndex = index;
	
	// Push it on the navigation stack
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller	release];
}


#pragma mark DAO callback

- (void) didLoadPhotoSet:(PhotoSet *)ps {
	
	// Set instance photoset
	photoSet = ps;
	
	// Set title
	NSString *tmpTitle = @"All photos";
	if (photoSet.bucketIds && [photoSet.bucketIds count] > 0) {
		// TODO multiple buckets
		
		NSString *bucketId = [photoSet.bucketIds objectAtIndex:0];
		if ([bucketId isEqualToString:@"nobucket"])
			tmpTitle = [tmpTitle stringByAppendingString:@" not in a bucket"];
		else {
			BucketFilterViewController *bucketFilterController = (BucketFilterViewController *)(bucketsPopoverController.contentViewController);
			if (bucketFilterController && bucketFilterController.buckets) {
				for (int i=0; i<[bucketFilterController.buckets count]; i++) {
					KeyValuePair *pair = (KeyValuePair *)([bucketFilterController.buckets objectAtIndex:i]);
					if ([bucketId isEqualToString:pair.key]) 
						tmpTitle = [tmpTitle stringByAppendingFormat:@" in \'%@\'",pair.value];
				}
			}
			else {
				tmpTitle = [tmpTitle stringByAppendingFormat:@" in selected buckets"];
			}
		}
	}
	if (photoSet.ratings && [photoSet.ratings count] > 0) {
		NSUInteger rating = [[photoSet.ratings objectAtIndex:0] intValue];
		if (rating == 0)
			tmpTitle = [tmpTitle stringByAppendingString:@" with no rating"];
		else {
			tmpTitle = [tmpTitle stringByAppendingFormat:@" with %d star rating",rating];
		}

	}	
	self.title = [tmpTitle stringByAppendingFormat:@" (%d photos)",photoSet.photos.count];
	
	// Refresh grid data
	[gridView reloadData];
	
	[activityIndicator stopAnimating];
	
}


#pragma mark Button methods

- (void)bucketFilterButtonClicked:(UIBarButtonItem *)button {
	
	if (! bucketsPopoverController) {
		
		// Create buckets view controller (for selecting a bucket)
		BucketFilterViewController *bucketFilterViewController = [[BucketFilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
		bucketFilterViewController.delegate = self;
		
		// Create the popover controller for housing the bucket selector
		bucketsPopoverController = [[UIPopoverController alloc] initWithContentViewController:bucketFilterViewController];
		bucketsPopoverController.popoverContentSize = CGSizeMake(250, 650);
		
		[bucketFilterViewController release];
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

#pragma mark BucketOptionsViewController delegate method

-(void)didSelectBuckets:(NSArray *)bucketIds ratings:(NSArray *)ratings {
	
	[activityIndicator startAnimating];
	
	// Call DAO to get a new list of photos
	[[OrganiserDAO sharedDAO] getPhotosByBuckets:bucketIds ratings:ratings delegate:self];
	
	// Remove popover
	[bucketsPopoverController dismissPopoverAnimated:YES];
	
}


@end

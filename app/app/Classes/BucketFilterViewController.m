//
//  BucketFilterViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 12/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "BucketFilterViewController.h"
#import "OrganiserViewController.h"
#import "OrganiserDAO.h"
#import "KeyValuePair.h"


@implementation BucketFilterViewController

@synthesize buckets;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		selectedBuckets = [[NSMutableArray arrayWithCapacity:8] retain];
		[selectedBuckets addObject:@"nobucket"];
		selectedRatings = [[NSMutableArray arrayWithCapacity:4] retain];
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.hidesWhenStopped = YES;
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);	
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];  // TODO this is not working
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[activityIndicator startAnimating];
	[[OrganiserDAO sharedDAO] getBuckets:self];
}

- (void)viewDidUnload {
	[buckets release];
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return YES;
 }
 */

#pragma mark -
#pragma mark Loaded list delegate methods

- (void)didLoadList:(NSArray *)list {
	// Retrieve a list of buckets from the dao
	self.buckets = list;
	[self.tableView reloadData];
	[activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
		return 3;
	if (section == 1)
		return 5;
    return [buckets count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	if(section == 1)
		sectionHeader = @"Ratings";
	else if(section == 2)
		sectionHeader = @"Buckets";
	return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Unselected by default
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Unbucketed photos";
			if ([self selectedBucketsContains:@"nobucket"])
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"All photos";
			if ([selectedBuckets count] == 0)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			cell.textLabel.text = @"Deleted";
			if ([self selectedBucketsContains:@"trashed"])
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0)
			cell.textLabel.text = @"Unrated";
		else if (indexPath.row == 1)
			cell.textLabel.text = @"1 star";
		else if (indexPath.row == 2)
			cell.textLabel.text = @"2 stars";
		else if (indexPath.row == 3)
			cell.textLabel.text = @"3 stars";
		else
			cell.textLabel.text = @"4 stars";
		NSLog(@"%d",indexPath.row);
		if ([self selectedRatingsContains:[NSNumber numberWithInt:indexPath.row]])
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.textLabel.text = [[buckets objectAtIndex:indexPath.row] value];
		if ([self selectedBucketsContains:[[buckets objectAtIndex:indexPath.row] key]])
			 cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Selection in first section
	if (indexPath.section == 0) {
		// Reset everything
		[selectedBuckets removeAllObjects];
		[selectedRatings removeAllObjects];
		// Only three cases: nobucket, trashed or all photos (empty set)
		if (indexPath.row == 0)
			[selectedBuckets addObject:@"nobucket"];
		else if (indexPath.row == 2)
			[selectedBuckets addObject:@"trashed"];
	}
	// Second section (ratings)
	else if (indexPath.section == 1) {
		if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
			// Add a rating to the list of selected ratings
			[selectedRatings addObject:[NSNumber numberWithUnsignedInt:indexPath.row]];
		}			
		else {
			// Remove a rating
			[self removeFromSelectedRatings:[NSNumber numberWithUnsignedInt:indexPath.row]];
		}
	}	
	// Third section (buckets)
	else {
		if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
			// Remove any global selections
			if ([selectedBuckets containsObject:@"nobucket"] || [selectedBuckets containsObject:@"trashed"]) {
				[selectedBuckets removeAllObjects];
			}
			// Add a bucket to the list
			[selectedBuckets addObject:[[buckets objectAtIndex:indexPath.row] key]];
		}
		else {
			// Remove a bucket from the list
			[self removeFromSelectedBuckets:[[buckets objectAtIndex:indexPath.row] key]];
		}
	}
	[tableView reloadData];
		
	/*
	NSString *bucketId = nil;
	NSUInteger rating = NSUIntegerMax;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0)
			bucketId = @"nobucket";
		else if (indexPath.row == 1) 
			bucketId = nil;
		else
			bucketId = @"trashed";
	}
	else if (indexPath.section == 1) {
		rating = indexPath.row;
	}
	else {
		bucketId = [[buckets objectAtIndex:indexPath.row] key];
	}
	[self.delegate didSelectBucket:bucketId rating:rating];
	 */
	
	[self.delegate didSelectBuckets:selectedBuckets ratings:selectedRatings];
}


- (BOOL)selectedBucketsContains:(NSString *)bucketId {
	NSLog(@"c %d",[selectedBuckets count]);
	for (int i = 0; i < [selectedBuckets count]; i++) {
		if ([[selectedBuckets objectAtIndex:i] isEqualToString:bucketId])
			return YES;
	}
	return NO;
}

- (BOOL)selectedRatingsContains:(NSNumber *)rating {
	for (int i = 0; i < [selectedRatings count]; i++) {
		if ([[selectedRatings objectAtIndex:i] isEqualToNumber:rating])
			return YES;
	}
	return NO;
}

- (void)removeFromSelectedBuckets:(NSString *)bucketId {
	for (int i = 0; i < [selectedBuckets count]; i++) {
		if ([[selectedBuckets objectAtIndex:i] isEqualToString:bucketId])
			[selectedBuckets removeObjectAtIndex:i];
	}
}

- (void)removeFromSelectedRatings:(NSNumber *)rating {
	for (int i = 0; i < [selectedRatings count]; i++) {
		if ([[selectedRatings objectAtIndex:i] isEqualToNumber:rating])
			[selectedRatings removeObjectAtIndex:i];
	}
}	


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[buckets release];
    [super dealloc];
}


@end

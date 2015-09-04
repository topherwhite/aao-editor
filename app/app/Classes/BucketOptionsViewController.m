//
//  BucketOptionsViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 28/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "BucketOptionsViewController.h"
#import "OrganiserViewController.h"
#import "OrganiserDAO.h"
#import "KeyValuePair.h"


@implementation BucketOptionsViewController

@synthesize buckets;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

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


#pragma mark -
#pragma mark Loaded list delegate methods

- (void)didLoadList:(NSArray *)list {
	// Retrieve a list of buckets from the dao
	self.buckets = list;
	[self.tableView reloadData];
	[activityIndicator stopAnimating];
}

#pragma mark Added bucket delegate methods

- (void)didPressAddButton:(NSString *)addedBucketId {
	[self.delegate didSelectBucket:addedBucketId];
	[activityIndicator startAnimating];
	[[OrganiserDAO sharedDAO] getBuckets:self];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([buckets count] > 0) return [buckets count] + 1;
	else return 1;
    return [buckets count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *AddBucketCellIdentifier = @"AddBucketCellIdentifier";
    
	// If it is the last cell then it is a special row for adding buckets
	if (indexPath.row == [buckets count]) {
		AddBucketTableViewCell *cell = (AddBucketTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddBucketCellIdentifier];
		if (cell == nil) {
			cell = [[[AddBucketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddBucketCellIdentifier] autorelease];
			cell.delegate = self;
		}
		/*
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddBucketCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:AddBucketCellIdentifier] autorelease];
			cell.textLabel.text = @"spare cell";
		}*/
		return cell;
	}
	
	// Else it is a normal cell with a label
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[buckets objectAtIndex:indexPath.row] value];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [buckets count]) {
		NSString *bucketId = [[buckets objectAtIndex:indexPath.row] key];
		[self.delegate didSelectBucket:bucketId];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[buckets release];
    [super dealloc];
}


@end


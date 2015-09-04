//
//  MainViewController.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoDao.h"
#import "PhotoSet.h"

@implementation MainViewController

/* Important bit: how to call the dao and get some photos! */

- (void)openOrganiserAction:(id)sender {
	
	// Create our data access object
	PhotoDao *dao = [[PhotoDao alloc] init];
	
	// Make a call to get some photos
	PhotoSet *set = [dao getPhotosByBucket :@"My Bucket"];
	
	// Pull out the number of photos in the set
	int photoCount = set.photos.count;
	
	// Show an alert containing the number of photos
	NSString *myString = [[NSString alloc] initWithFormat:@"%d", photoCount];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Number of photos" message:myString
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

@end

//
//  ThumbsViewController.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThumbsViewController.h"
#import "PhotoViewController.h"
#import "PhotoDao.h"

@implementation ThumbsViewController


- (void) viewDidLoad {
	
	// Create our data access object
	PhotoDao *dao = [[PhotoDao alloc] init];
	
	// Make a call to get some photos
	PhotoSet *set = [dao getPhotosByBucket :@"My Bucket"];
	
    self.photoSource = set;
}

// Override to return a custome TTPhotoViewController
- (TTPhotoViewController*)createPhotoViewController 
{ 
    return [[[PhotoViewController alloc] init] autorelease]; 
} 

@end

//
//  PhotoSet.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"
#import "TBXML.h"


@implementation PhotoSet

@synthesize photos;
@synthesize bucketIds, ratings;


- (void) dealloc {
    [photos release];
	[bucketIds release];
	[ratings release];
    [super dealloc];
}

#pragma mark Helper methods

- (NSInteger)numberOfPhotos {
    return photos.count;
}

- (Photo *)photoAtIndex:(NSUInteger)photoIndex {
    if (photoIndex < photos.count) {
        return [photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}


@end
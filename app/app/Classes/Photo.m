//
//  Photo.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize photoId;
@synthesize originalSize;
@synthesize caption;
@synthesize rating;
@synthesize frame;
@synthesize originalExif;
@synthesize bucketId;

- (id)initWithPhotoId:(NSString *)pId size:(CGSize)size {
    if ((self = [super init])) {
		self.photoId = pId;
        self.originalSize = size;
    }
    return self;
}

- (void) dealloc {
	[photoId release];
	[caption release];
    [super dealloc];
}

@end

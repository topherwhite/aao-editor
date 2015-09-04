//
//  PhotoSet.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotoSet : NSObject {
    NSArray *photos;
	NSArray *bucketIds;
	NSArray *ratings;
}

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSArray *bucketIds;
@property (nonatomic, retain) NSArray *ratings;

- (NSInteger)numberOfPhotos;
- (Photo *)photoAtIndex:(NSUInteger)photoIndex;

@end

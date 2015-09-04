//
//  PhotoSet.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface PhotoSet : TTURLRequestModel <TTPhotoSource> {
    NSString *_title;
    NSArray *_photos;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *photos;

//TODO Remove these (so don't use outside the Dao for now!)
+ (PhotoSet *)samplePhotoSet;
+ (PhotoSet *)aaoDemoPhotoSet;

@end

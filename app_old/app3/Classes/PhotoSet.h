//
//  PhotoSet.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSet : NSObject {
    NSString *_title;
    NSArray *_photos;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *photos;

//TODO Remove these (so don't use outside the Dao for now!)
+ (PhotoSet *)samplePhotoSet;
+ (PhotoSet *)aaoDemoPhotoSet;

@end

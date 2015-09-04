//
//  PhotoDao.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoSet.h"


@interface PhotoDao : NSObject {

}

- (void)setProject:(NSString *)projectId;
- (void)setUser:(NSString *)userId;

- (PhotoSet *)getPhotosByBucket:(NSString *)bucketId;

- (bool)ratePhoto:(NSString *)photoId :(int)rating;
- (bool)bucketPhoto:(NSString *)photoId :(NSString *)bucketId;

- (NSArray *)getBuckets;
- (NSString *)createBucket:(NSString *)name;

@end

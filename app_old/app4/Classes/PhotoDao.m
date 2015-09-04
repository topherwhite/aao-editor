//
//  PhotoDao.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoDao.h"


@implementation PhotoDao

- (void)setProject:(NSString *)projectId {
}

- (void)setUser:(NSString *)userId {
}

- (PhotoSet *)getPhotosByBucket:(NSString *)bucketId {
	
	//TODO Implement querying based on the given bucket id
	
	return [PhotoSet aaoDemoPhotoSet];
}

- (bool)ratePhoto:(NSString *)photoId :(int)rating {
	
}

- (bool)bucketPhoto:(NSString *)photoId :(NSString *)bucketId {
	
}

- (NSArray *)getBuckets {
	
}

- (NSString *)createBucket:(NSString *)name {
	
}



@end

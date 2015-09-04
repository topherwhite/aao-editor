//
//  PhotoDao.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoDao.h"


@implementation PhotoDao

- (PhotoSet *)getPhotosByBucket:(NSString *)bucketId {
	
	//TODO Implement querying based on the given bucket id
	
	return [PhotoSet aaoDemoPhotoSet];
}

@end

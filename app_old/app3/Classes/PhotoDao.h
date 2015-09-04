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

- (PhotoSet *)getPhotosByBucket:(NSString *)bucketId;

@end

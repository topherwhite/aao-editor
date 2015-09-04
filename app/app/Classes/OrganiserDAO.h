//
//  OrganiserDAO.h
//  AAOEditor
//
//  Created by Antony Harfield on 31/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchRequest.h"
#import "UpdateRequest.h"
#import "ListRequest.h"
#import "PhotoMetaRequest.h"

@interface OrganiserDAO : NSObject {

}

+ (OrganiserDAO *)sharedDAO;

- (void)getPhotosByBucket:(NSString *)bucketId delegate:(id<LoadedPhotoSetDelegate>)delegate;
- (void)getPhotosByBucket:(NSString *)bucketId rating:(NSUInteger)rating delegate:(id<LoadedPhotoSetDelegate>)delegate;
- (void)getPhotosByBuckets:(NSArray *)bucketIds ratings:(NSArray *)ratings delegate:(id<LoadedPhotoSetDelegate>)delegate;

- (void)ratePhoto:(NSString *)photoId rating:(NSUInteger)rating delegate:(id<LoadedUpdateResultDelegate>)delegate;
- (void)bucketPhoto:(NSString *)photoId bucketId:(NSString *)bucketId delegate:(id<LoadedUpdateResultDelegate>)delegate;
- (void)positionPhoto:(NSString *)photoId bucketId:(NSString *)bucketId frame:(CGRect)frame delegate:(id<LoadedUpdateResultDelegate>)delegate;
- (void)positionPhoto:(NSString *)photoId bucketId:(NSString *)bucketId point:(CGPoint)point size:(CGSize)size delegate:(id<LoadedUpdateResultDelegate>)delegate;

- (void)getPhotoMeta:(NSString *)photoId delegate:(id<LoadedPhotoMetaDelegate>)delegate;

- (void)getBuckets:(id<LoadedListDelegate>)delegate;
- (void)createBucket:(NSString *)name delegate:(id<LoadedUpdateResultDelegate>)delegate;

- (NSString *)composeProjectAndUserParameterString;

@end

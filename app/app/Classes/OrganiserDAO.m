//
//  OrganiserDAO.m
//  AAOEditor
//
//  Created by Antony Harfield on 31/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "OrganiserDAO.h"
#import "ProjectDAO.h"
#import "NSMutableDataAppend.h"

@implementation OrganiserDAO

static OrganiserDAO *sharedSingleton = nil;


# pragma mark Singleton methods

+ (OrganiserDAO *) sharedDAO {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [[OrganiserDAO alloc] init];
		}
	}
	return sharedSingleton;
}

+ (id) allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [super allocWithZone:zone];
			return sharedSingleton;
		}
	}
	return nil;
}


# pragma mark DAO methods

- (void) getPhotosByBucket:(NSString *)bucketId delegate:(id<LoadedPhotoSetDelegate>)delegate {
		
	[self getPhotosByBucket:bucketId rating:NSUIntegerMax delegate:delegate];
	
}

- (void)getPhotosByBucket:(NSString *)bucketId rating:(NSUInteger)rating delegate:(id<LoadedPhotoSetDelegate>)delegate {
	
	SearchRequest *req = [[SearchRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	if (bucketId) {
		[[req postData] appendString:@"&bucket_id="];
		[[req postData] appendString:bucketId];
	}
	if (rating != NSUIntegerMax) {
		[[req postData] appendFormat:@"&rating=%d",rating];
	}
	
	[req sendRequest];
		
}

- (void)getPhotosByBuckets:(NSArray *)bucketIds ratings:(NSArray *)ratings delegate:(id<LoadedPhotoSetDelegate>)delegate {
	
	SearchRequest *req = [[SearchRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	if ([bucketIds count] > 0) {
		[[req postData] appendString:@"&bucket_id="];
		[[req postData] appendString:[bucketIds componentsJoinedByString:@";"]];
	}
	if ([ratings count] > 0) {
		[[req postData] appendString:@"&rating="];
		[[req postData] appendString:[ratings componentsJoinedByString:@";"]];
	}
	
	[req sendRequest];
	
}

- (void)ratePhoto:(NSString *)photoId rating:(NSUInteger)rating delegate:(id<LoadedUpdateResultDelegate>)delegate {
	
	UpdateRequest *req = [[UpdateRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&action=rate&value="];
	[[req postData] appendString:[NSString stringWithFormat:@"%d",rating]];
	[[req postData] appendString:@"&ids="];
	[[req postData] appendString:photoId];
	
	[req sendRequest];
	
}

- (void)bucketPhoto:(NSString *)photoId bucketId:(NSString *)bucketId delegate:(id<LoadedUpdateResultDelegate>)delegate {

	UpdateRequest *req = [[UpdateRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&action=bucket_image_add&value="];
	[[req postData] appendString:bucketId];
	[[req postData] appendString:@"&ids="];
	[[req postData] appendString:photoId];
	
	[req sendRequest];
	
}

- (void)positionPhoto:(NSString *)photoId bucketId:(NSString *)bucketId frame:(CGRect)frame delegate:(id<LoadedUpdateResultDelegate>)delegate {

	UpdateRequest *req = [[UpdateRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&action=position_scale&bucket_id="];
	[[req postData] appendString:bucketId];
	[[req postData] appendString:@"&ids="];
	[[req postData] appendString:photoId];
	[[req postData] appendString:[NSString stringWithFormat:@"&value=%.0f,%.0f,0,%.0f,%.0f,0",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height]];

	[req sendRequest];
}

- (void)positionPhoto:(NSString *)photoId bucketId:(NSString *)bucketId point:(CGPoint)point size:(CGSize)size delegate:(id<LoadedUpdateResultDelegate>)delegate {

	UpdateRequest *req = [[UpdateRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&action=position_scale&bucket_id="];
	[[req postData] appendString:bucketId];
	[[req postData] appendString:@"&ids="];
	[[req postData] appendString:photoId];
	[[req postData] appendString:[NSString stringWithFormat:@"&value=%.0f,%.0f,0,%.0f,%.0f,0",point.x,point.y,size.width,size.height]];
	
	[req sendRequest];	
}

- (void)getPhotoMeta:(NSString *)photoId delegate:(id<LoadedPhotoMetaDelegate>)delegate {
	
	PhotoMetaRequest *req = [[PhotoMetaRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&ids="]; 
	[[req postData] appendString:photoId];
	
	[req sendRequest];
	
}


- (void)getBuckets:(id<LoadedListDelegate>)delegate {
	
	ListRequest *req = [[ListRequest alloc] initWithDelegate:delegate];

	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&value=bucket"]; 
	
	[req sendRequest];
	
}

- (void)createBucket:(NSString *)name delegate:(id<LoadedUpdateResultDelegate>)delegate {

	UpdateRequest *req = [[UpdateRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:[self composeProjectAndUserParameterString]];
	[[req postData] appendString:@"&action=bucket_create&value="];
	[[req postData] appendString:name];
	
	[req sendRequest];
	
}


# pragma mark Private methods

- (NSString *)composeProjectAndUserParameterString {
	ProjectDAO *dao = [ProjectDAO sharedDAO];
	return [NSString stringWithFormat:@"project_id=%@&user_id=%@",[dao currentProject],[dao currentUser]];
}


@end

//
//  ProjectDAO.m
//  AAOEditor
//
//  Created by Antony Harfield on 05/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "ProjectDAO.h"
#import "NSMutableDataAppend.h"


@implementation ProjectDAO

static ProjectDAO *sharedSingleton = nil;

@synthesize currentProject;
@synthesize currentUser;


# pragma mark Singleton methods

+ (ProjectDAO *) sharedDAO {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [[ProjectDAO alloc] init];
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

- (void)getProjects:(id<LoadedListDelegate>)delegate {
	
	ListRequest *req = [[ListRequest alloc] initWithDelegate:delegate];
	
	[[req postData] appendString:@"value=project"]; 
	
	[req sendRequest];
	
}




@end

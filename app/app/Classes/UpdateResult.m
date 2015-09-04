//
//  UpdateResult.m
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "UpdateResult.h"


@implementation UpdateResult

@synthesize success;
@synthesize message;
@synthesize bucketId;

- (void)dealloc {
	[message release];
	[bucketId release];
	[super dealloc];
}

@end

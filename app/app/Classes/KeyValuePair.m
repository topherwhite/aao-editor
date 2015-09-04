//
//  KeyValuePair.m
//  AAOEditor
//
//  Created by Antony Harfield on 24/08/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "KeyValuePair.h"


@implementation KeyValuePair

@synthesize key;
@synthesize value;

- (id)initWithKey:(NSString *)k value:(NSObject *)v {
	[super init];
	self.key = k;
	self.value = v;
	return self;
}

- (void)dealloc {
	[key dealloc];
	[value dealloc];
	[super dealloc];
}

@end

//
//  TransparentToolbar.m
//  AAOEditor
//
//  Created by Ant on 9/29/10.
//  Copyright 2010 aaoeditor. All rights reserved.
//

#import "TransparentToolbar.h"


@implementation TransparentToolbar

// Override draw rect to avoid background coloring
- (void)drawRect:(CGRect)rect {
    // do nothing in here
}

// Set properties to make background translucent.
- (void) applyTranslucentBackground {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.translucent = YES;
}

// Override init.
- (id) init {
	self = [super init];
	[self applyTranslucentBackground];
	return self;
}

// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	[self applyTranslucentBackground];
	return self;
}

@end
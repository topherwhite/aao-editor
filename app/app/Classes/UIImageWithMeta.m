//
//  UIImageWithMeta.m
//  AAOEditor
//
//  Created by Antony Harfield on 18/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "UIImageWithMeta.h"


@implementation UIImageWithMeta

@synthesize image, imageId, imageSize;
@synthesize tileScale, tileCol, tileRow;

- (id)initWithImageId:(NSString *)imgId size:(ImageSize)size {
    if ((self = [super init])) {
		self.imageId = imgId;
		self.imageSize = size;
		self.tileScale = ImageTileScaleNone;
		self.tileCol = NSUIntegerMax;
		self.tileRow = NSUIntegerMax;
    }
    return self;
}

- (void)dealloc {
	[image release];
	[imageId release];
	[super dealloc];
}


- (id)retain {
	NSLog(@"%@ retain",imageId);
	return [super retain];
}
- (void)release {
	NSLog(@"%@ release",imageId);
	[super release];
}


- (BOOL)isTiled {
	return self.imageSize == ImageSizeTiled;
}

@end

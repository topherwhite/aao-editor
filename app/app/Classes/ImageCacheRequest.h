//
//  ImageCacheRequest.h
//  AAOEditor
//
//  Created by Ant on 9/29/10.
//  Copyright 2010 aaoeditor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
#import "UIImageWithMeta.h"


@interface ImageCacheRequest : NSObject {

	NSObject<LoadedImageDelegate> *delegate;
	UIImageWithMeta *image;
	
}

- (id)initWithImageId:(NSString *)imageId size:(ImageSize)size delegate:(NSObject<LoadedImageDelegate> *) delegate;
- (void)setTiled:(ImageTileScale)scale col:(NSUInteger)col row:(NSUInteger)row;
- (void)sendRequest;

@end

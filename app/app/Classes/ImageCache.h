//
//  ImageCache.h
//  AAOEditor
//
//  Created by Antony Harfield on 14/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageWithMeta.h"


@protocol LoadedImageDelegate
- (void)didLoadImage:(UIImageWithMeta *)result;
@end


@interface ImageCache : NSObject {

}

+ (ImageCache *)sharedCache;

- (UIImage *)getImage:(NSString *)imageId;
- (UIImage *)getImage:(NSString *)imageId size:(ImageSize)size;

- (void)getImage:(NSString *)imageId size:(ImageSize)size delegate:(NSObject<LoadedImageDelegate> *)delegate;
- (void)getTiledImage:(NSString *)imageId scale:(ImageTileScale)scale col:(NSInteger)col row:(NSInteger)row delegate:(NSObject<LoadedImageDelegate> *)delegate;

- (void)clearDiskCache;
- (void)freeUpSpaceInDiskCache;

@end

//
//  UIImageWithMeta.h
//  AAOEditor
//
//  Created by Antony Harfield on 18/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	ImageSizeThumbnail,
	ImageSizeWorking,
	ImageSizeOriginal,
	ImageSizeTiled
} ImageSize;

typedef enum {
	ImageTileScaleNone,
	ImageTileScale1024,
	ImageTileScale2048,
	ImageTileScale4096
} ImageTileScale;


@interface UIImageWithMeta : NSObject {
	
	UIImage *image;
	NSString *imageId;	
	ImageSize imageSize;
	ImageTileScale tileScale;
	NSUInteger tileCol;
	NSUInteger tileRow;
	
}

@property(nonatomic,retain) UIImage *image;
@property(nonatomic,copy) NSString *imageId;
@property(nonatomic,assign) ImageSize imageSize;
@property(nonatomic,assign) ImageTileScale tileScale;
@property(nonatomic,assign) NSUInteger tileCol;
@property(nonatomic,assign) NSUInteger tileRow;

@property(nonatomic,readonly) BOOL isTiled;

- (id)initWithImageId:(NSString *)imgId size:(ImageSize)size;

@end

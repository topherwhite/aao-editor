//
//  ImageCacheRequest.m
//  AAOEditor
//
//  Created by Ant on 9/29/10.
//  Copyright 2010 aaoeditor. All rights reserved.
//

#import "ImageCacheRequest.h"


@implementation ImageCacheRequest

- (id)initWithImageId:(NSString *)imageId size:(ImageSize)size delegate:(NSObject<LoadedImageDelegate> *)del {
	if((self = [super init])) {
		image = [[UIImageWithMeta alloc] initWithImageId:imageId size:size];
		delegate = del;
    }
    return self;
}

- (void)dealloc {
	[image release];
	[super dealloc];
}



- (void)setTiled:(ImageTileScale)scale col:(NSUInteger)col row:(NSUInteger)row {
	image.tileScale = scale;
	image.tileCol = col;
	image.tileRow = row;
}



- (void)sendRequest {
	NSOperationQueue *queue = [NSOperationQueue new];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
				 initWithTarget:self
				 selector:@selector(load) 
				 object:nil];
	[queue addOperation:operation]; 
	[operation release];
	[queue release];
}

- (void)load {
	
	NSString *fileName = image.imageId;

	if (image.isTiled) {
		NSUInteger size;
		switch (image.tileScale) {
			case ImageTileScale1024:
				size = 1024;
				break;
			case ImageTileScale2048:
				size = 2048;
				break;
			case ImageTileScale4096:
				size = 4096;
				break;
		}
		fileName = [fileName stringByAppendingFormat:@"_%d_%d_%d",size,image.tileCol,image.tileRow];
	}
	else {
		switch (image.imageSize) {
			case ImageSizeThumbnail:
				fileName = [fileName stringByAppendingString:@"_180"];
				break;
			case ImageSizeWorking:
				fileName = [fileName stringByAppendingString:@"_2048"];
				break;
			case ImageSizeOriginal:
				fileName = [fileName stringByAppendingString:@"_orig"];
				break;
			default:
				fileName = [fileName stringByAppendingString:@"_1024"];
				break;
		}
	}
	
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@.jpg",fileName];
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	if ([fileMgr fileExistsAtPath:filePath]) {
		// If the image exists on filesystem then return it
		image.image = [UIImage imageWithContentsOfFile:filePath];
	}
	else {
		// Otherwise download the image
		NSString *url = [NSString stringWithFormat:@"http://editor.againstallodds.com/ws/img/%@",fileName];
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		// And save to filesystem for next time
		[imageData writeToFile:filePath atomically:YES];
		image.image = [[UIImage alloc] initWithData:imageData];
		//[imageData release];
	}
	
	// Call back to in the main thread cause its probably going to be updating the UI
	[delegate performSelectorOnMainThread:@selector(didLoadImage:) withObject:image waitUntilDone:YES];
	[self release];
}


@end

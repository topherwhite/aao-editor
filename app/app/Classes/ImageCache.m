//
//  ImageCache.m
//  AAOEditor
//
//  Created by Antony Harfield on 14/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "ImageCache.h"
#import "ImageCacheRequest.h"

@implementation ImageCache


static ImageCache *sharedSingleton = nil;

# pragma mark Singleton methods

+ (ImageCache *) sharedCache {
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [[ImageCache alloc] init];
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


- (id)init {
	if((self = [super init])) {
    }
    return self;
}


#pragma mark Cache methods

- (UIImage *)getImage:(NSString *)imageId {
	return [self getImage:imageId size:ImageSizeThumbnail];
}

- (UIImage *)getImage:(NSString *)imageId size:(ImageSize)size {
	
	// If the image exists on filesystem then return it
	NSString *imageSize = size == ImageSizeThumbnail ? @"180" : @"2048" ;
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@_%@.jpg",imageId,imageSize];
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if ([fileMgr fileExistsAtPath:filePath]) {
		return [UIImage imageWithContentsOfFile:filePath];
	}
	// Otherwise download the image
	NSString *url = [NSString stringWithFormat:@"http://editor.againstallodds.com/ws/img/%@_%@",imageId,imageSize];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	// Save to filesystem for next time
	[imageData writeToFile:filePath atomically:YES];
	// Return image
	UIImage *result = [[UIImage alloc] initWithData:imageData];
	//[imageData release];
	return result;
	
}


- (void)getImage:(NSString *)imageId size:(ImageSize)size delegate:(NSObject<LoadedImageDelegate> *)delegate {
	
	// TODO fix leak
	[[[ImageCacheRequest alloc] initWithImageId:imageId size:size delegate:delegate] sendRequest];

}

- (void)getTiledImage:(NSString *)imageId scale:(ImageTileScale)scale col:(NSInteger)col row:(NSInteger)row delegate:(NSObject<LoadedImageDelegate> *)delegate {
	
	// TODO fix leak
	ImageCacheRequest *request = [[ImageCacheRequest alloc] initWithImageId:imageId size:ImageSizeTiled delegate:delegate];
	[request setTiled:scale col:col row:row];
	[request sendRequest];
}



#pragma mark Cache clearing methods


// Call this to delete all the images in the cache
- (void)clearDiskCache {
	// Path
	NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	// Loop over each file and delete it
	NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
	NSDirectoryEnumerator *en = [fileMgr enumeratorAtPath:cacheDirectory];    
	NSError *err = nil;
	BOOL res;
	NSString *file;
	while (file = [en nextObject]) {
		NSLog(@"Deleting: %@", file);
		res = [fileMgr removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:file] error:&err];
		if (!res && err) {
			NSLog(@"Oops: %@", err);
		}
	}
}

#define DISK_CACHE_MAX_SPACE_IN_MB = 100;

- (void)freeUpSpaceInDiskCache {
	
}

@end

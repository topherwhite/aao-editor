//
//  Photo.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject {
	
	// Common properties
	NSString *photoId;
    CGSize originalSize;
    NSString *caption;
	NSInteger rating;
	CGRect frame;
	
	NSString *bucketId;
	
	// Meta properties
	NSString *originalExif;
}

@property (nonatomic, copy) NSString *photoId;
@property (nonatomic) CGSize originalSize;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic) NSInteger rating;
@property (nonatomic) CGRect frame;

@property (nonatomic, copy) NSString *bucketId;

@property (nonatomic, retain) NSString *originalExif;

- (id)initWithPhotoId:(NSString *)photoId size:(CGSize)size;

@end

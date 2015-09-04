//
//  AsyncImageView.h
//  AAOEditor
//
//  Created by Ant on 9/29/10.
//  Copyright 2010 aaoeditor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"

@interface AsyncImageView : UIView <LoadedImageDelegate> {
	
	UIActivityIndicatorView *activityIndicator;
	NSString *requestedImageId;
}

- (void)loadWithImageId:(NSString *)imageId;

@property(nonatomic,copy) NSString *requestedImageId;

@end

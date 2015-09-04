//
//  ScrollableImageView.h
//  AAOEditor
//
//  Created by Ant on 9/23/10.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"


@interface ScrollableImageView : UIScrollView <UIScrollViewDelegate,LoadedImageDelegate> {

    UIView *imageView;
	UIActivityIndicatorView *activityIndicator;
	
	NSUInteger index;
	NSString *photoId;
	
}

@property (retain) UIView *imageView;
@property (nonatomic) NSUInteger index;
@property (nonatomic,assign) NSString *photoId;

- (void)setMaxMinZoomScalesForCurrentBounds;

- (void)wipeImageView;

@end

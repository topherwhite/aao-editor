//
//  ScrollableImageView.m
//  AAOEditor
//
//  Created by Ant on 9/23/10.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "ScrollableImageView.h"
#import "TiledImageView.h"


@implementation ScrollableImageView


@synthesize index;
@synthesize imageView;
@synthesize photoId;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		
		imageView = [[UIImageView alloc] init];
		[self addSubview:imageView];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
		activityIndicator.hidesWhenStopped = YES;
		[self addSubview:activityIndicator];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
	NSLog(@"%f %f",self.bounds.size.width/2,self.bounds.size.height/2);
	activityIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //if ([imageView isKindOfClass:[TilingView class]]) {
        // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
        // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
        // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
        //imageView.contentScaleFactor = 1.0;
    //}
}


- (void)dealloc {
    [imageView release];
    [super dealloc];
}


- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        //minScale = maxScale; // Remove this so we can zoom past when it gets pixelated
    }
    
    self.maximumZoomScale = 8.0; //maxScale; // Fix this so we can zoom past when it gets pixelated
    self.minimumZoomScale = minScale;
}


- (void)wipeImageView {
    // clear the previous imageView
    [imageView removeFromSuperview];
    //[imageView release];
    imageView = nil;
	// set activity indicator
	[activityIndicator startAnimating];
	activityIndicator.center = self.center;
}

#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}


#pragma mark Image cache delegate methods

- (void)didLoadImage:(UIImageWithMeta *)result {
	
	NSLog(@"%@ %@",result.imageId,self.photoId);

	// Don't do anything if it is not the correct image
	if (![result.imageId isEqualToString:self.photoId])
		return;
		
    // Clear the previous imageView
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    
    // Reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
	// Create new imageView
	imageView = [[UIImageView alloc] initWithImage:result.image];
	[self addSubview:imageView];
	
	// Resize and set zoom
	[self.imageView sizeToFit];
	self.contentSize = result.image.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
	
	[activityIndicator stopAnimating];
}

@end

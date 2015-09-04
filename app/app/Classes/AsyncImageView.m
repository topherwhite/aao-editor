//
//  AsyncImageView.m
//  AAOEditor
//
//  Created by Ant on 9/29/10.
//  Copyright 2010 aaoeditor. All rights reserved.
//

#import "AsyncImageView.h"
#import "UIImageWithMeta.h"

@implementation AsyncImageView

@synthesize requestedImageId;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
		activityIndicator.center = self.center;
		activityIndicator.hidesWhenStopped = YES;
		[self addSubview:activityIndicator];
	}
	return self;
}

- (void)dealloc {
	[activityIndicator release];
	[super dealloc];  // TODO work out why it crashes here on scrolling
}


- (void)loadWithImageId:(NSString *)imageId {
	
	// If there was an existing image then remove it
	UIView *imageView = [self viewWithTag:1];
	if (imageView) {
		[imageView removeFromSuperview];
	}
	
	[activityIndicator startAnimating];
	
	// Asyncronously grab the image
	self.requestedImageId = imageId;
	[[ImageCache sharedCache] getImage:imageId size:ImageSizeThumbnail delegate:self];
	
	NSLog(@"Grab imageId:%@:", imageId);
}

- (void)didLoadImage:(UIImageWithMeta *)result {
	
	if (! [requestedImageId isEqualToString:result.imageId]) {
		[result release];
		return;
	}
	
    UIImageView *imageView = [[UIImageView alloc] initWithImage:result.image];
	
    imageView.contentMode = UIViewContentModeScaleAspectFit;
	//imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	imageView.clipsToBounds = YES;
	imageView.backgroundColor = [UIColor clearColor];
	imageView.opaque = NO;
	imageView.frame = self.bounds;
	imageView.tag = 1;
    [self addSubview:imageView];
	[imageView release];

	[activityIndicator stopAnimating];

	NSLog(@"Grab imageId:%@: done", result.imageId);
	
}


@end

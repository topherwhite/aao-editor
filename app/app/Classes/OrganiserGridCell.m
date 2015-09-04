//
//  OrganiserGridCell.m
//  AAOEditor
//
//  Created by Antony Harfield on 12/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "OrganiserGridCell.h"


@implementation OrganiserGridCell


#pragma mark Initialisation and Release

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self == nil)
        return nil;
	
	// Make cell transparent
	self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.opaque = NO;
    self.opaque = NO;
	
	ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 90.0, 30.0)];
	//ratingLabel.opaque = NO;
	ratingLabel.backgroundColor = [UIColor clearColor];
	ratingLabel.textColor = [UIColor whiteColor];
	ratingLabel.font = [UIFont boldSystemFontOfSize:14.0];
	ratingLabel.text = @"";
	[self.contentView addSubview:ratingLabel];
	
	return self;
}

- (void)dealloc {
	[ratingLabel release];
	[imageView release];
	[super dealloc];
}

- (void) prepareForReuse {
	//[imageView release];
	[super prepareForReuse];
}


#pragma mark Properties

- (UIView *)imageView {
	return imageView;
}

- (void)setImageView:(UIView *)iv {
	if (imageView) {
		// TODO I think we should be removing and releasing the previous imageView
		//[imageView removeFromSuperview];
		//[imageView release];
	}
	imageView = iv;
	[self.contentView insertSubview:imageView atIndex:0];
}

//TODO can we remove this?
- (NSUInteger)rating {
	return 0;
}

- (void)setRating:(NSUInteger)rating {
	if (rating != 0) {
		ratingLabel.text = [NSString stringWithFormat:@"%d stars",rating];
	}
	else {
		ratingLabel.text = @"Unrated";
	}
}


@end

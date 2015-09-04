//
//  OrganiserGridCell.h
//  AAOEditor
//
//  Created by Antony Harfield on 12/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"


@interface OrganiserGridCell : AQGridViewCell {

	UIView *imageView;
	UILabel *ratingLabel;
	
}

@property(nonatomic,assign) UIView *imageView;
@property(nonatomic) NSUInteger rating;

@end

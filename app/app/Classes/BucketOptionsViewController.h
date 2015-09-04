//
//  BucketOptionsViewController.h
//  AAOEditor
//
//  Created by Antony Harfield on 28/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListRequest.h"
#import "AddBucketTableViewCell.h"


@protocol BucketOptionsViewControllerDelegate <NSObject>

-(void)didSelectBucket:(NSString *)string;

@end


@interface BucketOptionsViewController : UITableViewController <LoadedListDelegate, AddButtonPressedDelegate> {

	NSArray *buckets;
	id delegate;
	
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) NSArray *buckets;
@property (nonatomic, assign) id<BucketOptionsViewControllerDelegate> delegate;

@end
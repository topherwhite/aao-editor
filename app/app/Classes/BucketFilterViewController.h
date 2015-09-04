//
//  BucketFilterViewController.h
//  AAOEditor
//
//  Created by Antony Harfield on 12/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListRequest.h"


@protocol BucketFilterViewControllerDelegate <NSObject>

- (void)didSelectBuckets:(NSArray *)bucketIds ratings:(NSArray *)ratings;

@end


@interface BucketFilterViewController : UITableViewController <LoadedListDelegate> {

	NSArray *buckets;
	id<BucketFilterViewControllerDelegate> delegate;

	UIActivityIndicatorView *activityIndicator;
	
	NSMutableArray *selectedBuckets;
	NSMutableArray *selectedRatings;
}
	
@property (nonatomic, retain) NSArray *buckets;	
@property (nonatomic, assign) id<BucketFilterViewControllerDelegate> delegate;
	
- (BOOL)selectedBucketsContains:(NSString *)bucketId;
- (BOOL)selectedRatingsContains:(NSNumber *)rating;
- (void)removeFromSelectedBuckets:(NSString *)bucketId;
- (void)removeFromSelectedRatings:(NSNumber *)rating;

@end

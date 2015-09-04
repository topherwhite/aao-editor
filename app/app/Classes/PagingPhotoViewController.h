//
//  PagingPhotoViewController.h
//  AAOEditor
//
//  Created by Ant on 9/23/10.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollableImageView.h"
#import "PhotoSet.h"
#import "Photo.h"
#import "BucketOptionsViewController.h"
#import "UpdateRequest.h"

@interface PagingPhotoViewController : UIViewController <UIScrollViewDelegate, BucketOptionsViewControllerDelegate, LoadedUpdateResultDelegate> {

	UIScrollView *pagingScrollView;
	
	PhotoSet *photoSet;
	NSUInteger currentPhotoIndex;
	
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;
															
	// stored so we can adjust the scroll offset after rotation
	int firstVisiblePageIndexBeforeRotation;
	
	NSMutableArray *starButtons;

	UIPopoverController *bucketsPopoverController;
	UIPopoverController *photoMetaPopoverController;
	
}

@property(nonatomic,retain) PhotoSet *photoSet;
@property(nonatomic) NSUInteger currentPhotoIndex;
@property(readonly) Photo *currentPhoto;

- (Photo *)currentPhoto;

- (CGRect)pagingScrollViewFrame;
- (CGSize)pagingScrollViewContentSize;
- (CGRect)pageFrameForIndex:(NSUInteger)index;
- (void)configurePage:(ScrollableImageView *)page forIndex:(NSUInteger)index;
- (void)tilePages;
- (ScrollableImageView *)dequeueRecycledPage;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (void)setStarButtonsRating;

@end

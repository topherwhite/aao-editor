//
//  LayingOutViewController.h
//  PhotoOrganiser
//
//  Created by JD on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Photo.h"
#import "PhotoSet.h"
#import "SearchRequest.h"
#import "UpdateRequest.h"
#import "BucketFilterViewController.h"
#import "BucketOptionsViewController.h"

@interface LayingOutViewController : UIViewController<UIScrollViewDelegate, 
														UIGestureRecognizerDelegate, 
														LoadedPhotoSetDelegate, 
														LoadedUpdateResultDelegate, 
														BucketFilterViewControllerDelegate,
														BucketOptionsViewControllerDelegate> 
{
	
	UIView *canvasView;
		
	UIScrollView *scrollView;
	PhotoSet *myPhotoSet;
	
	UIActivityIndicatorView *activityIndicator;	
	UIPopoverController *popoverBuckets;
	UIPopoverController *popoverPictures;
	
	int kScreenWidth; int kScreenHeight; // Device size in portrait mode 
	int kContentWidth; int kContentHeight; // Content size in portrait mode
	
	int kScreenSizeX; int kScreenSizeY; // Device size (depending of the orientation)
	int kContentSizeX; int kContentSizeY; // Content size (depending of the orientation)
	
	NSMutableArray *starButtons;
	NSMutableArray *aCanvasPicsSelected;
	NSMutableArray *aCanvasPics;

}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *canvasView;
@property (nonatomic, retain) PhotoSet *myPhotoSet;

- (void)addGestureRecognizersToPiece:(UIView *)piece;
- (void)drawCanvasArea:(CGRect)rect;
- (void)setToolbar;

@end

//
//  OrganiserViewController.h
//  AAOEditor
//
//  Created by Antony Harfield on 12/09/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "OrganiserDAO.h"
#import "BucketFilterViewController.h"

@interface OrganiserViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, LoadedPhotoSetDelegate, BucketFilterViewControllerDelegate> {
	
	AQGridView *gridView;
    NSUInteger emptyCellIndex;

	PhotoSet *photoSet;

	UIActivityIndicatorView *activityIndicator;	
	UIPopoverController *bucketsPopoverController;
}

@end

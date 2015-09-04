//
//  OpenProjectViewController.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/12/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDAO.h"


@interface OpenProjectViewController : UIViewController <UIScrollViewDelegate, LoadedListDelegate> {

	UILabel *projectName;
	UIScrollView *scrollView;
	UIActivityIndicatorView *activityIndicator;
	UILabel *activityIndicatorLoading;
	
	UIView *settingsView;
	
	NSArray *projectList;
	NSArray *scrollPages;
	
}

@property(nonatomic,retain) IBOutlet UILabel *projectName;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UILabel *activityIndicatorLoading;

@property(nonatomic,retain) IBOutlet UIView *settingsView;

- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)clearCache:(id)sender;

@end

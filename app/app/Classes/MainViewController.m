//
//  MainViewController.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "MainViewController.h"
#import "ProjectDAO.h"
#import "OrganiserDAO.h"
#import "AAOEditorAppDelegate.h"
#import "OrganiserViewController.h"
#import "LayingOutViewController.h"
#import "OpenProjectViewController.h"
#import "ImageCache.h"

@implementation MainViewController


#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



- (void)openOrganiserAction:(id)sender {
	[self.navigationController pushViewController:[[OrganiserViewController alloc] init] animated:YES];
}
- (void)gotoLayingOut:(id)sender {
	[self.navigationController pushViewController:[[LayingOutViewController alloc] init] animated:YES];
}



@end

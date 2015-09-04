//
//  WelcomeViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 11/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AAOEditorAppDelegate.h"
#import "OpenProjectViewController.h"

@implementation WelcomeViewController



- (IBAction)login:(id)sender {
	
	//UINavigationController *navController = [(AAOEditorAppDelegate *)[[UIApplication sharedApplication] delegate] navController];
	//[navController pushViewController:[[MainViewController alloc] initWithNibName:@"MainView" bundle:[NSBundle mainBundle]] animated:YES];
	
	[self.navigationController pushViewController:[[OpenProjectViewController alloc] initWithNibName:@"OpenProjectViewController" bundle:[NSBundle mainBundle]] animated:YES];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Welcome";
}

- (void)viewWillAppear:(BOOL)animated {
	// Hide the toolbar
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	// Show the toolbar
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	
	[super viewWillDisappear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

//
//  MainViewController.m
//  app2
//
//  Created by Antony Harfield on 03/06/2010.
//  Copyright Antony Harfield 2010. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoPickerTableViewController.h"
#import "app2AppDelegate.h"

@implementation MainViewController

- (IBAction)openTableAction:(id)sender {
	PhotoPickerTableViewController *controller = [[PhotoPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
	app2AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:controller animated:YES];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

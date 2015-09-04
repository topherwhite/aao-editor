//
//  OpenProjectViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 04/12/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OpenProjectViewController.h"
#import "KeyValuePair.h"
#import "ImageCache.h"
#import "MainViewController.h"

@implementation OpenProjectViewController


@synthesize projectName, scrollView, activityIndicator, activityIndicatorLoading;
@synthesize settingsView;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	scrollView.hidden = YES;
	projectName.hidden = YES;
	[activityIndicator startAnimating];
	activityIndicatorLoading.hidden = NO;
	
	[[ProjectDAO sharedDAO] getProjects:self];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



#pragma mark Scroll view delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
	
	NSLog(@"Ended paging");
	
	NSUInteger page = [self currentPage];
	
	self.title = [NSString stringWithFormat:@"My Projects (%d of %d)",page+1,[projectList count]];
	self.projectName.text = (NSString *) [(KeyValuePair *)[projectList objectAtIndex:page] value];
	
}

- (NSUInteger)currentPage {
	CGFloat pageWidth = scrollView.frame.size.width;
	NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;	
	return page;
}

- (KeyValuePair *)currentProject {
	NSUInteger page = [self currentPage];
	if (page < [projectList count])
		return (KeyValuePair *)[projectList objectAtIndex:page];
	return nil;
}

#pragma mark Project DAO delegate methods

- (void)didLoadList:(NSArray *)list {

	// Release previous list of projects and set new one
	if (projectList)
		[projectList release];
	projectList = [list retain];

	// TODO release existing scroll pages!
	
	// Set up scroll view
	scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * [list count], scrollView.bounds.size.height);
	for (int i = 0; i < [list count]; i++) {
		
		// Create new image views
		UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width * i)+20, 0.0, scrollView.bounds.size.width - 46.0, scrollView.bounds.size.height-6.0)];
		page.clipsToBounds = YES;
		page.contentMode = UIViewContentModeScaleAspectFill;
		page.layer.cornerRadius = 16.0;
		page.layer.masksToBounds = YES;
		page.layer.borderColor = [UIColor lightGrayColor].CGColor;
		page.layer.borderWidth = 1.0;
		// TODO decide how to load an image for the project
		switch (i%3) {
			case 0:
				page.image = [UIImage imageNamed:@"swcij.jpg"];
				break;
			case 1:
				page.image = [UIImage imageNamed:@"glhym.jpg"];
				break;
			default:
				page.image = [UIImage imageNamed:@"csgkl.jpg"];
				break;
		}
		
		// Add gesture recogniser for tap (to load project)
		/*
		page.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(projectImageTapped:)];
		[page addGestureRecognizer:tap];
		[tap release];
		*/
		
		// Add a shadow
		UIView* shadowView = [[UIView alloc] init];
		shadowView.layer.cornerRadius = 8.0;
		shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
		shadowView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
		shadowView.layer.shadowOpacity = 0.5f;
		shadowView.layer.shadowRadius = 3.0f;
		[shadowView addSubview:page];
	
		[scrollView addSubview:shadowView];
		
		[scrollPages addObject:page];
	}	
	
	// Add a tap recogniser to the scroll view
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(projectImageTapped:)];
	[scrollView addGestureRecognizer:tap];
	[tap release];
	
	
	self.title = [NSString stringWithFormat:@"My Projects (1 of %d)",[list count]];
	self.projectName.text = (NSString *) [(KeyValuePair *)[list objectAtIndex:0] value];
	
	[activityIndicator stopAnimating];
	activityIndicatorLoading.hidden = YES;
	scrollView.hidden = NO;
	projectName.hidden = NO;
	
	
}


#pragma mark View button actions

- (IBAction)infoButtonPressed:(id)sender {
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	
	[self.view addSubview:settingsView];
	[UIView commitAnimations];
	
}

- (IBAction)backButtonPressed:(id)sender {
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	
	[settingsView removeFromSuperview];
	[UIView commitAnimations];
	
}


- (IBAction)clearCache:(id)sender {
	
	[[ImageCache sharedCache] clearDiskCache];
	
}


#pragma mark Other methods

- (void)projectImageTapped:(id)sender {
	
	[[ProjectDAO sharedDAO] setCurrentProject:[[self currentProject] key]];
	[[ProjectDAO sharedDAO] setCurrentUser:@"kzoiz"];
	
	MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:[NSBundle mainBundle]];
	controller.title = (NSString *)[(KeyValuePair *)[projectList objectAtIndex:[self currentPage]] value];
	[self.navigationController pushViewController:controller animated:YES];
	
	
}

@end

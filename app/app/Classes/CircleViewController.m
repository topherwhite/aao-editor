//
//  CircleViewController.m
//  Circle
//
//  Created by jeff on 4/28/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "CircleViewController.h"


@implementation CircleViewController

- (void) viewDidLoad {
	self.view.backgroundColor = [UIColor grayColor];
	self.view.userInteractionEnabled = TRUE	;
	CGRect viewRect = CGRectMake(0, 0, 768, 1024);
	circle = [[CircleView alloc] initWithFrame:viewRect];
	
	circle.opaque = YES; // explicitly opaque for performance
	circle.userInteractionEnabled = YES;
	[self.view addSubview:circle]; 
	
	circle.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 20)];
	circle.label.text = @"Scientific Name:";
	circle.label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
	[self.view addSubview:circle.label];
	[circle.label release];	
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}

@end

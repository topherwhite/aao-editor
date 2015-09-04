//
//  PhotoMetaViewController.m
//  AAOEditor
//
//  Created by Antony Harfield on 20/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "PhotoMetaViewController.h"


@implementation PhotoMetaViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  
	[super loadView];
	
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 400, 700)];  
	webView.backgroundColor = [UIColor whiteColor];   
	[self.view addSubview:webView];  
 
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
	[webView release];
    [super dealloc];
}



- (void)loadForPhotoId:(NSString *)photoId {
	[[OrganiserDAO sharedDAO] getPhotoMeta:photoId delegate:self];
}


- (void)didLoadPhotoMeta:(Photo *)photo {
	[photo retain];
	[webView loadHTMLString:photo.originalExif baseURL:[NSURL URLWithString:@"http://editor.againstallodds.com/test"]];  	
}



@end

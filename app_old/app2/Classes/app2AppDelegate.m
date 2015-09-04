//
//  app2AppDelegate.m
//  app2
//
//  Created by Antony Harfield on 03/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "app2AppDelegate.h"
#import "MainViewController.h"

@implementation app2AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:navController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
	[navController release];
    [window release];
    [super dealloc];
}


@end

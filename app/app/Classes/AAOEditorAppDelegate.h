//
//  AAOEditorAppDelegate.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright PadCraft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAOEditorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end


//
//  PhotoOrganiserAppDelegate.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoOrganiserAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


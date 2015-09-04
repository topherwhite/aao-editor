//
//  MainViewController.h
//  PhotoOrganiser
//
//  Created by Antony Harfield on 17/08/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrganiserDAO.h"
#import "ImageCacheRequest.h"

@interface MainViewController : UIViewController <LoadedUpdateResultDelegate> {

}

- (IBAction)openOrganiserAction:(id)sender;
- (IBAction)gotoLayingOut:(id)sender;

@end

//
//  PhotoMetaViewController.h
//  AAOEditor
//
//  Created by Antony Harfield on 20/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganiserDAO.h"

@interface PhotoMetaViewController : UIViewController <LoadedPhotoMetaDelegate> {

	UIWebView *webView;
	
}


- (void)loadForPhotoId:(NSString *)photoId;


@end

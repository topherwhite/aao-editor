//
//  PhotoPickerTableViewController.h
//  app2
//
//  Created by Antony Harfield on 03/06/2010.
//  Copyright 2010 Antony Harfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDao.h"


@interface PhotoPickerTableViewController : UITableViewController {
	
	NSArray *photos;
	PhotoDao *dao;
}

@end

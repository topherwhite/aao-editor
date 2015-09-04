//
//  AddBucketTableViewCell.h
//  AAOEditor
//
//  Created by Antony Harfield on 24/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganiserDAO.h"


@protocol AddButtonPressedDelegate

- (void)didPressAddButton:(NSString *)addedBucketId;

@end




@interface AddBucketTableViewCell : UITableViewCell <LoadedUpdateResultDelegate> {

	UITextField *textField;
	
	id<AddButtonPressedDelegate> delegate;
	
}

- (void)buttonSelected:(id)sender;

@property(nonatomic,assign) id<AddButtonPressedDelegate> delegate;

@end

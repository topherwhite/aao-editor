//
//  AddBucketTableViewCell.m
//  AAOEditor
//
//  Created by Antony Harfield on 24/10/2010.
//  Copyright 2010 PadCraft. All rights reserved.
//

#import "AddBucketTableViewCell.h"


@implementation AddBucketTableViewCell


@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		// Make the cell not highlight on selection
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		// Add text field
		textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 5.0, 165.0, 34.0)];
		textField.placeholder = @"New bucket";
		textField.borderStyle = UITextBorderStyleRoundedRect;
		[self.contentView addSubview:textField];
		//[textField retain];
		
		// Add button
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = CGRectMake(180.0, 5.0, 64.0, 34.0);
		[button setTitle:@"Add" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:button];
    }
    return self;
}


- (void)dealloc {
	//[textField release];
    [super dealloc];
}


- (void)buttonSelected:(id)sender {
	
	// Stop user
	textField.enabled = NO;
	//TODO disable button or disable whole cell
	
	NSString *bucketName = textField.text;
	[[OrganiserDAO sharedDAO] createBucket:bucketName delegate:self];
	
}

- (void)didLoadUpdateResult:(UpdateResult *)result {
	
	// Check it succeeded and we have a new bucket id
	NSString *bucketId;
	if (result.success) {
		bucketId = result.bucketId;
		textField.text = nil;
	}
	
	// Call back
	[delegate didPressAddButton:bucketId];
	
	// Tidy up
	textField.enabled = YES;
}


@end

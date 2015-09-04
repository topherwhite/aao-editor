//
//  UpdateRequest.m
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "UpdateRequest.h"
#import "TBXML.h"

@implementation UpdateRequest

@synthesize delegate;

- (id)initWithDelegate:(id<LoadedUpdateResultDelegate>)del {	
	if((self = [super initWithCommand:@"update"])) {
		self.delegate = del;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
	
	// Object to be passed to the delegate
	UpdateResult *result = [[UpdateResult alloc] init];
	
	// Default to fail
	result.success = false;
	
	// Load XML from received data
	TBXML *tbxml = [[TBXML tbxmlWithXMLData:receivedData] retain];
	
	// If TBXML found a root node, process element and iterate over children
	if (tbxml.rootXMLElement
			&& [[TBXML elementName:tbxml.rootXMLElement] isEqualToString:@"editor"]
			&& tbxml.rootXMLElement->firstChild) {
			
		TBXMLElement *element = tbxml.rootXMLElement->firstChild;
		
		NSString *elementname = [TBXML elementName:element];
		if ([elementname isEqualToString:@"query"]) {
			
			// Populate result object
			result.success = [[TBXML valueOfAttributeNamed:@"success" forElement:element] boolValue];
			result.message = [TBXML valueOfAttributeNamed:@"action" forElement:element];
			result.bucketId = [TBXML valueOfAttributeNamed:@"bucket_id" forElement:element];
			
		}
	}
	[tbxml release];
	
	[delegate didLoadUpdateResult:result];
}


@end

//
//  ListRequest.m
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "ListRequest.h"
#import "TBXML.h"
#import "KeyValuePair.h"

@implementation ListRequest

@synthesize delegate;

- (id)initWithDelegate:(id<LoadedListDelegate>)del {	
	if((self = [super initWithCommand:@"list"])) {
		self.delegate = del;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
	
	// Object to be passed to the delegate
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:1024];
	
	// Load XML from received data
	TBXML *tbxml = [[TBXML tbxmlWithXMLData:receivedData] retain];
	
	// If TBXML found a root node, process element and iterate over children
	if (tbxml.rootXMLElement
		&& [[TBXML elementName:tbxml.rootXMLElement] isEqualToString:@"editor"]) {
		
		// Get the first element
		TBXMLElement *element = tbxml.rootXMLElement->firstChild;
		
		while (element) {
		
			NSString *elementname = [TBXML elementName:element];
			
			if ([elementname isEqualToString:@"project"]) {
				
				// Create a project object and add it to the array
				KeyValuePair *kvp = [[KeyValuePair alloc] init];
				kvp.key = [TBXML valueOfAttributeNamed:@"project_id" forElement:element];
				kvp.value = [TBXML valueOfAttributeNamed:@"title" forElement:element];
				[result addObject:kvp];
				
			}
			else if ([elementname isEqualToString:@"bucket"]) {
				
				// Create a bucket object and add it to the array
				KeyValuePair *kvp = [[KeyValuePair alloc] init];
				kvp.key = [TBXML valueOfAttributeNamed:@"bucket_id" forElement:element];
				kvp.value = [TBXML valueOfAttributeNamed:@"title" forElement:element];
				[result addObject:kvp];
				
			}
			else if ([elementname isEqualToString:@"origin"]) {
				//TODO			
			}
			else if ([elementname isEqualToString:@"user"]) {
				//TODO
			}
			
			// Move to next element
			element = element->nextSibling;

		}
	}
	[tbxml release];
	
	[delegate didLoadList:result];
}


@end

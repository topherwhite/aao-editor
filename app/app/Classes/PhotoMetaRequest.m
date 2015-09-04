//
//  PhotoMetaRequest.m
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "PhotoMetaRequest.h"
#import "TBXML.h"


@implementation PhotoMetaRequest

@synthesize delegate;


- (id)initWithDelegate:(id<LoadedPhotoMetaDelegate>)del {	
	if((self = [super initWithCommand:@"meta"])) {
		self.delegate = del;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
	
	// Parse the received XML
	
	Photo *photo;
	
	// Load XML from received data
	TBXML *tbxml = [[TBXML tbxmlWithXMLData:receivedData] retain];
	
	// If TBXML found a root node, process element and iterate over children
	if (tbxml.rootXMLElement && [[TBXML elementName:tbxml.rootXMLElement] isEqualToString:@"editor"]) {
			
		TBXMLElement *element = tbxml.rootXMLElement->firstChild;
		
		if (element && [[TBXML elementName:element] isEqualToString:@"image"]) {
				
			// grab all the attributes
			NSString *imageId;
			int width, height, rating;
			NSString *originalExif;
			imageId = [TBXML valueOfAttributeNamed:@"image_id" forElement:element];
			width = [[TBXML valueOfAttributeNamed:@"width" forElement:element] intValue];
			height = [[TBXML valueOfAttributeNamed:@"height" forElement:element] intValue];
			rating = [[TBXML valueOfAttributeNamed:@"rating" forElement:element] intValue];
			
			TBXMLElement *subElement = element->firstChild;
			if (subElement && [[TBXML elementName:subElement] isEqualToString:@"orig_exif"]) {
				originalExif = [TBXML textForElement:subElement];
			}
			
			// create photo object and set the default properties
			photo = [[[Photo alloc] initWithPhotoId:imageId size:CGSizeMake(width, height)] autorelease];
			photo.rating = rating;
			photo.originalExif = originalExif;
			
			// we might have some bucket related origin/size
			float bucket_position_x, bucket_position_y, bucket_width, bucket_height;
			bucket_position_x = [[TBXML valueOfAttributeNamed:@"position_x" forElement:element] floatValue];
			bucket_position_y = [[TBXML valueOfAttributeNamed:@"position_y" forElement:element] floatValue];
			bucket_width = [[TBXML valueOfAttributeNamed:@"position_wd" forElement:element] floatValue];
			bucket_height = [[TBXML valueOfAttributeNamed:@"position_ht" forElement:element] floatValue];
			if (bucket_position_x && bucket_position_y && bucket_width && bucket_height) 
				photo.frame = CGRectMake(bucket_position_x, bucket_position_y, bucket_width, bucket_height);

		}
		else {
			// strange tag
		}
			
	}
	[tbxml release];
		
	[delegate didLoadPhotoMeta:photo];
	[photo release];
}


@end

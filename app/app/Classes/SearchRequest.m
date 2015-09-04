//
//  SearchRequest.m
//  AAOEditor
//
//  Created by Antony Harfield on 03/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "SearchRequest.h"
#import "TBXML.h"
#import "Photo.h"

@implementation SearchRequest

@synthesize delegate;

- (id)initWithDelegate:(id<LoadedPhotoSetDelegate>)del {	
	if((self = [super initWithCommand:@"search"])) {
		self.delegate = del;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
	
	// Parse the received XML
	// Initial array to store images
	NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1024];
	NSArray *bucketIds;
	NSArray *ratings;
	
	// Load XML from received data
	TBXML *tbxml = [[TBXML tbxmlWithXMLData:receivedData] retain];
	
	// If TBXML found a root node, process element and iterate over children
	if (tbxml.rootXMLElement) {
		
		if ([[TBXML elementName:tbxml.rootXMLElement] isEqualToString:@"editor"]) {
			
			// Grab the attributes from the root element
			bucketIds = [[TBXML valueOfAttributeNamed:@"bucket_id" forElement:tbxml.rootXMLElement] componentsSeparatedByString:@";"];
			ratings = [[TBXML valueOfAttributeNamed:@"rating" forElement:tbxml.rootXMLElement] componentsSeparatedByString:@";"];
			
			// Loop through results
			TBXMLElement *element = tbxml.rootXMLElement->firstChild;
			while (element) {
				
				NSString *elementname = [TBXML elementName:element];
				
				if ([elementname isEqualToString:@"image"]) {
					
					// grab all the attributes
					NSString *imageId, *bucketId;
					int width, height, rating;
					imageId = [TBXML valueOfAttributeNamed:@"image_id" forElement:element];
					width = [[TBXML valueOfAttributeNamed:@"width" forElement:element] intValue];
					height = [[TBXML valueOfAttributeNamed:@"height" forElement:element] intValue];
					rating = [[TBXML valueOfAttributeNamed:@"rating" forElement:element] intValue];
					
					bucketId = [TBXML valueOfAttributeNamed:@"bucket_id" forElement:element];
					
					// create photo object and set the default properties
					Photo *photo = [[[Photo alloc] initWithPhotoId:imageId size:CGSizeMake(width, height)] autorelease];
					photo.rating = rating;
					if (bucketId) photo.bucketId = bucketId;
					
					// we might have some bucket related origin/size
					float bucket_position_x, bucket_position_y, bucket_width, bucket_height;
					bucket_position_x = [[TBXML valueOfAttributeNamed:@"position_x" forElement:element] floatValue];
					bucket_position_y = [[TBXML valueOfAttributeNamed:@"position_y" forElement:element] floatValue];
					bucket_width = [[TBXML valueOfAttributeNamed:@"position_wd" forElement:element] floatValue];
					bucket_height = [[TBXML valueOfAttributeNamed:@"position_ht" forElement:element] floatValue];
					
					// modification JD: bucket_width and height seem empty 
					//if (bucket_position_x && bucket_position_y && bucket_width && bucket_height) 
					//photo.frame = CGRectMake(bucket_position_x, bucket_position_y, bucket_width, bucket_height);
					if (bucket_position_x && bucket_position_y) 
						photo.frame = CGRectMake(bucket_position_x, bucket_position_y, 180, 180);
											
					
					// add photo to the array
					[photos addObject:photo];
				}
				else {
					// unexpected tag
				}
				
				// move to next element
				element = element->nextSibling;
			}
		}
	}
	[tbxml release];
	
	// Create result object
	PhotoSet *photoSet = [[PhotoSet alloc] init];
	photoSet.photos = photos;
	
	// Add parameters that were requested
	photoSet.bucketIds = bucketIds;
	photoSet.ratings = ratings;
	
	[delegate didLoadPhotoSet:photoSet];
}



@end

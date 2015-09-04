//
//  PhotoSet.m
//  PhotoOrganiser
//
//  Created by Antony Harfield on 04/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"
#import "TBXML.h"


@implementation PhotoSet
@synthesize title = _title;
@synthesize photos = _photos;

- (id) initWithTitle:(NSString *)title photos:(NSArray *)photos {
    if ((self = [super init])) {
        self.title = title;
        self.photos = photos;
        for(int i = 0; i < _photos.count; ++i) {
            Photo *photo = [_photos objectAtIndex:i];
            photo.photoSource = self;
            photo.index = i;
        }        
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    self.photos = nil;    
    [super dealloc];
}

#pragma mark TTModel

- (BOOL)isLoading { 
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return _photos.count;
}

- (NSInteger)maxPhotoIndex {
    return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < _photos.count) {
        return [_photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}

static PhotoSet *samplePhotoSet = nil;

+ (PhotoSet *) samplePhotoSet {
    @synchronized(self) {
        if (samplePhotoSet == nil) {
            Photo *iter1 = [[[Photo alloc] initWithCaption:@"ITER: Looking toward the north-east" 
                                                          urlLarge:@"http://www.iter.org/img/orig-1600-100/edit/Lists/list_items/Attachments/245/pano6_210410_NWest.jpg" 
                                                          urlSmall:@"http://www.iter.org/img/crop-500-100/edit/Lists/list_items/Attachments/245/pano6_210410_NWest.jpg" 
                                                          urlThumb:@"http://www.iter.org/img/crop-150-100/edit/Lists/list_items/Attachments/245/pano6_210410_NWest.jpg" 
                                                              size:CGSizeMake(1600, 721)] autorelease];
            Photo *iter2 = [[[Photo alloc] initWithCaption:@"First ITER components transported" 
                                                      urlLarge:@"http://www.iter.org/img/orig-1600-100/edit/Lists/list_items/Attachments/228/maiden_2.jpg" 
                                                      urlSmall:@"http://www.iter.org/img/crop-500-100/edit/Lists/list_items/Attachments/228/maiden_2.jpg" 
                                                      urlThumb:@"http://www.iter.org/img/crop-150-100/edit/Lists/list_items/Attachments/228/maiden_2.jpg" 
                                                          size:CGSizeMake(1600, 1200)] autorelease];
            Photo *iter3 = [[[Photo alloc] initWithCaption:@"Prototype for ITER" 
                                                    urlLarge:@"http://www.iter.org/img/orig-1600-100/edit/Lists/list_items/Attachments/231/Cryo.jpg" 
                                                    urlSmall:@"http://www.iter.org/img/crop-500-100/edit/Lists/list_items/Attachments/231/Cryo.jpg" 
                                                    urlThumb:@"http://www.iter.org/img/crop-150-100/edit/Lists/list_items/Attachments/231/Cryo.jpg" 
                                                        size:CGSizeMake(1600, 1066)] autorelease];
            Photo *iter4 = [[[Photo alloc] initWithCaption:@"Approved! Council gives project green light to proceed" 
                                                      urlLarge:@"http://www.iter.org/img/orig-1600-100/edit/Lists/Stories/Attachments/363/om_%20contract.jpg" 
                                                      urlSmall:@"http://www.iter.org/img/orig-500-100/edit/Lists/Stories/Attachments/363/om_%20contract.jpg" 
                                                      urlThumb:@"http://www.iter.org/img/orig-150-100/edit/Lists/Stories/Attachments/363/om_%20contract.jpg" 
                                                          size:CGSizeMake(1600, 1204)] autorelease];
            NSArray *photos = [NSArray arrayWithObjects:iter1, iter2, iter3, iter4, nil];
            samplePhotoSet = [[self alloc] initWithTitle:@"From the ITER website" photos:photos];
        }
    }
    return samplePhotoSet;
}

static PhotoSet *aaoDemoPhotoSet = nil;

+ (PhotoSet *) aaoDemoPhotoSet {
    @synchronized(self) {
        if (aaoDemoPhotoSet == nil) {
			
			// Initial array to store images
			NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1024];
			
			// Load XML from web service
			TBXML *tbxml = [[TBXML tbxmlWithURL:[NSURL URLWithString:@"http://editor.againstallodds.com/ios/ws/"]] retain];
			
			// If TBXML found a root node, process element and iterate over children
			if (tbxml.rootXMLElement) {
				
				if ([[TBXML elementName:tbxml.rootXMLElement] isEqualToString:@"editor"]) {
					
					TBXMLElement *element = tbxml.rootXMLElement->firstChild;
					
					while (element) {
						
						NSString *elementname = [TBXML elementName:element];
						
						if ([elementname isEqualToString:@"image"]) {
							
							NSString *imageId, *created;
							int width, height;
							
							imageId = [TBXML valueOfAttributeNamed:@"image_id" forElement:element];
							width = [[TBXML valueOfAttributeNamed:@"width" forElement:element] intValue];
							height = [[TBXML valueOfAttributeNamed:@"height" forElement:element] intValue];
							created = [TBXML valueOfAttributeNamed:@"created" forElement:element];
							
							NSString *baseUrl = @"http://editor.againstallodds.com/ios/img/";
							
							// add to list of images
							Photo *photo = [[[Photo alloc] initWithCaption:imageId
																  urlLarge:[[baseUrl stringByAppendingString:@"work/"] stringByAppendingString:imageId]
																  urlSmall:[[baseUrl stringByAppendingString:@"thmb/"] stringByAppendingString:imageId]
																  urlThumb:[[baseUrl stringByAppendingString:@"thmb/"] stringByAppendingString:imageId] 
																	  size:CGSizeMake(width, height)] autorelease];
							[photos addObject:photo];
						}
						else {
							// strange tag
						}
						
						// move to next element
						element = element->nextSibling;
					}
				}
				
				
			}
			[tbxml release];
			
			aaoDemoPhotoSet = [[self alloc] initWithTitle:@"Demo aaoeditor web service data" photos:photos];
        }
    }
    return aaoDemoPhotoSet;
}



@end
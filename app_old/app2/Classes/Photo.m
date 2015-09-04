//
//  Photo.m
//  app2
//
//  Created by Antony Harfield on 12/06/2010.
//  Copyright 2010 Antony Harfield. All rights reserved.
//

#import "Photo.h"


@implementation Photo

@synthesize ident;
@synthesize rating;
@synthesize photopath;
@synthesize thumbpath;
@synthesize tags;
@synthesize notes;
@synthesize caption;

NSString *photopathprefix = @"data/fullsize/";
NSString *thumbpathprefix = @"data/thumbnails/";


- (id) initWithData:(NSString *)ident :(NSInteger)rating :(NSString *)notes :(NSString *)caption {
	self.ident = ident;
	self.rating = rating;
	self.photopath = [photopathprefix stringByAppendingString:self.ident];
	self.thumbpath = [thumbpathprefix stringByAppendingString:self.ident];
	self.notes = notes;
	self.caption = caption;
	return self;
}

@end

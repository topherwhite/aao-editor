//
//  PhotoDao.m
//  app2
//
//  Created by Antony Harfield on 12/06/2010.
//  Copyright 2010 Antony Harfield. All rights reserved.
//

#import "PhotoDao.h"
#import "Photo.h"

@implementation PhotoDao

- (id) init {
	[super init];
	return self;
}

- (NSArray *) get {

	// initialise the array
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:10];
	
	// create some fake photos
	Photo *p1 = [[Photo alloc] initWithData:@"ah082" :5 :@"This would be suitable for Russian photobooks." :@"Yeah, I like to drive"];
	Photo *p2 = [[Photo alloc] initWithData:@"ah084" :4 :@"" :@""];
	Photo *p3 = [[Photo alloc] initWithData:@"ah086" :3 :@"" :@""];
	Photo *p4 = [[Photo alloc] initWithData:@"ah088" :3 :@"" :@""];
	Photo *p5 = [[Photo alloc] initWithData:@"ah089" :3 :@"" :@""];
	Photo *p6 = [[Photo alloc] initWithData:@"ah092" :3 :@"" :@""];
	Photo *p7 = [[Photo alloc] initWithData:@"ah094" :2 :@"" :@""];
	Photo *p8 = [[Photo alloc] initWithData:@"ah101" :2 :@"" :@""];
	Photo *p9 = [[Photo alloc] initWithData:@"ah107" :5 :@"" :@""];
	Photo *p10 = [[Photo alloc] initWithData:@"ah112" :5 :@"" :@""];
	Photo *p11 = [[Photo alloc] initWithData:@"ah116" :5 :@"" :@""];

	// add them to the array
	[result addObject:p1];
	[result addObject:p2];
	[result addObject:p3];
	[result addObject:p4];
	[result addObject:p5];
	[result addObject:p6];
	[result addObject:p7];
	[result addObject:p8];
	[result addObject:p9];
	[result addObject:p10];
	[result addObject:p11];
	
	/*[p1 release];
	[p2 release];
	[p3 release];
	[p4 release];
	[p4 release];
	[p5 release];
	[p6 release];
	[p7 release];
	[p8 release];
	[p9 release];
	[p10 release];
	[p11 release];*/
	
	return result;
}

@end

//
//  TestDaoTest.m
//  AAOEditor
//
//  Created by Antony Harfield on 31/08/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "TestDaoTest.h"
#import "OrganiserDAO.h"

@implementation TestDaoTest

- (void) testGetTestDao {
    
    STAssertTrue([[OrganiserDAO sharedDAO] isKindOfClass:[OrganiserDAO class]], @"Cannot create dao singleton" );
    
}

- (void) testGetPhotosByBucket {
	
	OrganiserDAO *dao = [OrganiserDAO sharedDAO];
	
	[dao getPhotosByBucket:@"abcde" delegate:self];
	
	STAssertTrue(1==1, @"Problem 1!");

}

- (void) didLoadPhotoSet:(PhotoSet *)photoSet {

	// Do something with the photoset
	
	STAssertTrue(1==2, @"Problem 2!");
	
}

@end

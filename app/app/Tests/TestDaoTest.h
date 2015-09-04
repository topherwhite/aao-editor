//
//  TestDaoTest.h
//  AAOEditor
//
//  Created by Antony Harfield on 31/08/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "OrganiserDAO.h"


@interface TestDaoTest : SenTestCase <LoadedPhotoSetDelegate> {

}

- (void) testGetTestDao;
- (void) testGetPhotosByBucket;

@end

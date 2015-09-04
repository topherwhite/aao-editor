//
//  ProjectDAO.h
//  AAOEditor
//
//  Created by Antony Harfield on 05/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListRequest.h"

@interface ProjectDAO : NSObject {

	NSString *currentProject;
	NSString *currentUser;
	
}

+ (ProjectDAO *)sharedDAO;

- (void)getProjects:(id<LoadedListDelegate>)delegate;

@property(nonatomic,assign) NSString *currentProject;
@property(nonatomic,assign) NSString *currentUser;

@end

//
//  SearchRequest.h
//  AAOEditor
//
//  Created by Antony Harfield on 03/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRequest.h"
#import "PhotoSet.h"

//TODO move this to OrganiserDAO
@protocol LoadedPhotoSetDelegate
- (void)didLoadPhotoSet:(PhotoSet *)photoSet;
@end

@interface SearchRequest : GenericRequest {

	id<LoadedPhotoSetDelegate> delegate;
	
}

- (id)initWithDelegate:(id<LoadedPhotoSetDelegate>)delegate;


@property(nonatomic, assign) id<LoadedPhotoSetDelegate> delegate;

@end

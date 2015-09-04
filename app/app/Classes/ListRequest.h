//
//  ListRequest.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRequest.h"

@protocol LoadedListDelegate
- (void)didLoadList:(NSArray *)list;
@end

@interface ListRequest : GenericRequest {

	id<LoadedListDelegate> delegate;
	
}

- (id)initWithDelegate:(id<LoadedListDelegate>)delegate;

@property(nonatomic,assign) id<LoadedListDelegate> delegate;

@end

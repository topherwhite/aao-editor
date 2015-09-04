//
//  UpdateRequest.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRequest.h"
#import "UpdateResult.h"

@protocol LoadedUpdateResultDelegate
- (void)didLoadUpdateResult:(UpdateResult *)result;
@end


@interface UpdateRequest : GenericRequest {

	id<LoadedUpdateResultDelegate> delegate;
	
}

- (id)initWithDelegate:(id<LoadedUpdateResultDelegate>)delegate;

@property(nonatomic,assign) id<LoadedUpdateResultDelegate> delegate;

@end

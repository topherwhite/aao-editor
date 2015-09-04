//
//  UpdateResult.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UpdateResult : NSObject {

	bool success;
	NSString *message;
	NSString *bucketId;
	
}

@property(nonatomic, assign) bool success;
@property(nonatomic, assign) NSString *message;
@property(nonatomic, assign) NSString *bucketId;


@end

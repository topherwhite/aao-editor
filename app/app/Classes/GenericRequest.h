//
//  GenericRequest.h
//  AAOEditor
//
//  Created by Antony Harfield on 03/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GenericRequest : NSObject {
	
	NSString *command;
	NSMutableData *postData;
	NSMutableData *receivedData;

}

extern NSString * const BASE_URL;

@property(assign) NSString *command;
@property(assign) NSMutableData *postData;
@property(assign) NSMutableData *receivedData;

- (id)initWithCommand:(NSString *)command;
- (void)sendRequest;

@end

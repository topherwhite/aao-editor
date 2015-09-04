//
//  KeyValuePair.h
//  AAOEditor
//
//  Created by Antony Harfield on 24/08/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyValuePair : NSObject {

    NSString *key;
    NSObject *value;
	
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSObject *value;

- (id)initWithKey:(NSString *)key value:(NSObject *)value;

@end

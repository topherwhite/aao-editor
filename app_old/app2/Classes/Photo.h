//
//  Photo.h
//  app2
//
//  Created by Antony Harfield on 12/06/2010.
//  Copyright 2010 Antony Harfield. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Photo : NSObject {
	NSString *ident;
	NSInteger rating;
	NSString *photopath;
	NSString *thumbpath;
	NSArray *tags;
	NSString *notes;
	NSString *caption;
}

- (id) initWithData :(NSString *)ident :(NSInteger)rating :(NSString *)notes :(NSString *)caption;

@property (nonatomic, retain) NSString *ident;
@property (nonatomic) NSInteger rating;
@property (nonatomic, retain) NSString *photopath;
@property (nonatomic, retain) NSString *thumbpath;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *caption;

@end

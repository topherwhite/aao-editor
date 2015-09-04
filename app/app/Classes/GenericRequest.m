//
//  GenericRequest.m
//  AAOEditor
//
//  Created by Antony Harfield on 03/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import "GenericRequest.h"


@implementation GenericRequest


NSString * const BASE_URL = @"http://editor.againstallodds.com/ws/";

@synthesize command;
@synthesize postData;
@synthesize receivedData;

- (id)init {	
	if((self = [super init])) {
		postData = [NSMutableData dataWithCapacity:1024];
    }
    return self;
}

- (id)initWithCommand:(NSString *)cmd {
	if((self = [self init])) {
		self.command = cmd;
    }
    return self;
}

-(void)sendRequest {

	// Create the request.
	NSString *url = [BASE_URL stringByAppendingString:command];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	[req setHTTPMethod:@"POST"];		
	[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	NSString * dataLength = [NSString stringWithFormat:@"%d", [postData length]];
	[req addValue:dataLength forHTTPHeaderField:@"Content-Length"];
	
	[req setHTTPBody:(NSData*)postData];
	
	NSLog(@"URL: %@", url);
	NSLog(@"Post Data: %.*s", [postData length], [postData bytes]);

	// create the connection with the request to start loading the data
	NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:req delegate:self];
	if (connection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // override this method to do something with the data
	NSLog(@"Received Data: %.*s", [receivedData length], [receivedData bytes]);
	
    // release the connection, and the data object
    [connection release];
    //[receivedData release]; //?
}

- (void)dealloc {
	[command release];
	[postData release];
	[receivedData release];
	[super dealloc];
}

@end

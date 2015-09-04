@implementation NSMutableData (Append)

- (void)appendString:(NSString*)string {
    [self appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendFormat:(NSString *)format, ... {
    va_list args;
	va_start(args, format);
	NSString *string = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
    [self appendString:string];
}

@end

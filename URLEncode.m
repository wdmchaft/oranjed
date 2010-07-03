// 
//  URLEncode.m 
// 
//  Created by Nicky Gerritsen on 24-03-09. 
//  Copyright 2009 __MyCompanyName__. All rights reserved. 
// 

#import "URLEncode.h" 


@implementation NSString (URLEncode) 

// URL encode a string 
+ (NSString *)URLEncodeString:(NSString *)string { 
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8); 
	
    return [result autorelease]; 
} 

// Helper function 
- (NSString *)URLEncodeString { 
    return [NSString URLEncodeString:self]; 
} 

@end 
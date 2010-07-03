
// 
//  URLEncode.h 
// 
//  Created by Nicky Gerritsen on 24-03-09. 
//  Copyright 2009 __MyCompanyName__. All rights reserved. 
// 

#import <Foundation/Foundation.h> 


@interface NSString (URLEncode) 
+ (NSString *)URLEncodeString:(NSString *)string; 
- (NSString *)URLEncodeString; 
@end  
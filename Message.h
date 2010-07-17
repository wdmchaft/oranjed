//
//  Message.h
//  oranjed
//
//  Created by Jason Watson on 16/07/2010.
//  
//

#import <Foundation/Foundation.h>
#import "UserData.h"

@interface Message : NSObject {
	NSMutableDictionary *properties;
}

- (NSMutableDictionary *) properties;
- (void) setProperties: (NSDictionary *) newProperties;
- (void) initUserData:(UserData *)user;
- (void) setMessageData:(UserData *)messageData;
@end

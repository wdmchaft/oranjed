//
//  Message.m
//  oranjed
//
//  Created by Jason Watson on 16/07/2010.
//  
//

#import "Message.h"
#import "UserData.h"

@implementation Message

- (id) init {
	if (self = [super init]) {
	
		NSArray *keys   = [NSArray arrayWithObjects:@"address", @"subject", @"date", @"link", @"body", nil];
		NSArray *values = [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
		properties = [[NSMutableDictionary alloc] initWithObjects: values forKeys: keys];
		
		
	}
	return self;
}

- (void) initUserData:(UserData *)user
{
	[self setMessageData: user];	

}

- (void) dealloc {
	[properties release];
	[super dealloc];
}

- (NSMutableDictionary *) properties {
	return properties;
}

- (void) setProperties:(NSDictionary *)newProperties {
	if (properties != newProperties) {
		[properties autorelease];
		properties = [[NSMutableDictionary alloc] initWithDictionary: newProperties];
	}
}

- (void) setMessageData:(UserData *)user
{
	
	
	NSArray *keys   = [NSArray arrayWithObjects:@"address", @"subject", @"date", @"link", @"body", nil];
	NSString *baseurl = @"http://reddit.com";
	NSString *context = [user.link stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *url = [baseurl stringByAppendingString:context];
	NSArray *values = [NSArray arrayWithObjects:user.author, user.messageSubject, user.messageDate, url, user.messageBody, nil];
	properties = [[NSMutableDictionary alloc] initWithObjects: values forKeys: keys];
}
@end

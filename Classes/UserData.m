//
//  UserData.m
//  oranjed
//
//  Created by Jason Watson on 07/07/2010.
//  
//

#import "UserData.h"


@implementation UserData

@synthesize username, password, myArray, author, messageTitle, messageBody, messageSubject, messageDate, subreddit, kind, link, messageData, logged_in;

- (id) init {
    if ( self = [super init] ) {
		username     = [[NSString alloc]init];
		password     = [[NSString alloc]init];
		messageTitle = [[NSString alloc]init];
		messageBody  = [[NSString alloc]init];
		subreddit    = [[NSString alloc]init];
		kind         = [[NSString alloc]init];
		link         = [[NSString alloc]init];
		messageData  = [[NSString alloc]init];
		author		 = [[NSString alloc]init];
		messageSubject = [[NSString alloc]init];
		messageDate	   = [[NSString alloc]init];
		logged_in      = NO;
		myArray = [[NSMutableArray alloc] init];
	
		

    }
    return self;
}

- (void) dealloc {
	[username     release];
	[password     release];
	[messageTitle release];
	[messageBody  release];
	[subreddit    release];
	[kind         release];
	[link         release];
	[messageData  release];
	[author		  release];
	[messageSubject	release];
	[messageDate	release];
	[myArray release];
	[super        dealloc];
}

@end

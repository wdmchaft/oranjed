//
//  UserData.m
//  oranjed
//
//  Created by Jason Watson on 07/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import "UserData.h"


@implementation UserData

@synthesize username, password, messageTitle, messageBody, subreddit, kind, link, logged_in;

-(id) init {
    if ( self = [super init] ) {
		username     = [[NSString alloc]init];
		password     = [[NSString alloc]init];
		messageTitle = [[NSString alloc]init];
		messageBody  = [[NSString alloc]init];
		subreddit    = [[NSString alloc]init];
		kind         = [[NSString alloc]init];
		link         = [[NSString alloc]init];
		logged_in    = NO;


    }
    return self;
}

- (void) dealloc
{
	[username     release];
	[password     release];
	[messageTitle release];
	[messageBody  release];
	[subreddit    release];
	[kind         release];
	[link         release];
	[super        dealloc];
}
@end

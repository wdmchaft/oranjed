//
//  AppController.m
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import "AppController.h"


@implementation AppController

NSString *username, *password, *userData;

- (id) init
{
	if (self = [super init]) { NSLog(@"init: text %@ / results %@", usernameTextField, passwordTextField); }
	
	return (self);
}

- (void) awakeFromNib
{
	statusItem       = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	statusImage      = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon"     ofType:@"png"]];
	statusNewImage   = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon-alt" ofType:@"png"]];
	
	[statusItem setImage:statusImage];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];
	
	[usernameTextField setStringValue:@"username"];
	[passwordTextField setStringValue:@"password"];
}

- (int) connect
{
	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:
									[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *requestBody         =	[NSString stringWithFormat:@"user=%@&passwd=%@",
									[[self getUsername] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
									[[self getPassword] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) { NSLog(@"Connection response: %@", connection); } else { return (1); }
	
	return (0);
}

- (IBAction) login: (id) sender
{
	NSLog(@"Logging into Reddit...");
	[self setUsername: [usernameTextField stringValue]];
	[self setPassword: [usernameTextField stringValue]];
	
	if ([self connect] == 0) 
	{
		[self getUnread];
	}
}

- (IBAction) check: (id) sender 
{ 
	NSLog(@"Checking..."); 
	if ([self getUnread] == 0)
	{
		[self parseUserData];
	}
}

- (int) getUnread
{
	NSLog(@"Getting unread messages...");
	
	NSString            *unread     = @"http://www.reddit.com/message/unread.json";
	
	NSMutableURLRequest *request    = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:unread]];
	
	NSURLConnection     *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(connection) { NSLog(@"Response: %@", connection); } else { return 1; }
	return 0;
}

- (void) connection: (NSURLConnection *)connection didReceiveData:(NSData *) data
{
	NSString *_data = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	/* Set the users data. */
	[self setUserData:_data];
}

- (void) parseUserData
{
	NSCharacterSet *removeSet = [NSCharacterSet characterSetWithCharactersInString:@"\[]/:.{}\","];
	
	NSString       *replace   = [[[self getUserData] componentsSeparatedByCharactersInSet:removeSet] componentsJoinedByString:@""];
	
	NSArray        *seperate  = [replace componentsSeparatedByString:@" "];
	
	
	for(int i = 0; i < [seperate count]; i++ )
	{
		/* Parse subject. */
		if ( [[seperate objectAtIndex: i] isEqualToString:@"subject"] ) 
		{
			NSLog(@"%@", [seperate objectAtIndex: i+1]);
		}
		
	}
}

- (NSString *) getPassword { return (password); }

- (NSString *) getUsername { return (username); }

- (NSString *) getUserData { return (userData); }

- (void) setPassword: (NSString *) newPassword { password = newPassword; }

- (void) setUsername: (NSString *) newUsername { username = newUsername; }

- (void) setUserData: (NSString *) newUserData { userData = newUserData; }

@end

//
//  AppController.m
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import "AppController.h"
#import "UserData.h"
#import "JSON.h"


@implementation AppController

UserData *User;
- (void) awakeFromNib
{
	statusItem       = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	NSBundle *bundle = [NSBundle mainBundle];
	
	statusImage      = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon"     ofType:@"png"]];
	statusNewImage   = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon-alt" ofType:@"png"]];

	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusNewImage];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];

	
	[usernameTextField setStringValue:@"username"];
	[passwordTextField setStringValue:@"password"];


}
-(IBAction) loginWindow: (id) sender
{
	NSLog(@"loginWindow");
	[loginWindow orderFront:sender];
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
	NSLog(@"Here");
	if ([[menuItem title] isEqualToString:@"Login"]) {
		NSLog(@"Login");
		return YES;
	}
	if ([[menuItem title] isEqualToString:@"Check"]) {
		if (User.logged_in) {
			return YES;
		} else {
			return NO;
		}
	}
	return YES;
}
- (IBAction) login: (id) sender
{
	NSLog(@"Logging into reddit...");
	
	User = [UserData new];
	
	User.password  = [passwordTextField stringValue];
	User.username  = [usernameTextField stringValue];
	User.logged_in = [self connectWithUsername:User.username password:User.password ];
}

- (BOOL)connectWithUsername:(NSString *)username password:(NSString *)password  {
	
	NSLog(@"Connecting");
	
	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *requestBody         =	[NSString stringWithFormat:@"user=%@&passwd=%@",[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) 
	{
		return YES;
	} else { 
		return NO; 
	}
	
	
}



- (IBAction) check: (id) sender
{
	NSLog(@"checking reddit...");

	if (User.logged_in) {
		NSLog(@"You're logged in, so you can check!");
		[self parse];
	}else {
		NSLog(@"You need to log in to check!");
		//Disable check
	}


	
}

- (void) connection: (NSURLConnection *)connection didReceiveData:(NSData *) data
{	
	[self parse];
}

- (void) parse
{
	SBJSON       *parser       = [[SBJSON alloc] init];
	NSURLRequest *request      = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.reddit.com/message/unread.json"]];
	NSData       *response     = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString     *json_string  = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSDictionary *userData     = [parser objectWithString:json_string error:nil];
	
	NSArray      *messageData  = [[userData objectForKey:@"data"] objectForKey:@"children"];
	
	for (NSDictionary *message in messageData)
	{
		if ([[message objectForKey:@"kind"] isEqualToString:@"t1"]) 
		{
			if ([[message objectForKey:@"data"] objectForKey:@"new"])
			{
				NSLog(@"*************** Comment in a reddit ***************");
				NSLog(@"      From: %@", [[message objectForKey:@"data"] objectForKey:@"author"]);
				NSLog(@"   Message: %@", [[message objectForKey:@"data"] objectForKey:@"body"]);
				NSLog(@" Subreddit: %@", [[message objectForKey:@"data"] objectForKey:@"subreddit"]);
				NSLog(@"***************************************************\n");
			} else { NSLog(@"You have no new comments."); }
		} 
		if ([[message objectForKey:@"kind"] isEqualToString:@"t4"]) 
		{
			 if ([[message objectForKey:@"data"] objectForKey:@"new"]) 
			 {
				NSLog(@"************* Message in your inbox! **************");
				NSLog(@"*    From:%@", [[message objectForKey:@"data"] objectForKey:@"author"]);
				NSLog(@"* Subject:%@", [[message objectForKey:@"data"] objectForKey:@"subject"]);
				NSLog(@"* Message:%@", [[message objectForKey:@"data"] objectForKey:@"body"]);
				NSLog(@"***************************************************\n");
			 } 
			 else { NSLog(@"You have no new messages."); }
		}
	}
}	


@end

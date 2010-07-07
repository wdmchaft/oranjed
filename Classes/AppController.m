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

- (IBAction) login: (id) sender
{
	NSLog(@"Logging into reddit...");
	
	UserData *User = [UserData new];
	
	User.password = [passwordTextField stringValue];
	User.username = [usernameTextField stringValue];
	
	[self connectWithUsername:User.username password:User.password];
}

- (int)connectWithUsername:(NSString *)username password:(NSString *)password  {
	
	NSLog(@"Connecting");
	
	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *requestBody         =	[NSString stringWithFormat:@"user=%@&passwd=%@",[@"jasonwatson" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [@"221088" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (!connection) { return -1; }
	
	return 0;
}

- (IBAction) check: (id) sender
{
	NSLog(@"checking reddit...");
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
	NSDictionary *statuses     = [parser objectWithString:json_string error:nil];
	
	NSArray *messageData       = [[statuses objectForKey:@"data"] objectForKey:@"children"];
	
	for (NSDictionary *message in messageData)
	{
		if ([[message objectForKey:@"kind"] isEqualToString:@"t1"]) {
			NSLog(@"Comment in a reddit");
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"author"]);
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"body"]);
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"subreddit"]);
		}
		else if ([[message objectForKey:@"kind"] isEqualToString:@"t4"]) {
			NSLog(@"Comment in your inbox!");
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"author"]);
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"subject"]);
			NSLog(@"%@", [[message objectForKey:@"data"] objectForKey:@"body"]);
		}
		
	}
	
}	


@end

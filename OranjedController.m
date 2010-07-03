//
//  OranjedController.m
//  hello-toolbar
//
//  Created by Jason Watson on 02/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import "OranjedController.h"


@implementation OranjedController
NSMutableData *receivedData;
NSString *thedata;


-(void) awakeFromNib
{
	oranjedItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	oranjedImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]];
	oranjedHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon-alt" ofType:@"png"]];
	
	[oranjedItem setImage:oranjedImage];
	[oranjedItem setAlternateImage:oranjedHighlightImage];
	
	[oranjedItem setMenu:oranjedMenu];
	[oranjedItem setHighlightMode:YES];
	
	if ([self login] == 0)
	{
		[self get_unread];
	}

}

-(void) dealloc 
{
	[oranjedImage release];
	[oranjedHighlightImage release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { 
	NSLog(@"Response recieved!"); 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 
	NSLog(@"Connection closed. Done!"); 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { 
	NSLog(@"Error recieved: %@", [error description]); 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{ 
	NSString *sdata = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"The data is: %@",sdata); 
	thedata = sdata;

}
	
-(int)login
{
	NSLog(@"Checking...");
	
	NSString *Username = @"o3o";
	NSString *Password = @"221088jbw";
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *request_body = [NSString 
							  stringWithFormat:@"user=%@&passwd=%@",
							  [Username        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
							  [Password        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
							  ];
							  

	[request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(theConnection){
		NSLog(@"Response: %@", theConnection);
	}
	else{
		
	}
	return 0;
}
-(void) get_unread
{
	NSLog(@"Logged in. ");
	NSString *Unread = @"http://www.reddit.com/message/unread.json";
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:Unread]];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(theConnection){
		NSLog(@"Response: %@", theConnection);
	}else{}
}	


-(IBAction)check:(id)sender
{
	
	
	NSLog(@"h\n%@", thedata);


}
@end

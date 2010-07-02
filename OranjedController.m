//
//  OranjedController.m
//  hello-toolbar
//
//  Created by Jason Watson on 02/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import "OranjedController.h"


@implementation OranjedController

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

}

-(void) dealloc 
{
	[oranjedImage release];
	[oranjedHighlightImage release];
	[super dealloc];
}

-(IBAction)check:(id)sender
{
	NSLog(@"Checking...");
}
@end

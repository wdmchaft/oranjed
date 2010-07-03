//
//  OranjedController.h
//  hello-toolbar
//
//  Created by Jason Watson on 02/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface OranjedController : NSObject {
	IBOutlet NSMenu *oranjedMenu;
	
	NSStatusItem *oranjedItem;
	NSImage      *oranjedImage;
	NSImage		 *oranjedHighlightImage;

}

-(IBAction)check:(id)sender;
-(int)login;
-(void)get_unread;
@end

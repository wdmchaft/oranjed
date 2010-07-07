//
//  AppController.h
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	NSImage              *statusImage;
	NSImage			     *statusNewImage;
	NSStatusItem         *statusItem;
	IBOutlet NSMenu      *statusMenu;
	IBOutlet NSTextField *usernameTextField;
	IBOutlet NSTextField *passwordTextField;
}

- (IBAction) login: (id) sender;
- (IBAction) check: (id) sender;
- (int) connectWithUsername:(NSString *)username password:(NSString *)password;
- (void)parse;
@end

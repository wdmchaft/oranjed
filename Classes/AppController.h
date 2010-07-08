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
	IBOutlet NSMenuItem  *menuItemCheck;
	IBOutlet NSMenuItem  *menuItemLogin;
	
	IBOutlet NSPanel     *loginPanel;
	IBOutlet NSTextField *panelUsernameField;
	IBOutlet NSTextField *panelPasswordField;
	
}

- (IBAction) login: (id) sender;
- (IBAction) check: (id) sender;
- (IBAction) loginWindow: (id) sender;
- (BOOL) connectWithUsername:(NSString *)username password:(NSString *)password;
- (void)parse;
- (void) check_logged_in;
@end

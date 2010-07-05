//
//  AppController.h
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSMenu *statusMenu;
	NSStatusItem    *statusItem;
	
	NSImage         *statusImage;
	NSImage			*statusNewImage;
	
	IBOutlet NSTextField *usernameTextField;
	IBOutlet NSTextField *passwordTextField;

}

-(IBAction) login: (id) sender;
-(IBAction) check: (id) sender;

-(NSString *) getUsername;
-(NSString *) getPassword;
-(NSString *) getUserData;

- (void) setUsername: (NSString *) newUsername;
- (void) setPassword: (NSString *) newPassword;
- (void) setUserData: (NSString *) newUserData;

- (int) getUnread;
- (void) parseUserData;
@end

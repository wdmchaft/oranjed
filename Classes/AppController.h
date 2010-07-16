//
//  AppController.h
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	NSImage              *statusImage;
	NSImage			     *statusNewImage;
	NSStatusItem         *statusItem;
	IBOutlet NSMenu      *statusMenu;
	IBOutlet NSMenuItem  *menuItemCheck;
	IBOutlet NSMenuItem  *menuItemLogin;
	IBOutlet NSMenuItem  *menuItemMessages;
	
	IBOutlet NSPanel     *loginPanel;
	IBOutlet NSTextField *panelUsernameField;
	IBOutlet NSTextField *panelPasswordField;	
	
	IBOutlet NSPanel     *messagesPanel;
}

- (IBAction) login: (id) sender;
- (IBAction) check: (id) sender;
- (IBAction) loginPanel: (id) sender;
- (IBAction) messagesPanel: (id) sender;

- (BOOL) connectWithUsername:(NSString *)username password:(NSString *)password;
- (void)parse;
- (void) check_logged_in;

@end

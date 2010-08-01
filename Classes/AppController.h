//
//  AppController.h
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>
#import "UserData.h"
static NSProgressIndicator *progressIndicator;

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
	
	IBOutlet NSTextFieldCell *urlField;
	IBOutlet NSPanel      *messagesPanel;
	IBOutlet NSScrollView *messageContent;

	IBOutlet NSTableView *messagesTable;
	IBOutlet NSTextView  *previewPane;
	NSMutableArray *emails;
	IBOutlet BWHyperlinkButton *linkButton;
	NSString *url;
	IBOutlet NSWindow *inboxWindow;
	IBOutlet NSProgressIndicator *progressBar;
}

- (void) addEmail:(UserData *)user;
-(NSString *)UTCConvertDateAndFormat:(NSString *)messageDate;

-(IBAction) openURL: (id) sender;
- (NSString *) getURL;
-(void) setURL:(NSString *)_url;
-(IBAction) inboxWindow: (id) sender;

- (IBAction) login: (id) sender;
- (IBAction) check: (id) sender;
- (IBAction) loginPanel: (id) sender;
- (IBAction) messagesPanel: (id) sender;

- (BOOL) connectWithUsername:(NSString *)username password:(NSString *)password;
- (void) parse;
- (void) check_logged_in;

@end

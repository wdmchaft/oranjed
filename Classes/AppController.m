//
//  AppController.m
//  oranjed
//
//  Created by Jason Watson on 05/07/2010.
//  
//

#import "AppController.h"
#import "UserData.h"
#import "JSON.h"
#import "Message.h"

@implementation AppController

UserData *User;

- (id) init {
    if ( self = [super init] ) {

		menuItemCheck = [[NSMenuItem alloc]init];
		menuItemLogin = [[NSMenuItem alloc]init];
		loginPanel = [[NSPanel alloc]init];
		panelUsernameField = [[NSTextField alloc]init];
		panelPasswordField = [[NSTextField alloc]init];
		emails = [[NSMutableArray alloc]init];

	}
    return self;
}

- (void) dealloc {
	[menuItemCheck      release];
	[menuItemLogin      release];
	[loginPanel         release];
	[panelPasswordField release];
	[panelUsernameField release];
	[super dealloc];
}

- (void) awakeFromNib {
	statusItem       = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	NSBundle *bundle = [NSBundle mainBundle];
	
	statusImage      = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon"     ofType:@"png"]];
	statusNewImage   = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon-alt" ofType:@"png"]];

	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusNewImage];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];

	[panelUsernameField setStringValue:@"username"];
	[panelPasswordField setStringValue:@"password"];
	[menuItemMessages   setTitle:@"0 Messages"];
	[menuItemMessages   setHidden:YES];
	[previewPane setEditable: NO];
	
	User = [UserData new];

}

- (IBAction) loginPanel: (id) sender {
	[loginPanel orderFront:sender];
}

- (IBAction) messagesPanel: (id) sender {
	[messagesPanel orderFront:sender];
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	
	if ([[menuItem title] isEqualToString:@"Login"]) {
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

- (IBAction) login: (id) sender {
	
	NSLog(@"Logging into reddit...");
	
	User.password  = [panelPasswordField stringValue];
	User.username  = [panelUsernameField stringValue];
	User.logged_in = [self connectWithUsername:User.username password:User.password ];
	User.messageBody = @"nil";
	User.messageTitle = @"nil";
	User.author = @"nil";
	User.messageSubject = @"nil";
	User.messageDate = [NSDate	date];
}

- (BOOL) connectWithUsername:(NSString *)username password:(NSString *)password  {
	
	NSLog(@"Connecting");
	
	NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/api/login"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *requestBody         =	[NSString stringWithFormat:@"user=%@&passwd=%@",[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		return YES;
	} else { 
		return NO; 
	}
}

- (IBAction) check: (id) sender {
	NSLog(@"checking reddit...");

	if (User.logged_in) {
		NSLog(@"You're logged in, so you can check!");
		[self parse];
	}	
}

- (void) connection: (NSURLConnection *)connection didReceiveData:(NSData *) data {	
	
	User.messageData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	[self check_logged_in];
}

- (void) check_logged_in {
	SBJSON       *parser       = [[SBJSON alloc] init];
	NSLog(@"here");
	NSDictionary *loginResponseDict = [parser objectWithString:User.messageData error:nil];
	NSArray *loginResponse          = [loginResponseDict objectForKey:@"jquery"];
	
	if ([[[[loginResponse objectAtIndex:10] objectAtIndex:3] objectAtIndex:0] isEqualToString:@"/" ]) {
		NSLog(@"you're logged in.");
		User.logged_in = YES;
		[menuItemMessages setHidden:NO];
		[self parse];
	} else if ([[[[loginResponse objectAtIndex:10] objectAtIndex:3] objectAtIndex:0] isEqualToString:@".error.WRONG_PASSWORD.field-passwd"]) {
		NSLog(@"youre password is incorrect.");
		User.logged_in = NO;
		return;
	}
	else {
		NSLog(@"Something went wrong.");
		return;
	}

}

- (void) parse {
	
	SBJSON       *parser       = [[SBJSON alloc] init];
	NSURLRequest *request      = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.reddit.com/message/unread.json"]];
	NSData       *response     = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString     *json_string  = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSDictionary *userData     = [parser objectWithString:json_string error:nil];

	NSArray      *messageData  = [[userData objectForKey:@"data"] objectForKey:@"children"];
	NSArray      *empty  = [[userData objectForKey:@"data"] objectForKey:@"after"];
	NSLog(@"%@", json_string);
	if (empty) {
		for (NSDictionary *message in messageData) {

			if ([[message objectForKey:@"kind"] isEqualToString:@"t1"]) {

				if ([[message objectForKey:@"data"] objectForKey:@"new"]) {
					NSLog(@"\n*************** Comment in a reddit ***************");
					NSLog(@"      From: %@", [[message objectForKey:@"data"] objectForKey:@"author"]);
					User.author = [[message objectForKey:@"data"] objectForKey:@"author"];
					NSLog(@"   Message: %@", [[message objectForKey:@"data"] objectForKey:@"body"]);
					User.messageBody = [[message objectForKey:@"data"] objectForKey:@"body"];
					NSLog(@" Subreddit: %@", [[message objectForKey:@"data"] objectForKey:@"subreddit"]);
					User.subreddit = [[message objectForKey:@"data"] objectForKey:@"subreddit"];
					NSLog(@"***************************************************\n");
					[self addEmail:User];
				} else { NSLog(@"You have no new comments."); }
			} 
			if ([[message objectForKey:@"kind"] isEqualToString:@"t4"]) {
				 if ([[message objectForKey:@"data"] objectForKey:@"new"]) {
					NSLog(@"\n************* Message in your inbox! **************");
					NSLog(@"*    From:%@", [[message objectForKey:@"data"] objectForKey:@"author"]);
					 User.author = [[message objectForKey:@"data"] objectForKey:@"author"];
					NSLog(@"* Subject:%@", [[message objectForKey:@"data"] objectForKey:@"subject"]);
					 User.messageSubject = [[message objectForKey:@"data"] objectForKey:@"subject"];
					NSLog(@"* Message:%@", [[message objectForKey:@"data"] objectForKey:@"body"]);
					 
					 User.messageBody =  [[message objectForKey:@"data"] objectForKey:@"body"];
					 [self addEmail:User];
					NSLog(@"***************************************************\n");
				 } 
				 else { NSLog(@"You have no new messages."); }
			}
		}
	}
	else { NSLog(@"Empty.");}

}	

- (void) addEmail:(UserData *)user {
	Message *newMessage = [[Message alloc]init];
	[newMessage initUserData: user];
	[emails addObject:newMessage];
	[messagesTable reloadData];
}

- (int) numberOfRowsInTableView:(NSTableView *)tableView {
	return [emails count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(int)row {
	NSString *key = [column identifier];
	Message *theMessage = [emails objectAtIndex:row];
	return [[theMessage properties]objectForKey: key];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	[previewPane setEditable: NO];

    int messageRow = [messagesTable selectedRow];
    if (messageRow < 0)
    {
        [previewPane setString: @""];
        return;
    }
   
    if (messageRow > ([emails count] - 1)) return;
    
    Message *message         = [emails objectAtIndex: messageRow];
    NSString *messageBody   = [[message properties] objectForKey: @"body"];
    [previewPane setString: messageBody];    
}



@end

//
//  UserData.h
//  oranjed
//
//  Created by Jason Watson on 07/07/2010.
//  Copyright 2010 University of Lancaster. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UserData : NSObject {
	NSString *username;
	NSString *password;
	NSString *messageTitle;
	NSString *messageBody;
	NSString *subreddit;
	NSString *kind;
	NSString *link;
	NSString *messageData;
	BOOL logged_in;

}


@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *messageTitle;
@property (nonatomic, retain) NSString *messageBody;
@property (nonatomic, retain) NSString *subreddit;
@property (nonatomic, retain) NSString *kind;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *messageData;

@property (nonatomic) BOOL logged_in;

@end

//
//  DMConversationViewController.h
//  DotMail
//
//  Created by Robert Widmann on 11/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import <WebKit/WebKit.h>

@class PSTConversation, PSTAccountController;

@interface DMConversationViewController : NSViewController {
@package
	NSString *_selectedCurrentMessageID;
	NSString *_selectedCurrentPartID;
}

@property (nonatomic, strong) WebView *webView;
@property (nonatomic, strong) PSTConversation *conversation;
@property (nonatomic, strong) PSTMailAccount *account;
@property (nonatomic, assign) PSTFolderType selectedMailbox;
@property (nonatomic, strong, readonly) NSMutableArray *displayMessageIDs;

- (instancetype)initWithFrame:(NSRect)rect;
- (void)load;
- (void)unload;

- (void)print:(id)sender;

@end

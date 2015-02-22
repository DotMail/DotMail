//
//  DMMainWindowController.h
//  DotMail
//
//  Created by Robert Widmann on 9/2/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import "DMAssistantViewController.h"
#import <Quartz/Quartz.h>

@class DMSplitView, DMSidebarView, DMConversationListController, DMConversationListController, DMDatabaseController, DMAccountListViewController, MASPreferencesWindowController, DMConversationViewController, DMAttachmentsViewController, DMStatusBarManager, DMMainWindow;

@interface DMMainWindowController : NSWindowController <NSPopoverDelegate, QLPreviewPanelDelegate>

@property (nonatomic, assign) BOOL sidebarVisible;
@property (nonatomic, assign) BOOL messagePaneVisible;
@property (nonatomic, assign, readonly, getter = isFullScreen) BOOL fullScreen;

- (void)composeMessage:(id)sender;
- (void)composeWithFilenames:(NSArray*)filenames;
- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject htmlBody:(NSString*)htmlBody;

- (IBAction)print:(id)sender;

/*
- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject archive:(DMIMAPAsyncStorage*)archive;
- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject body:(NSString*)body;
 */

- (void)setup;
- (void)unload;

- (void)toggleSidebar:(id)sender;

- (IBAction)replyMessage:(id)sender;
- (IBAction)replyAllMessage:(id)sender;

- (void)selectMailbox:(PSTFolderType)mailbox;
- (IBAction)selectPreviousAccount:(id)sender;
- (IBAction)selectNextAccount:(id)sender;

@end

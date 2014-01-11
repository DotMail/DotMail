//
//  DMMainWindowController.m
//  Mail
//
//  Created by Robert Widmann on 9/2/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMMainWindowController.h"
#import "DMMainViewController.h"
#import "DMMainViewModel.h"
#import "DMMainWindow.h"
#import "DMConversationListController.h"

#import <MailCore/mailcore.h>


#import <MoonShine/MoonShine.h>

@interface DMMainWindowController ()

@property (nonatomic, strong) DMSidebarView *sidebar;
@property (nonatomic, strong) NSPopover *updateInstalledPopover;
@property (nonatomic, strong) NSPopover *activityPopover;
@property (nonatomic, strong) PSTAccountController *account;

@property (nonatomic, assign) PSTFolderType selectedMailbox;
@property (nonatomic, assign) BOOL attachHidden;

@property (nonatomic, strong) CALayer *currentRendering;
@property (nonatomic, assign) BOOL animating;

@end

@implementation DMMainWindowController

- (instancetype)init {
	self = [super init];
	
	NSUInteger windowMask = (NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask);
	CGRect windowFrame;
	NSDictionary *savedFrame = [NSUserDefaults.standardUserDefaults dictionaryForKey:PSTMainWindowAutosavedFrameKey];
	if (!savedFrame) {
		windowFrame = (NSRect){ .size = { 937, 653 } };
	} else {
		CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)savedFrame, &windowFrame);
	}
	if ([NSUserDefaults.standardUserDefaults boolForKey:PSTMainWindowAutosavedFullscreenStateKey]) {
		[NSApp setPresentationOptions:NSApplicationPresentationFullScreen];
	}
	self.window = [[DMMainWindow alloc]initWithContentRect:windowFrame styleMask:windowMask backing:NSBackingStoreBuffered defer:NO];
	self.window.delegate = self;
	
	NSRect newRect = self.window.frame;
	if (NSWidth(newRect) < 937) {
		newRect.size.width = 937;
	}
	[self.window center];
	
//	self.viewController = [[DMMainViewController alloc]initWithContentRect:[self.window.contentView frame]];
//	RAC(self.viewController.viewModel.account) = RACAble(self.account);
//	[self.window.contentView addSubview:self.viewController.view];
//	
	return self;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem { 
	return [self.window.viewController validateMenuItem:menuItem];
}

- (BOOL)isFullScreen {
	return ((self.window.styleMask & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

- (void)setup {
	[self.window.viewController reinstateToolbar];
//	[self _setCurrentAccount:[PSTAccountControllerManager.defaultManager.accounts objectAtIndex:0]];
//	[self _accountsChanged];
}

- (void)unload {
	[self.window.viewController unload];
}

- (DMMainWindow *)window {
	return (DMMainWindow *)[super window];
}

- (IBAction)replyMessage:(NSMenuItem *)sender {
	if (!sender.representedObject) sender.representedObject = self.window.viewController.conversationListController.selectedConversation;
	[self.window.viewController.viewModel composeReply:sender];
	sender.representedObject = nil;
}

- (IBAction)replyAllMessage:(NSMenuItem *)sender {
	if (!sender.representedObject) sender.representedObject = self.window.viewController.conversationListController.selectedConversation;
	[self.window.viewController.viewModel composeReplyAll:sender];
	sender.representedObject = nil;
}


- (void)_mailSent:(id)notification {
	//Maybe play a sound?
}

- (void)_newMessagesFetched:(NSNotification *)notification {
	//	if (![notification.object isNotificationEnabled]) {
	//		return;
	//	}
}

- (void)_updateLastSyncDate {
	
}

- (void) _setCurrentAccount:(PSTAccountController *)account {
//	self.account = account;
//	facebookPopoverViewController.account = account.mainAccount;
//	self.attachmentsViewController.account = account;
//	[self.conversationListController setAccount:account];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"selectedAccount"]) {
		return;
	}
	if ([keyPath isEqualToString:@"selectedMailbox"]) {
		[self _mailboxSelectionChanged];
	}
}

- (void)_mailboxSelectionChanged {
//	[self _setCurrentAccount:[self.accountListController selectedAccount]];
	[self _updateSelectedMailbox];
}

- (void)_updateSelectedMailbox {
//	[self _reloadData];
//	[self _animate];
	
}

- (void)_reloadData {
//	[self.conversationListController performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
	return (NSRect){ .origin.x = NSMinX(rect), .origin.y = NSMinY(rect) * 2, .size.width = NSWidth(rect), .size.height = NSHeight(rect) };
}


- (void)statusBarClicked {
	[NSApp activateIgnoringOtherApps:YES];
	if (self.window.isMiniaturized) {
		[self.window deminiaturize:self];
	}
	[self.window makeKeyAndOrderFront:self];
}

- (void)composeMessage:(id)sender {
	[self.window.viewController.viewModel composeMessage:sender];
}

- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject htmlBody:(NSString*)htmlBody {
	[self.window.viewController.viewModel composeMessageWithTo:to cc:cc bcc:bcc subject:subject htmlBody:htmlBody];
}

- (void)composeWithFilenames:(NSArray*)filenames {
	[self.window.viewController.viewModel composeWithFilenames:filenames];
}

- (void)selectMailbox:(PSTFolderType)mailbox {
	[self.window.viewController selectMailbox:mailbox];
}

- (IBAction)selectPreviousAccount:(id)sender {
	[self.window.viewController selectPreviousAccount:sender];
}

- (IBAction)selectNextAccount:(id)sender {
	[self.window.viewController selectNextAccount:sender];
}

- (IBAction)print:(id)sender {
	[self.window.viewController print:sender];
}


- (void)toggleSidebar:(id)sender {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	
//	if (self.sidebarVisible) {
//		[defaults setValue:NSStringFromRect( ( (NSView *)[self.splitView.subviews objectAtIndex:0] ).bounds ) forKey:DMSidebarOldSizeConstant];
//		[self.splitView setPosition:0 ofDividerAtIndex:0 animated:YES completitionBlock:NULL];
//		[defaults setBool:NO forKey:DMSidebarEnabled];
//	} else {
//		[self.splitView setPosition:NSWidth( NSRectFromString([defaults stringForKey:DMSidebarOldSizeConstant]) ) ofDividerAtIndex:0 animated:YES completitionBlock:NULL];
//		[defaults setBool:YES forKey:DMSidebarEnabled];
//	}
	self.sidebarVisible = !self.sidebarVisible;
}

#pragma Mark - DMConversationListController Delegate


- (void)conversationListControllerDidChangeSelection:(DMConversationListController *)controller {
//	[self.conversationViewController setSelectedMailbox:self.selectedMailbox];
//	[self.conversationViewController setAccount:self.account.mainAccount];
//	[self.conversationViewController setConversation:self.conversationListController.selectedConversation];
}

#pragma mark - DMComposerDelegate

- (CGWindowLevelKey)windowLevelForCurrentState {
	if (self.isFullScreen) {
		return kCGFloatingWindowLevelKey;
	}
	return kCGNormalWindowLevelKey;
}

#pragma mark - DMAccountListControllerDelegate

- (void)accountListControllerWillChange:(DMAccountListViewController *)listController {
//	[self.conversationListController setSelectedMailbox:listController.selectedMailbox];
//	[self.conversationViewController setConversation:nil];
//	self.selectedMailbox = listController.selectedMailbox;
}


@end
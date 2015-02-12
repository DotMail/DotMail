//
//  CFIComposeWindow.m
//  Mail
//
//  Created by Robert Widmann on 7/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMComposeWindowController.h"
#import "DMComposeViewController.h"
#import "DMFontMenu.h"
#import "DMTokenizingEmailField.h"
#import "DMAppDelegate.h"


#import <AddressBook/AddressBook.h>

@interface DMComposeWindowController ()

@property (nonatomic, assign) BOOL loadingStarted;
@property (nonatomic, assign) BOOL saving;
@property (nonatomic, assign) BOOL pendingSave;
@property (nonatomic, assign) BOOL scheduledSave;
@property (nonatomic, assign) BOOL disableAutomaticSave;
@property (nonatomic, assign) BOOL shouldWarnOnClose;

@property (nonatomic, assign) int progressCount;

@property (nonatomic, strong) PSTLocalMessage *draftMessage;
@property (nonatomic, strong) PSTLocalMessage *messageToSave;

@end

@implementation DMComposeWindowController

- (instancetype)init {
	self = [super init];
	
	NSUInteger windowMask = (NSTitledWindowMask  | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask);
	self.window = [[NSWindow alloc]initWithContentRect:(NSRect){ .origin = { 196, 240 }, .size = { 750, 500 } } styleMask:windowMask backing:NSBackingStoreBuffered defer:NO];
	self.window.minSize = NSMakeSize(750, 500);
	self.window.animationBehavior = NSWindowAnimationBehaviorNone;
	_composeViewController = [[DMComposeViewController alloc]initWithContentRect:[self.window.contentView frame] inWindow:self.window];
	self.window.contentView = _composeViewController.view;
//	[self.window setLevel:CGWindowLevelForKey([self.delegate windowLevelForCurrentState])];
	self.shouldCascadeWindows = YES;
	self.shouldCloseDocument = YES;
	
	return self;
}

- (instancetype)initWithMode:(DMComposerMode)mode {
	self = [self init];
	
	return self;
}

- (instancetype)initWithFilename:(NSString*)filename {
	self = [self init];
	
	MCOMessageParser *msgparser = [[MCOMessageParser alloc]initWithData:[NSData dataWithContentsOfFile:filename]];
//	[msgparser htmlRenderingWithDelegate:nil];
	[self.subjectField setStringValue:msgparser.header.subject ? msgparser.header.subject : @""];
	return self;
}

- (NSString *)windowNibName {
	return @"CFIComposeWindow";
}

/*
 TODO: Make category on MCOIMAPMessage that loads the appropriate mustache.
 */
- (void)_loadWebview {
	NSString *htmlToLoad = nil;
	if (self.mode > 6) {
		return;
	}
	switch (self.mode) {
		case DMComposerModeDraft:
	//			htmlToLoad = [MCOIMAPMessage dmHTMLRenderingWithUUID:self.signatureUUID];
			break;
		case DMComposerModeReply:
	//			htmlToLoad = [MCOIMAPMessage dmHTMLRenderingWithUUID:self.signatureUUID];
			break;
		case DMComposerModeForward:
	//			htmlToLoad = [self.messageToReply dmForwardHTMLRenderingWithAccount:[self _replyAccount] withUUID:self.signatureUUID];
			break;
		case DMComposerModeForURL:
	//			htmlToLoad = [self.messageToReply dmHTMLRenderingWithAccount:[self _replyAccount] withUUID:self.signatureUUID];
			break;
		case DMComposerModeForScript:
	//			htmlToLoad = [MCOIMAPMessage dmHTMLRenderingWithUUID:self.signatureUUID];
			break;
		case DMComposerModeForDebug:
			break;
		default:
			break;
	}
	if (htmlToLoad == nil) {
		return;
	} else {
//		[[self.webView mainFrame]loadHTMLString:htmlToLoad baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
	}
}


/*
 TODO: These can be replicated in JavaScript.
 */

- (IBAction)toggleBoldSelectedText:(NSControl *)sender {
	NSMenuItem *boldMenu = [(DMAppDelegate *)[NSApp delegate] boldButton];
	[boldMenu.menu cancelTracking];
	[boldMenu.menu performActionForItemAtIndex:1];
}

- (IBAction)toggleItalicSelectedText:(id)sender {
	NSMenuItem *boldMenu = [(DMAppDelegate *)[NSApp delegate]boldButton];
	[boldMenu.menu cancelTracking];
	[boldMenu.menu performActionForItemAtIndex:2];
}

- (IBAction)addLink:(id)sender {
	
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
//	NSMutableAttributedString *text = [self.textView textStorage];
//	NSRange letterRange;
//	if (!text.length) return;
//	NSFont *attr = [text attribute:NSFontAttributeName atIndex:(self.textView.selectedRange.location - 1) effectiveRange:&letterRange];
//	if (![attr.displayName isEqualToString:self.fontButton.titleOfSelectedItem]) {
//		[self.fontButton selectItemWithTitle:attr.displayName];
//	}
//	if (roundtol(attr.pointSize) != self.fontSizePopupButton.titleOfSelectedItem.longLongValue) {
//		[self.fontSizePopupButton selectItemWithTitle:[NSString stringWithFormat:@"%lu", roundtol(attr.pointSize)]];
//	}
}

- (NSArray*)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
	return nil;
}

//- (void)controlTextDidChange:(NSNotification *)notification {
//	id obj = notification.object;
//	if (obj != self.toField && obj != self.ccField) {
//		if (obj != self.bccField) {
//			if (obj == self.subjectField) {
//				[self setDocumentEdited:YES];
//				if (self.loadingStarted) {
//					return;
//				} else {
//					[self _scheduleSave];
//				}
//			}
//			return;
//		}
//	}
//}

//- (void)_scheduleSave {
//	if (self.loadingStarted == NO) {
//		if (self.saving) {
//			self.pendingSave = YES;
//			return;
//		}
//		if (self.scheduledSave) return;
//		if (self.disableAutomaticSave) self.pendingSave = YES; return;
//		self.loadingStarted = YES;
//		[self performSelector:@selector(_saveAfterDelay) withObject:nil afterDelay:0];
//	}
//	self.pendingSave = YES;
//	return;
//}
//
//- (void)_saveAfterDelay {
//	self.scheduledSave = NO;
//	[self _saveMessage];
//}

//- (void)_saveMessage {
//	if ([self currentAccount] != nil) {
//		[self _startProgress];
//		[self performSelector:@selector(_stopProgress) withObject:nil afterDelay:0];
//	}
//	if (!self.saving) {
//		[self.document updateChangeCount:NSChangeDone];
//		[self _cancelScheduledSave];
//		self.saving = YES;
//		self.messageToSave = [self _renderMessageForSending:YES];
//		self.messageID = self.messageToSave.header.messageID;
////		[[self currentAccount]saveMessageToLocalDrafts:self.messageToSave completion:^{
////			[self.document updateChangeCount:NSChangeAutosaved];
////		}];
//		return;
//	}
////	self.immediateSave = YES;
//	self.pendingSave = YES;
//	return;
//}
//
//- (void)_startProgress {
//	self.progressCount += 1;
//	if (self.progressCount != 1) {
//		return;
//	} else {
//		[self.saveProgressIndicator setHidden:NO];
//		[self.saveProgressIndicator startAnimation:nil];
//	}
//}
//
//- (void)_stopProgress {
//	self.progressCount -= 1;
//	if (self.progressCount != 0) {
//		return;
//	} else {
//		[self.saveProgressIndicator stopAnimation:nil];
//		[self.saveProgressIndicator setHidden:YES];
//	}
//}

//- (void)_cancelScheduledSave {
//	if (self.scheduledSave) {
//		
//	}
//	self.scheduledSave = NO;
//	[NSObject cancelPreviousPerformRequestsWithTarget:self  selector:@selector(_saveAfterDelay) object:nil];
//}
//
//
@end

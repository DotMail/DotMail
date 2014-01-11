//
//  DMMainViewModel.m
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMMainViewModel.h"
#import "DMComposerDocument.h"

@interface DMMainViewModel ()

@property (nonatomic, strong) NSMutableDictionary *composersMap;

@end

@implementation DMMainViewModel {
	NSPoint cascadePoint;
}

- (instancetype)init {
	self = [super init];
	
	_composersMap = @{}.mutableCopy;
	
	RAC(self,showLoginWindow) = [RACObserve(PSTAccountManager.defaultManager,accounts) map:^id(NSArray *accounts) {
		for (PSTMailAccount *account in accounts) {
			[account checkNotifications];
		}
		return @(accounts.count == 0);
	}];
	
	return self;
}

- (void)composeMessage:(id)sender {
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	DMComposerDocument *newComposer = [[DMComposerDocument alloc] init];
	[self _addComposer:newComposer];
	[newComposer makeWindowControllers];
	cascadePoint = [[newComposer.windowControllers[0] window] cascadeTopLeftFromPoint:cascadePoint];
	newComposer.cascadePoint = cascadePoint;
	[newComposer showWindows];
}

- (void)composeReply:(NSMenuItem *)sender {
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	DMComposerDocument *newComposer = [[DMComposerDocument alloc] initInReplyToConversation:sender.representedObject];
	[self _addComposer:newComposer];
	[newComposer makeWindowControllers];
	[newComposer showWindows];
}

- (void)composeReplyAll:(NSMenuItem *)sender {
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	DMComposerDocument *newComposer = [[DMComposerDocument alloc] initInReplyAllToConversation:sender.representedObject];
	[self _addComposer:newComposer];
	[newComposer makeWindowControllers];
	[newComposer showWindows];
}

- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject htmlBody:(NSString*)htmlBody {
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	DMComposerDocument *newComposer = [[DMComposerDocument alloc] init];
	[self _addComposer:newComposer];
	[newComposer makeWindowControllers];
	[newComposer showWindows];
}

- (void)composeWithFilenames:(NSArray*)filenames {
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	
	for (NSString *filename in filenames) {
		DMComposerDocument *newComposer = [[DMComposerDocument alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filename] ofType:@"eml" error:nil];
		[newComposer makeWindowControllers];
		[newComposer showWindows];
		[self _addComposer:newComposer];
	}
}

- (void)editDraftMessage:(PSTConversation *)conversation {
	if (conversation.messages.count == 0) return;
	if (![NSApp isActive]) {
		[NSApp activateIgnoringOtherApps:YES];
	}
	DMComposerDocument *newComposer = [[DMComposerDocument alloc] initToEditDraftConversation:conversation];
	[self _addComposer:newComposer];
	[newComposer makeWindowControllers];
	[newComposer showWindows];
}

- (IBAction)print:(id)sender {
	//	[self.conversationViewController print];
}

- (void)_addComposer:(DMComposerDocument *)composer {
	if (composer.conversation) {
		DMComposerDocument *document = _composersMap[composer.conversation];
		if (document) {
			[document.windowControllers enumerateObjectsUsingBlock:^(NSWindowController *obj, NSUInteger idx, BOOL *stop) {
				[obj.window makeKeyAndOrderFront:NSApp];
			}];
			return;
		}
		[self.composersMap setObject:composer forKey:composer.conversation];
		@weakify(self);
		composer.onClose = ^(DMComposerDocument *document) {
			@strongify(self);
			[self.composersMap removeObjectForKey:document.conversation];
		};
	}
	[[NSDocumentController sharedDocumentController]addDocument:composer];
}

- (void)assistantViewControllerDidFinish:(DMAssistantViewController *)assistant {
	
}

@end

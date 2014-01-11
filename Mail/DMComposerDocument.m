//
//  DMComposerDocument.m
//  DotMail
//
//  Created by Robert Widmann on 6/3/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMComposerDocument.h"
#import "DMComposeWindowController.h"
#import "DMComposeViewController.h"
#import "DMComposeViewModel.h"

@interface DMComposerDocument ()

@property (nonatomic, assign) DMComposerMode mode;
@property (nonatomic, weak) PSTConversation *replyConversation;
@property (nonatomic, weak) PSTConversation *editableConversation;
@property (nonatomic, strong) NSOpenPanel *attachmentsOpenPanel;
@property (nonatomic, strong) NSData *emlData;

@end

@implementation DMComposerDocument

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];

	return self;
}

- (instancetype)initForURL:(NSURL *)urlOrNil withContentsOfURL:(NSURL *)contentsURL ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
	self = [self init];
	
	
	return self;
}

- (instancetype)initInReplyToConversation:(PSTConversation *)conversation {
	self = [self init];
	
	_mode = DMComposerModeReply;
	_replyConversation = conversation;
	
	return self;
}

- (instancetype)initInReplyAllToConversation:(PSTConversation *)conversation {
	self = [self init];
	
	_mode = DMComposerModeReplyAll;
	_replyConversation = conversation;
	
	return self;
}

- (instancetype)initToEditDraftConversation:(PSTConversation *)conversation {
	self = [self init];
	
	_mode = DMComposerModeDraft;
	_editableConversation = conversation;
	
	return self;
}

- (void)makeWindowControllers {
	DMComposeWindowController *wc = [[DMComposeWindowController alloc]initWithMode:self.mode];
	if (self.editableConversation) {
		[wc.composeViewController.viewModel validateEditableDraftMessage:self.editableConversation];
	} else if (!self.emlData) {
		[wc.composeViewController.viewModel validateReplyConversation:self.replyConversation replyAll:(self.mode == DMComposerModeReplyAll)];
	} else {
		[wc.composeViewController.viewModel validateDraftMessage:[MCOMessageParser messageParserWithData:self.emlData]];
	}
	[self addWindowController:wc];
	[wc showWindow:NSApp];
}

- (PSTConversation *)conversation {
	return self.replyConversation ?: self.editableConversation;
}


- (void)setCascadePoint:(NSPoint)cascadePoint {
	[[self.windowControllers[0] window]setFrameTopLeftPoint:cascadePoint];
}

- (NSString *)defaultDraftName {
	return @"New Message";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	return [self.windowControllers[0] composeViewController].viewModel.emlDataForCurrentMessage;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
	self.emlData = [NSData dataWithContentsOfURL:url];
	[self makeWindowControllers];
	return YES;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	self.emlData = data;
	[self makeWindowControllers];
	return YES;
}

- (IBAction)addLink:(id)sender { [self.windowControllers[0] addLink:sender]; }
- (IBAction)buttonChooseFontColor:(id)sender { return [[self.windowControllers[0] composeViewController].viewModel buttonChooseFontColor]; }
- (IBAction)send:(id)sender {
	[[[self.windowControllers[0] composeViewController].viewModel sendMessage] subscribeCompleted:^{
		[[self.windowControllers[0] window]close];
	}];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if (menuItem.action == @selector(send:)) {
		return [[self.windowControllers[0] composeViewController].viewModel toFieldAddresses].count != 0;
	}
	return [super validateMenuItem:menuItem];
}

- (IBAction)saveMessage:(id)sender {
	
	NSString *urlString = [[NSString stringWithFormat:@"~/Library/Application Support/DotMail/Drafts/%@.eml", [[self.windowControllers[0] composeViewController].viewModel messageID]] stringByExpandingTildeInPath];
	NSSaveOperationType saveType = [NSFileManager.defaultManager fileExistsAtPath:urlString] ? NSSaveOperation : NSSaveAsOperation;
	NSURL *url = [NSURL fileURLWithPath:urlString];
	[self saveToURL:url ofType:@"eml" forSaveOperation:saveType completionHandler:^(NSError *errorOrNil) {
		NSLog(@"");
	}];
	
	[[[self.windowControllers[0] composeViewController].viewModel saveMessage] subscribeCompleted:^{ }];
}


- (IBAction)showAttachFilesWindow:(id)sender {
	if (self.attachmentsOpenPanel == nil) {
		self.attachmentsOpenPanel = [NSOpenPanel openPanel];
		[self.attachmentsOpenPanel setCanChooseFiles:YES];
		[self.attachmentsOpenPanel setCanChooseDirectories:YES];
		[self.attachmentsOpenPanel setAllowsMultipleSelection:YES];
	}
	@weakify(self);
	[self.attachmentsOpenPanel beginSheetModalForWindow:[self.windowControllers[0] window] completionHandler:^(NSInteger returnCode) {
		@strongify(self);
		if (returnCode == NSFileHandlingPanelCancelButton) return;
		
		NSOpenPanel *panel = self.attachmentsOpenPanel;
		if (panel != nil) {
			NSMutableArray *files = [NSMutableArray array];
			for (NSURL *fileURL in panel.URLs) {
				[files addObject:fileURL.path];
			}
			[self.attachmentsOpenPanel orderOut:nil];
			[[self.windowControllers[0] composeViewController].viewModel addFilenames:files];
			
		}
	}];
}

- (void)close {
	if (self.onClose != NULL) {
		self.onClose(self);
	}
	[super close];
}

@end

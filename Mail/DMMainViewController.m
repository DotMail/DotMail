//
//  DMMainViewController.m
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMMainViewModel.h"
#import "DMSplitView.h"
#import "DMAttachmentsViewController.h"
#import "DMAccountListViewController.h"
#import "DMConversationListController.h"
#import "DMConversationViewController.h"
#import "DMSocialPopoverViewController.h"
#import "DMUpdatePopoverViewController.h"
#import "DMMainWindow.h"
#import "DMToolbarButton.h"
#import "DMActivityProgressView.h"
#import "DMBasicAssistantViewController.h"
#import "DMSearchField.h"
#import <Puissant/PSTConstants.h>
#import <MoonShine/MoonShine.h>

@interface DMMainViewController ()

@property (nonatomic, strong) DMAccountListViewController *accountListController;
@property (nonatomic, strong) DMConversationViewController *conversationViewController;
@property (nonatomic, strong) DMAttachmentsViewController *attachmentsViewController;

@end

@implementation DMMainViewController {
	BOOL _allowCompletion;
}

- (instancetype)initWithContentRect:(NSRect)rect {
	self = [super init];

	_frame = rect;
	_viewModel = [DMMainViewModel new];
	
	[NSNotificationCenter.defaultCenter addObserverForName:PSTMailAccountFetchedNewMessageNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
		NSArray *messages = [notification.userInfo objectForKey:PSTMessagesKey];
		NSArray *conversationIDs = [notification.userInfo objectForKey:PSTConversationIDsKey];
		if ([[PSTNotificationHub defaultNotificationHub] isGrowlInstalled] || [[PSTNotificationHub defaultNotificationHub] isNotificationCenterEnabled]) {
			for (NSUInteger i = 0; i < messages.count; i++) {
				[PSTNotificationHub.defaultNotificationHub queueNotificationForMessage:[messages objectAtIndex:i] conversationID:[conversationIDs[i] longLongValue] account:self.viewModel.account];
			}
		}
	}];
	
	return self;
}

- (void)loadView {
	NSView *view = [[NSView alloc]initWithFrame:_frame];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	
	DMSplitView *splitView = [[DMSplitView alloc]initWithFrame:view.bounds];
	splitView.dividerStyle = NSSplitViewDividerStyleThin;
	[splitView setDividerColor:[NSColor colorWithCalibratedRed:0.109 green:0.120 blue:0.135 alpha:1.000]];
	[splitView setVertical:YES];
	splitView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
	
	_accountListController = [[DMAccountListViewController alloc] initWithContentRect:(NSRect){ .size.width = 164, .size.height = _frame.size.height }];
	TUINSView *sidebarContainerView = [[TUINSView alloc]initWithFrame:_accountListController.view.bounds];
	sidebarContainerView.rootView = _accountListController.view;
	[splitView addSubview:sidebarContainerView];
	
	_attachmentsViewController = [[DMAttachmentsViewController alloc]initWithContentRect:(NSRect){ .size.width = CGRectGetWidth(_frame) - 165, .size.height = _frame.size.height }];
	RAC(self.attachmentsViewController,account) = RACObserve(self.viewModel,account);
	_attachmentsViewController.view.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
	[splitView addSubview:_attachmentsViewController.view];
	
	DMSplitView *innerSplitView = [[DMSplitView alloc]initWithFrame:(NSRect){ .size.width = CGRectGetWidth(_frame) - 165, .size.height = _frame.size.height }];
	innerSplitView.vertical = YES;
	innerSplitView.autoresizingMask = kPSTAutoresizingMaskAll;
	innerSplitView.dividerStyle = NSSplitViewDividerStyleThin;
	[innerSplitView setDividerColor:[NSColor colorWithCalibratedRed:222/255.0f green:230/255.0f blue:235/255.0f alpha:1.0f]];
	[_attachmentsViewController.view addSubview:innerSplitView];
	[innerSplitView rac_liftSelector:@selector(setHidden:) withSignals:[RACObserve(self.attachmentsViewController.view,isHidden) skip:1], nil];
	
	[splitView reset];
	splitView.subviewsResizeMode = DMSplitViewResizeModePriorityBased;
	[splitView setPriority:1 ofSubviewAtIndex:0];
	[splitView setPriority:0 ofSubviewAtIndex:1];
	[splitView setHoldingPriority:NSLayoutPriorityDragThatCanResizeWindow forSubviewAtIndex:0];
	
	[splitView setMinSize:164 ofSubviewAtIndex:0];
	
	_conversationListController = [[DMConversationListController alloc]initWithContentRect:(NSRect){ .size.width = 292, .size.height = _frame.size.height }];
	RAC(self.viewModel,account) = RACObserve(self.accountListController,selectedAccount);
	RAC(self.conversationListController,account) = RACObserve(self.viewModel,account);
	RAC(self.conversationListController,selectedMailbox) = RACObserve(self.accountListController,selectedMailbox);

	[innerSplitView addSubview:_conversationListController.view];
	[_conversationListController setup];

	DMActivityProgressView *progressView = [[DMActivityProgressView alloc]initWithFrame:(CGRect){ .origin.y = -50, .size.width = CGRectGetWidth(_conversationListController.view.frame), .size.height = 50 }];
	progressView.autoresizingMask = TUIViewAutoresizingFlexibleWidth;
	[_conversationListController.view addSubview:progressView];
	
	_conversationViewController = [[DMConversationViewController alloc]initWithFrame:(NSRect){ .size.width = (CGRectGetWidth(_frame) - 165 - 293), .size.height = _frame.size.height }];
	RAC(self.conversationViewController,account) = RACObserve(self.viewModel,account);
	RAC(self.conversationViewController,conversation) = RACObserve(self.conversationListController,selectedConversation);
	[innerSplitView addSubview:_conversationViewController.view];
	
	[innerSplitView reset];
	innerSplitView.subviewsResizeMode = DMSplitViewResizeModePriorityBased;
	[innerSplitView setMinSize:290 ofSubviewAtIndex:0];
	[innerSplitView setMinSize:482 ofSubviewAtIndex:1];
	[innerSplitView setPriority:1 ofSubviewAtIndex:0];
	[innerSplitView setPriority:0 ofSubviewAtIndex:1];

	[view addSubview:splitView];
	
	self.view = view;
	[_conversationViewController load];
}

- (void)reinstateToolbar {
	DMMainWindow *window = (DMMainWindow *)self.view.window;
	
	NSPopover *popover = [[NSPopover alloc] init];
	[popover setBehavior:NSPopoverBehaviorTransient];
	
	NSPopover *updateInstalledPopover = [[NSPopover alloc] init];
	[updateInstalledPopover setContentViewController:[[DMUpdatePopoverViewController alloc] initWithReleaseNotes:@""]];
	[updateInstalledPopover setBehavior:NSPopoverBehaviorTransient];
	
	DMSocialPopoverViewController *facebookPopoverViewController = [[DMSocialPopoverViewController alloc] initWithSocialMode:DMSocialPopoverModeFacebook];
	RAC(facebookPopoverViewController,account) = RACObserve(self.viewModel,account);
	DMSocialPopoverViewController *dribbblePopoverViewController = [[DMSocialPopoverViewController alloc] initWithSocialMode:DMSocialPopoverModeDribbble];
	RAC(dribbblePopoverViewController,account) = RACObserve(self.viewModel,account);
	DMSocialPopoverViewController *twitterPopoverViewController = [[DMSocialPopoverViewController alloc] initWithSocialMode:DMSocialPopoverModeTwitter];
	RAC(twitterPopoverViewController,account) = RACObserve(self.viewModel,account);
	
	DMToolbarButton *updateButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarUpdate"]];
	[updateButton.rac_selectionSignal subscribeNext:^(DMToolbarButton *x) {
		if (updateInstalledPopover.shown) {
			return;
		}
		[updateInstalledPopover showRelativeToRect:x.bounds ofView:x preferredEdge:NSMinYEdge];
	}];
	RAC(((DMUpdatePopoverViewController *)updateInstalledPopover.contentViewController),releaseNotes) = [[RACObserve(MSHUpdater.standardUpdater,releaseNotes) filter:^BOOL(id value) {
		return value != nil;
	}] doNext:^(id x) {
		[window addButtonToTitleBar:updateButton atXPosition:150];
	}];
	DMToolbarButton *attachmentButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarAttachment.png"]];
	__block BOOL attachHidden = YES;
	@weakify(self);
	[attachmentButton.rac_selectionSignal subscribeNext:^(id _) {
		@strongify(self);
		[self.conversationListController.view.superview setHidden:attachHidden];
		attachHidden = !attachHidden;
	}];
	DMToolbarButton *activityButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarCloud"]];
	DMToolbarButton *composeButton = [[DMToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarCompose.png"]];
	composeButton.alternateImage = [NSImage imageNamed:@"ToolbarComposeSelected.png"];
	[composeButton.rac_selectionSignal subscribeNext:^(id _) {
		@strongify(self);
		[self.viewModel composeMessage:NSApp];
	}];
	DMBadgedToolbarButton *twitterButton = [[DMBadgedToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarTwitter.png"]];
	[twitterButton rac_liftSelector:@selector(setBadgeCount:) withSignals:RACObserve(twitterPopoverViewController,socialCount), nil];
	[twitterButton.rac_selectionSignal subscribeNext:^(DMToolbarButton *x) {
		if (popover.contentViewController != twitterPopoverViewController) {
			[popover setContentViewController:twitterPopoverViewController];
		}
		[popover showRelativeToRect:CGRectInset(x.bounds, 6, 6) ofView:x preferredEdge:NSMinYEdge];
	}];
	DMBadgedToolbarButton *dribbleButton = [[DMBadgedToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarDribble.png"]];
	[dribbleButton rac_liftSelector:@selector(setBadgeCount:) withSignals:RACObserve(dribbblePopoverViewController,socialCount), nil];
	[dribbleButton.rac_selectionSignal subscribeNext:^(DMToolbarButton *x) {
		if (popover.contentViewController != dribbblePopoverViewController) {
			[popover setContentViewController:dribbblePopoverViewController];
		}
		[popover showRelativeToRect:CGRectInset(x.bounds, 6, 6) ofView:x preferredEdge:NSMinYEdge];
	}];
	DMBadgedToolbarButton *facebookButton = [[DMBadgedToolbarButton alloc]initWithImage:[NSImage imageNamed:@"ToolbarFacebook.png"]];
	[facebookButton rac_liftSelector:@selector(setBadgeCount:) withSignals:RACObserve(facebookPopoverViewController,socialCount), nil];
	[facebookButton.rac_selectionSignal subscribeNext:^(DMToolbarButton *x) {
		if (popover.contentViewController != facebookPopoverViewController) {
			[popover setContentViewController:facebookPopoverViewController];
		}
		[popover showRelativeToRect:CGRectInset(x.bounds, 6, 6) ofView:x preferredEdge:NSMinYEdge];
	}];
	DMSearchField *searchField = [[DMSearchField alloc]initWithFrame:(NSRect){ .size.height = 22, .size.width = 320 }];
	self.conversationListController.searchField = searchField;
	
	[window addButtonToTitleBar:composeButton atXPosition:350];
	[window addButtonToTitleBar:activityButton atXPosition:315];
	[window addButtonToTitleBar:attachmentButton atXPosition:280];
	[window addButtonToTitleBar:searchField atXPosition:CGRectGetWidth(window.frame) - 360];
	[window addButtonToTitleBar:facebookButton atXPosition:CGRectGetWidth(window.frame) - 408];
	[window addButtonToTitleBar:dribbleButton atXPosition:CGRectGetWidth(window.frame) - 438];
	[window addButtonToTitleBar:twitterButton atXPosition:CGRectGetWidth(window.frame) - 468];
	
	RACSignal *listViewSignal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		id observer = [NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification object:self.conversationListController.view queue:nil usingBlock:^(NSNotification *note) {
			[subscriber sendNext:note.object];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[[NSNotificationCenter defaultCenter] removeObserver:observer];
		}];
	}];
	RACSignal *accountListViewSignal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		id observer = [NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification object:self.accountListController.view queue:nil usingBlock:^(NSNotification *note) {
			[subscriber sendNext:note.object];
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[NSNotificationCenter.defaultCenter removeObserver:observer];
		}];
	}];
			
	[[RACSignal combineLatest:@[ [listViewSignal startWith:self.conversationListController.view] , [accountListViewSignal startWith:self.accountListController.view] ] reduce:^id (NSView *conversationListView, NSView *accountListView) {
		NSRect accountFrame = accountListView.frame;
		NSRect frame = composeButton.bounds;
		frame.origin.x = CGRectGetWidth(accountFrame);
		return [NSValue valueWithRect:frame];
	}] subscribeNext:^(NSValue *value) {
		NSRect frame = value.rectValue;
		frame.origin.x += CGRectGetMidX(self.conversationListController.view.frame);
		frame.origin.x -= 50;
		attachmentButton.frame = frame;
		frame.origin.x += 35;
		activityButton.frame = frame;
		frame.origin.x += 35;
		composeButton.frame = frame;

	}];
	
	[[RACSignal if:[RACObserve(self.viewModel,showLoginWindow) distinctUntilChanged] then:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if ((self.view.window.styleMask & NSFullScreenWindowMask) == NSFullScreenWindowMask) {
			[self.view.window toggleFullScreen:NSApp];
		}
		[self.view.window close];
		[[DMAccountSetupWindowController standardAccountSetupWindowController].window makeKeyAndOrderFront:NSApp];
		return nil;
	}] else:[RACSignal empty]] subscribeCompleted:^{

	}];
}

- (void)editDraftMessage:(PSTConversation *)conversation {
	[self.viewModel editDraftMessage:conversation];
}

- (void)unload {
	[self.attachmentsViewController unload];
}

- (void)selectMailbox:(PSTFolderType)mailbox {
	[self.accountListController setSelectionForCurrentAccount:mailbox];
}

- (void)selectPreviousAccount:(id)sender {
	[self.accountListController selectPreviousAccount:sender];
}

- (void)selectNextAccount:(id)sender {
	[self.accountListController selectNextAccount:sender];
}

- (void)print:(id)sender {
	[self.conversationViewController print:sender];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if (menuItem.action == @selector(selectNextAccount:)) {
		return [self.accountListController validateMenuItem:menuItem];
	} else if (menuItem.action == @selector(selectPreviousAccount:)) {
		return [self.accountListController validateMenuItem:menuItem];
	} else if (menuItem.action == @selector(print:)) {
		return (self.conversationListController.mailboxTableView.selectedRowIndexes.count == 1);
	}
	return YES;
}


#pragma mark - NSObject+QLPreviewPanel

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
	return [self.attachmentsViewController acceptsPreviewPanelControl:panel];
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
	[self.attachmentsViewController beginPreviewPanelControl:panel];
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
	[self.attachmentsViewController endPreviewPanelControl:panel];
}

#pragma mark - QLPreviewPanelDataSource

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
	return [self.attachmentsViewController numberOfPreviewItemsInPreviewPanel:panel];
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
	return [self.attachmentsViewController previewPanel:panel previewItemAtIndex:index];
}

#pragma mark - QLPreviewPanelDelegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
	return [self.attachmentsViewController previewPanel:panel handleEvent:event];
}

- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
	return [self.attachmentsViewController previewPanel:panel sourceFrameOnScreenForPreviewItem:item];
}

- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
	return [self.attachmentsViewController previewPanel:panel transitionImageForPreviewItem:item contentRect:contentRect];
}


@end

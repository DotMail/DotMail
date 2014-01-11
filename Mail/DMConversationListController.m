//
//  CFIConversationListDepotDelegate.m
//  Mail
//
//  Created by Robert Widmann on 7/28/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMConversationListController.h"
#import "DMConversationListViewModel.h"
#import "DMLabel.h"
#import "DMPullToRefreshScrollView.h"
#import "DMRefreshControl.h"
#import "DMSearchField.h"
#import "DMLayeredImageView.h"
#import "DMColoredView.h"
#import "DMMessageCell.h"
#import "DMConversationWindowController.h"
#import "DMMainWindow.h"
#import "DMMenuItemCustomView.h"
#import "DMAppDelegate.h"
#import "DMMainViewController.h"
#import "DMSearchTokenAttachment.h"

@interface DMConversationListController () <DMPullToRefreshScrollViewDelegate>

@property (nonatomic, strong, readonly) DMConversationListViewModel *viewModel;

@property (nonatomic, strong) CATextLayer *noMessagesLabel;
@property (nonatomic, strong) DMLabel *loadingLabel;
@property (nonatomic, strong) DMRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableSet *activeConversationPanels;

@property (nonatomic, strong) DMLayeredImageView *overlay;
@property (nonatomic, copy) NSAttributedString *searchValue;

@end

@implementation DMConversationListController {
	NSRect _contentRect;
	BOOL _allowCompletion;
	NSMenu *_suggestionsMenu;
	NSMutableArray *_suggestionsStrings;
}

- (instancetype)initWithContentRect:(NSRect)rect {
	self = [super init];
	
	_viewModel = [[DMConversationListViewModel alloc] init];
	_reloading = NO;
	_contentRect = rect;
	_activeConversationPanels = [NSMutableSet set];
	
	return self;
}

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc] initWithFrame:_contentRect];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = NSColor.whiteColor;
	
	self.progressView = [[TUIActivityIndicatorView alloc]initWithFrame:CGRectZero activityIndicatorStyle:TUIActivityIndicatorViewStyleGray];
//	[self.progressView setAutoresizingMask:TUIViewAutoresizingFlexibleSize];

	DMPullToRefreshScrollView *scrollView = [[DMPullToRefreshScrollView alloc] initWithFrame:view.bounds];
	scrollView.delegate = self;
	scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	scrollView.hasVerticalScroller = YES;
	_mailboxTableView = [[NSTableView alloc] initWithFrame:scrollView.bounds];
	_mailboxTableView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	_mailboxTableView.dataSource = self.viewModel;
	_mailboxTableView.delegate = self.viewModel;
	_mailboxTableView.menu = DMMakeContextMenu(self);
	_mailboxTableView.headerView = nil;
	_mailboxTableView.target = self;
	_mailboxTableView.doubleAction = @selector(doubleClick);
	_mailboxTableView.allowsMultipleSelection = YES;
	scrollView.documentView = _mailboxTableView;

	CTFontRef noMessagesFont = CTFontCreateWithName(CFSTR("HelveticaNeue-Bold"), 16.f, NULL);
	_noMessagesLabel = CATextLayer.layer;
	_noMessagesLabel.frame = (CGRect){ .origin.y = CGRectGetMidY(view.bounds) - 150, .size.width = CGRectGetWidth(view.bounds), .size.height = 300 };
	_noMessagesLabel.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	_noMessagesLabel.font = noMessagesFont;
	_noMessagesLabel.backgroundColor = NSColor.clearColor.CGColor;
	_noMessagesLabel.alignmentMode = @"center";
	_noMessagesLabel.fontSize = 16.f;
	_noMessagesLabel.foregroundColor = [NSColor colorWithCalibratedRed:0.552 green:0.593 blue:0.633 alpha:1.000].CGColor;
	_noMessagesLabel.string = @"Mailbox Empty";
	_noMessagesLabel.hidden = YES;

	self.loadingLabel = [[DMLabel alloc]initWithFrame:CGRectZero];
	[self.loadingLabel setText:@"Loading"];
	[self.loadingLabel setAutoresizingMask:(TUIViewAutoresizingFlexibleSize)];
	[self.loadingLabel setBackgroundColor:[NSColor clearColor]];
	[self.loadingLabel setTextAlignment:NSCenterTextAlignment];
	[self.loadingLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:16]];
	[self.loadingLabel setTextColor:[NSColor colorWithCalibratedRed:0.552 green:0.593 blue:0.633 alpha:1.000]];
	[self.loadingLabel setHidden:YES];
	
	[view addSubview:scrollView];
//	[view addSubview:self.progressView];
	[view.layer addSublayer:self.noMessagesLabel];
	[view addSubview:self.loadingLabel];

	self.view = view;
	
	CFRelease(noMessagesFont);
}

- (void)setup {
	[self.loadingLabel setFrame:(CGRect){ .origin.y = CGRectGetMidY(self.view.bounds) - 120, .size.width = CGRectGetWidth(self.view.bounds), .size.height = 300 }];
//	self.progressView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 22, CGRectGetMidY(self.view.bounds) - 22, 30, 30);
//	[self.progressView startAnimating];
	[self.loadingLabel setHidden:NO];
//	[self.noMessagesLabel setFrame:(CGRect){ .origin.y = CGRectGetMidY(self.view.bounds) - 150, .size.width = CGRectGetWidth(self.view.bounds), .size.height = 300 }];

	_overlay = [[DMLayeredImageView alloc]initWithFrame:self.view.bounds];
	_overlay.editable = NO;
	_overlay.acceptsTouchEvents = NO;
	[self.view addSubview:_overlay];
	
	@weakify(self);
	[RACChannelTo(self.viewModel,count) subscribeNext:^(id x) {
		@strongify(self);
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_countUpdatedAfterDelay) object:nil];
		[self performSelector:@selector(_countUpdatedAfterDelay) withObject:nil afterDelay:0];
	}];
	
	[RACChannelTo(self.viewModel,selectedConversation) subscribeNext:^(id x) {
		@strongify(self);
		self.selectedConversation = x;
		[self.delegate conversationListControllerDidChangeSelection:self];
	}];
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"searchSuggestions"]) {
		[self _showSearchSuggestions];
	}
}


- (void)controlTextDidChange:(NSNotification *)obj {
	if ([obj object] == _searchField) {
		_allowCompletion = YES;
	}
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
	if (_searchField == control) {
		[self _cancelMsgListSearchSuggestions];
	}
	return YES;
}

- (void)_updateSearch {
}

- (void)_cancelMsgListSearchSuggestions {
	_allowCompletion = NO;
}

- (void)_showSearchSuggestions {
	if ([self _originalStringToComplete].length == 0) {
		return;
	}
	NSFont *font = [NSFont fontWithName:@"LucidaGrande" size:[NSFont smallSystemFontSize]];
	if (!_suggestionsMenu) {
		_suggestionsMenu = [[NSMenu alloc] initWithTitle:@""];
		_suggestionsMenu.font = font;
		_suggestionsStrings = @[].mutableCopy;
	}
	[_suggestionsMenu removeAllItems];
	[_suggestionsStrings removeAllObjects];
	if (_searchField) {
		_suggestionsMenu.minimumWidth = CGRectGetWidth(_searchField.frame);
	}
	NSDictionary *attributes = @{ NSFontAttributeName : [NSFont fontWithName:@"LucidaGrande" size:[NSFont smallSystemFontSize]] };
	
	[[self.account searchSuggestionsTerms] objectForKey:@"status"];
	NSMenuItem *containsItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Message contains \"%@\"", self._originalStringToComplete] action:@selector(_searchInMessage:) keyEquivalent:@""];
	[containsItem setAttributedTitle:[[NSAttributedString alloc] initWithString:containsItem.title attributes:attributes]];
	containsItem.target = self;
	containsItem.tag = 20;
	containsItem.indentationLevel = 1;
	[_suggestionsMenu addItem:containsItem];
	[_suggestionsStrings addObject:self._originalStringToComplete];
	
	[self _showSearchSuggestionsWithMenu:_suggestionsMenu];
}

- (void)_showSearchSuggestionsWithMenu:(NSMenu *)menu {
	if (!_allowCompletion) {
		return;
	}
}

- (void)_searchInMessage:(NSMenuItem *)sender {
	PSTSearchTerm *term = [[PSTSearchTerm alloc] init];
	term.originalString = [self _originalStringToComplete];
	term.kind = 0xa;
	term.value = [self _originalStringToComplete];
	[self _replaceSearchSuggestion:term];
}

- (void)_replaceSearchSuggestion:(PSTSearchTerm *)term {
	DMSearchTokenAttachment *attachment =  [[DMSearchTokenAttachment alloc] init];
	attachment.maxWidth = CGRectGetWidth(_searchField.frame);
	attachment.controlSize = NSSmallControlSize;
	attachment.term = term;
//	[_suggestionsController replaceStringWithAttributedCompletion:[NSAttributedString attributedStringWithAttachment:attachment]];
	[self _cancelMsgListSearchSuggestions];
}

- (NSAttributedString *)_originalStringToComplete {
	return self.searchField.attributedStringValue;
//	return [_suggestionsController originalStringToComplete];
}

- (void)reloadData {
	[self.mailboxTableView reloadData];
	[(DMPullToRefreshScrollView *)self.mailboxTableView.enclosingScrollView stopLoading];
	if (self.previousSelection != nil) {
		[self.mailboxTableView selectRowIndexes:self.previousSelection byExtendingSelection:NO];
	}
//	[self.mailboxTableView scrollToTopAnimated:YES];
}

- (void)setSearchField:(DMSearchField *)searchField {
	searchField.delegate = self;
	[searchField setTarget:self];
	[searchField setAction:@selector(search:)];
	_searchField = searchField;
}

- (void)search:(DMSearchField *)sender {
	[self _updateSearch];
}

- (NSIndexSet *)previousSelection {
	return self.viewModel.previousSelection;
}

- (CALayer *)currentRenderingLayerDisabled:(BOOL)disabled {
	if (self.view.superview == nil) {
		return nil;
	}
	CALayer *viewLayer = layerFromLayer(self.view.layer);
	CALayer *tableLayer = layerFromLayer(self.mailboxTableView.layer);
	
	[viewLayer addSublayer:tableLayer];
	return viewLayer;
}

static CALayer *layerFromLayer(CALayer *layer) {
	CALayer *retVal = [[CALayer alloc]initWithLayer:layer];
	[retVal setOpaque:YES];
	[retVal setBounds:layer.bounds];
	
	return retVal;
}

- (void)setSelectedMailbox:(NSUInteger)selectedMailbox {
	if (self.account != nil && (selectedMailbox != _selectedMailbox)) {
		[self.overlay setAlphaValue:1.0f];
		self.overlay.frame = self.view.bounds;
		self.mailboxTableView.enclosingScrollView.frame = NSInsetRect(NSOffsetRect(self.mailboxTableView.enclosingScrollView.frame, 0, 60), 4, 20);
		self.mailboxTableView.enclosingScrollView.alphaValue = 0.8;

		CGContextRef context = NULL;
		CGColorSpaceRef colorSpace;
		NSInteger bitmapBytesPerRow;
		
		NSInteger pixelsHigh = (NSInteger)[[self.view layer] bounds].size.height;
		NSInteger pixelsWide = (NSInteger)[[self.view layer] bounds].size.width;
		
		bitmapBytesPerRow   = (pixelsWide * 4);
		
		colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		
		context = CGBitmapContextCreate (NULL,
										 pixelsWide,
										 pixelsHigh,
										 8,
										 bitmapBytesPerRow,
										 colorSpace,
										 (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
		
		CGColorSpaceRelease(colorSpace);
		
		[[[self.view layer] presentationLayer] renderInContext:context];
		
		CGImageRef img = CGBitmapContextCreateImage(context);
		NSImage *image = [[NSImage alloc]initWithCGImage:img size:[[self.view layer] bounds].size];
		[self.overlay setImage:image];

		CGContextRelease(context);
		CGImageRelease(img);
		
		[self performSelector:@selector(animate:) withObject:image afterDelay:0.1];
		
		_selectedMailbox = selectedMailbox;
		self.selectedConversation = nil;
	}
}

- (void)animate:(NSImage *)image {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext]setDuration:0.25];
	[self.overlay.animator setAlphaValue:0.0f];
	[self.overlay.animator setFrame:NSInsetRect(NSOffsetRect(self.overlay.frame, 0, -60), 4, 20)];
	[self.mailboxTableView.enclosingScrollView.animator setAlphaValue:1.0f];
	[self.mailboxTableView.enclosingScrollView.animator setFrame:self.view.bounds];
	[NSAnimationContext endGrouping];
}

- (void)_hideActivityView {
	[self.progressView stopAnimating];
	[self.noMessagesLabel setHidden:YES];
	[self.loadingLabel setHidden:YES];
}

- (void)setAccount:(PSTAccountController *)account {
	if (_account != account) {
		[_account removeObserver:self forKeyPath:@"searchSuggestions"];
		[account addObserver:self forKeyPath:@"searchSuggestions" options:0 context:NULL];
		_account = account;
		self.viewModel.account = account;
	}
}

- (void)_countUpdatedAfterDelay {
	[self _hideActivityView];
	[self.mailboxTableView reloadData];
//	[self.mailboxTableView scrollToTopAnimated:NO];
	if (self.currentConversations.count == 0) {
		[self _showNoMessagesLabel];
	}
}

- (void)_showNoMessagesLabel {
	[self.noMessagesLabel setHidden:NO];
}

- (void)scrollToTop {
//	[self.mailboxTableView scrollToTopAnimated:YES];
}

- (void)selectInbox {
	[self.account setSelectedFolder:PSTFolderTypeInbox];
	[self.account refreshSync];
	[self.delegate conversationListControllerDidChangeSelection:self];
}

- (void)selectMailbox:(PSTFolderType)mailbox {
	[self.account setSelectedFolder:mailbox];
	self.selectedConversation = nil;
	[self.delegate conversationListControllerDidChangeSelection:self];
}

- (void)scrollViewDidTriggerRefresh:(DMPullToRefreshScrollView *)scrollView {
	[self.account refreshSync];
}

- (void)_enableShowRefreshTemporarily {
//	[TUIView animateWithDuration:0.25 animations:^{
//		[self.progressView setAlpha:1.0f];
//	}];
}

- (NSMutableArray *)currentConversations {
	return self.viewModel.currentConversations;
}

- (BOOL)hasConversations {
	return (self.currentConversations.count != 0);
}

#pragma mark - NSMenu Convenience Method

static NSMenu *DMMakeContextMenu(DMConversationListController *self) {
	static NSMenu *fileMenu = nil;
	if (fileMenu == nil) {
		fileMenu = [[NSMenu alloc] init];
		NSMenuItem *replyMenuItem = [[NSMenuItem alloc] initWithTitle:@"Reply" action:@selector(replyMessage:) keyEquivalent:@""];
		[replyMenuItem setTarget:[NSApp delegate]];
		NSMenuItem *replyAllMenuItem = [[NSMenuItem alloc] initWithTitle:@"Reply All" action:@selector(replyAllMessage:) keyEquivalent:@""];
		[replyAllMenuItem setTarget:[NSApp delegate]];
		NSMenuItem *forwardMenuItem = [[NSMenuItem alloc] initWithTitle:@"Forward" action:NULL keyEquivalent:@""];
		NSMenuItem *toggleRead = [[NSMenuItem alloc] initWithTitle:@"Toggle Read" action:@selector(_toggleCurrentCellReadState) keyEquivalent:@""];
		[toggleRead setTarget:self];
		[toggleRead setAction:@selector(_toggleCurrentCellReadState)];
				
		NSMenu *actionStepsMenu = [[NSMenu alloc]initWithTitle:@"Action Step"];
		NSMenuItem *actionStepsSuperMenuItem = [[NSMenuItem alloc] initWithTitle:@"Action Step" action:NULL keyEquivalent:@""];
		NSMenuItem *highPriorityActionStepMenu = [[NSMenuItem alloc] initWithTitle:@"High" action:@selector(assignSelectedCellHighPriority) keyEquivalent:@""];
		[highPriorityActionStepMenu setView:[DMMenuItemCustomView customViewWithTitle:@"High" tileColor:[NSColor colorWithCalibratedRed:0.871 green:0.000 blue:0.079 alpha:1.000]]];
		[highPriorityActionStepMenu setTarget:self];
		NSMenuItem *mediumPriorityActionStepMenu = [[NSMenuItem alloc] initWithTitle:@"Medium" action:@selector(assignSelectedCellMediumPriority) keyEquivalent:@""];
		[mediumPriorityActionStepMenu setView:[DMMenuItemCustomView customViewWithTitle:@"Medium" tileColor:[NSColor colorWithCalibratedRed:0.902 green:0.355 blue:0.350 alpha:1.000]]];
		[mediumPriorityActionStepMenu setTarget:self];
		NSMenuItem *lowPriorityActionStepMenu = [[NSMenuItem alloc] initWithTitle:@"Low" action:@selector(assignSelectedCellLowPriority) keyEquivalent:@""];
		[lowPriorityActionStepMenu setView:[DMMenuItemCustomView customViewWithTitle:@"Low" tileColor:[NSColor colorWithCalibratedRed:0.949 green:0.625 blue:0.665 alpha:1.000]]];
		[lowPriorityActionStepMenu setTarget:self];
		NSMenuItem *noPriorityActionStepMenu = [[NSMenuItem alloc] initWithTitle:@"None" action:@selector(assignSelectedCellNoPriority) keyEquivalent:@""];
		[noPriorityActionStepMenu setView:[DMMenuItemCustomView customViewWithTitle:@"None"]];
		[noPriorityActionStepMenu setTarget:self];
		[actionStepsMenu addItem:highPriorityActionStepMenu];
		[actionStepsMenu addItem:mediumPriorityActionStepMenu];
		[actionStepsMenu addItem:lowPriorityActionStepMenu];
		[actionStepsMenu addItem:noPriorityActionStepMenu];
		
		[fileMenu addItem:replyMenuItem];
		[fileMenu addItem:replyAllMenuItem];
		[fileMenu addItem:forwardMenuItem];
		[fileMenu addItem:NSMenuItem.separatorItem];
		[fileMenu addItem:actionStepsSuperMenuItem];
		[fileMenu setSubmenu:actionStepsMenu forItem:actionStepsSuperMenuItem];
		[fileMenu addItem:NSMenuItem.separatorItem];
		[fileMenu addItem:toggleRead];

	}
	NSInteger selectedRow = self.mailboxTableView.clickedRow;
	if (selectedRow != -1) {
		[fileMenu.itemArray[0] setRepresentedObject:[self currentConversations][selectedRow]];
		[fileMenu.itemArray[1] setRepresentedObject:[self currentConversations][selectedRow]];
	}
	return fileMenu;
}

- (void)_replyCurrentCell {
	
}

- (void)assignSelectedCellHighPriority {
	[(DMMessageCell *)[self.mailboxTableView rowViewAtRow:self.mailboxTableView.clickedRow makeIfNecessary:NO] highPriorityClicked];
}

- (void)assignSelectedCellMediumPriority {
	[(DMMessageCell *)[self.mailboxTableView rowViewAtRow:self.mailboxTableView.clickedRow makeIfNecessary:NO] mediumPriorityClicked];
}

- (void)assignSelectedCellLowPriority {
	[(DMMessageCell *)[self.mailboxTableView rowViewAtRow:self.mailboxTableView.clickedRow makeIfNecessary:NO] lowPriorityClicked];
}

- (void)assignSelectedCellNoPriority {
	[(DMMessageCell *)[self.mailboxTableView rowViewAtRow:self.mailboxTableView.clickedRow makeIfNecessary:NO] resetPriorityClicked];
}

- (void)_toggleCurrentCellReadState {
	[(DMMessageCell *)[self.mailboxTableView rowViewAtRow:self.mailboxTableView.clickedRow makeIfNecessary:NO] toggleUnread];
}

- (void)doubleClick {
	if (!self.selectedConversation) return;
	
	if (self.selectedMailbox == PSTFolderTypeDrafts) {
		@weakify(self);
		[self.mailboxTableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			@strongify(self);
			[((DMMainWindow *)self.view.window).viewController editDraftMessage:self.currentConversations[idx]];
		}];
	} else {
		@weakify(self);
		[self.mailboxTableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			@strongify(self);
			DMConversationWindowController *conversationWindowController = [[DMConversationWindowController alloc] initWithConversation:self.currentConversations[idx]];
			[self.activeConversationPanels addObject:conversationWindowController];
			conversationWindowController.onCloseBlock = ^(id token){
				[self.activeConversationPanels removeObject:token];
			};
			[conversationWindowController.window makeKeyAndOrderFront:nil];
			[conversationWindowController showWindow:nil];
		}];
	}
}

@end
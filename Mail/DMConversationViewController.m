//
//  DMConversationViewController.m
//  DotMail
//
//  Created by Robert Widmann on 11/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMConversationViewController.h"
#import "DMComposeView.h"
#import "DMShadowView.h"
#import <Puissant/Puissant.h>

@interface DMConversationViewController ()

@property (nonatomic, strong) WebView *printWebView;
@property (nonatomic, strong) NSNotification *updateNotification;

@property (nonatomic, strong) NSMutableDictionary *attachedMessagesDictionary;
@property (nonatomic, strong) NSTextField *noMessageShownLabel;
@property (nonatomic, strong) NSArray *currentLabels;
@property (nonatomic, strong) NSMutableArray *colorMapping;
@property (nonatomic, strong) NSMutableArray *displayMessageIDs;

@end

@interface WebCache : NSObject
+ (void)empty;
+ (void)setDisabled:(BOOL)arg1;
@end

@implementation DMConversationViewController {
	NSRect viewFrame;
	NSInteger resourceLoadCount;
	NSInteger printResourceLoadCount;
	struct {
		unsigned int isObservingAccount:1;
		unsigned int setup:1;
		unsigned int loading:1;
		unsigned int frameLoaded:1;
		unsigned int printLoadFinished:1;
		unsigned int emptyLoad:1;
		unsigned int hadFocus:1;
		unsigned int scheduledNoMessageShowAfterDelay:1;
	} _conversationViewFlags;
}

- (instancetype)initWithFrame:(NSRect)rect {
	self = [super init];
	
	viewFrame = rect;
	_displayMessageIDs = @[].mutableCopy;
	[WebCache setDisabled:YES];

	return self;
}

- (void)loadView {
	DMComposeView *view = [[DMComposeView alloc]initWithFrame:viewFrame];

	_noMessageShownLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.y = CGRectGetMidY(view.bounds), .size.width = NSWidth(view.bounds), .size.height = 36 }];
	[_noMessageShownLabel setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin)];
	[_noMessageShownLabel setAlignment:NSCenterTextAlignment];
	[_noMessageShownLabel setBordered:NO];
	[_noMessageShownLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
	[_noMessageShownLabel setBezeled:NO];
	[_noMessageShownLabel setFocusRingType:NSFocusRingTypeNone];
	[_noMessageShownLabel setEditable:NO];
	
	NSMutableParagraphStyle *paragStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragStyle setAlignment:NSCenterTextAlignment];
	NSDictionary *attributes = @{
		NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Bold" size:20.0f],
		NSForegroundColorAttributeName : [NSColor colorWithCalibratedWhite:0.297 alpha:1.000],
		NSParagraphStyleAttributeName : paragStyle
	};
	NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"No conversations selected" attributes:attributes];
	[self.noMessageShownLabel setAttributedStringValue:attrStr];
	[view addSubview:_noMessageShownLabel];

	DMShadowView *shadowView = [DMShadowView coloredShadowViewWithFrame:NSMakeRect(0, 0, 4, NSHeight(view.frame))];
	[shadowView setBackgroundColor:NSColor.whiteColor];
	shadowView.autoresizingMask = NSViewHeightSizable;
	[view addSubview:shadowView];

	self.view = view;
}

- (void)load {
	if (!_conversationViewFlags.setup) {
		[self _cancelUpdateIfNeeded];
		if (!_conversationViewFlags.isObservingAccount) {
			if (self.account != nil) {
				_webView = [[WebView alloc] initWithFrame:self.view.bounds frameName:nil groupName:nil];
				[_webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
				// Automatically sets the version number for the User Agent
				NSString *userAgent = [NSString stringWithFormat:@"DotMail/%@", [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"]];
				[_webView setApplicationNameForUserAgent:userAgent];
				[self.view addSubview:_webView];
				[_webView setEditingDelegate:self];
				[_webView setFrameLoadDelegate:self];
				[_webView setPolicyDelegate:self];
				[_webView setResourceLoadDelegate:self];
				[_webView setUIDelegate:self];
			}
			[self.account addObserver:self forKeyPath:@"sending" options:0 context:NULL];
			[self.account addObserver:self forKeyPath:@"savingDraft" options:0 context:NULL];
			_conversationViewFlags.isObservingAccount = YES;
		}
		_conversationViewFlags.setup = YES;
	}
	[self _updateConversationAfterDelay];
}

- (void)unload {
	[_webView setEditingDelegate:nil];
	[_webView setFrameLoadDelegate:nil];
	[_webView setPolicyDelegate:nil];
	[_webView setResourceLoadDelegate:nil];
	[_webView setUIDelegate:nil];
	[_webView.windowScriptObject removeWebScriptKey:@"WindowController"];
}

- (void)_cancelUpdateIfNeeded {
	_conversationViewFlags.loading = NO;
	[self _setNoMessage];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_updateConversationWebview) object:nil];
}

- (void)_setNoMessage {
	_conversationViewFlags.emptyLoad = YES;
	[[self.webView mainFrame] loadHTMLString:@"" baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
	[self.noMessageShownLabel setHidden:_conversationViewFlags.loading];
}

- (void)_updateConversationAfterDelay {
	if (self.conversation == nil) {
		[[self.webView mainFrame] loadHTMLString:@"" baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
		return;
	} else {
		_conversationViewFlags.loading = YES;
		[self _setNoMessage];
		[self performSelector:@selector(_updateConversationWebview) withObject:nil afterDelay:0];
	}
}

- (void)_updateConversationWebview {
	_conversationViewFlags.loading = NO;
	if (self.conversation == nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[self.webView mainFrame] loadHTMLString:@"" baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
			[self _setNoMessage];
		});
		return;
	}
	[self.conversation load];
	if (self.conversation.messages.count != 0) {
		[self.colorMapping removeAllObjects];
		[self.displayMessageIDs removeAllObjects];
		resourceLoadCount = 0;
		[self.noMessageShownLabel setHidden:YES];
		NSString *htmlRendering = [self.conversation htmlRenderingWithAccount:self.account];
		_conversationViewFlags.emptyLoad = NO;
		for (PSTCachedMessage *message in self.conversation.cache.messages) {
			[_displayMessageIDs addObject:message.uniqueMessageIdentifer];
		}
		[[self.webView mainFrame] loadHTMLString:htmlRendering baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
	}
}

- (void)_conversationUpdated:(NSNotification *)conversation {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_conversationUpdatedAfterDelay) object:nil];
	self.updateNotification = conversation;
	//	[self performSelector:@selector(_conversationUpdatedAfterDelay) withObject:nil afterDelay:DMDefaultDelay inModes:NSConnectionReplyMode];
}

- (void)_conversationUpdatedAfterDelay {
	NSIndexSet *modifiedConversation = [[self.updateNotification userInfo] objectForKey:@"ModifiedConversations"];
	if ([modifiedConversation containsIndex:self.conversation.conversationID]) {
		//		[self _setConversation:[self.conversation reloadedConversation] force:NO];
		self.updateNotification = nil;
	}
}

- (void)setAccount:(PSTMailAccount *)account {
	if (_conversationViewFlags.isObservingAccount) {
		[_account removeObserver:self forKeyPath:@"sending"];
		[_account removeObserver:self forKeyPath:@"savingDraft"];
		_conversationViewFlags.isObservingAccount = NO;
	}
	_account = account;
	if (account != nil && _conversationViewFlags.isObservingAccount) {
		[_account addObserver:self forKeyPath:@"sending" options:0 context:NULL];
		[_account addObserver:self forKeyPath:@"savingDraft" options:0 context:NULL];
		_conversationViewFlags.isObservingAccount = YES;
	}
}

- (void)setConversation:(PSTConversation *)conversation {
	_conversation = conversation;
	[self _updateConversationWebview];
}

- (void)_conversationLoaded {
//	[self.webView.windowScriptObject callWebScriptMethod:@"loadConversationView" withArguments:nil];
}

- (void)print:(id)sender {
	_printWebView = [[WebView alloc]initWithFrame:[NSPrintInfo.sharedPrintInfo imageablePageBounds] frameName:nil groupName:nil];
	[_printWebView setFrameLoadDelegate:self];
	NSString *htmlRendering = [self.conversation htmlRenderingWithAccount:self.account];
	[[self.printWebView mainFrame] loadHTMLString:htmlRendering baseURL:[NSURL fileURLWithPath:NSFileManager.defaultManager.resourcePath]];
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	if (self.webView == sender) {
		if (_conversationViewFlags.emptyLoad) {
			return;
		}
		[self.webView setHidden:NO];
		[self _conversationLoaded];
		if (resourceLoadCount == 0) {
			[self _resourceLoadFinished:self.printWebView];
		}
		if (_conversationViewFlags.hadFocus) {
			[self.webView.window makeFirstResponder:self.webView];
		}
	} else {
		if (self.printWebView != sender) {
			return;
		}
		_conversationViewFlags.frameLoaded = YES;
		if (printResourceLoadCount != 0) {
			return;
		} else {
			[self _resourceLoadFinished:self.printWebView];
		}
	}
}

- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource {
	if (self.webView == sender) {
		resourceLoadCount += 1;
	} else {
		printResourceLoadCount += 1;
	}
	return request.URL.description;
}

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource {
	NSString *path = nil;
	if ([identifier isKindOfClass:[NSURL class]]) {
		if ([(NSURL *) identifier isFileURL]) {
			path = [(NSURL *) identifier path];
			if ([path hasPrefix:NSFileManager.defaultManager.resourcePath]) {
				path = nil;
			}
		}
	}
	if (self.webView == sender) {
		resourceLoadCount -= 1;
	} else {
		printResourceLoadCount -= 1;
	}
	if (path != nil) {
		if (resourceLoadCount == 0 && _conversationViewFlags.frameLoaded) {
			if (self.printWebView == sender) {
				return;
			}
		}
	} else if (resourceLoadCount != 0) {
		return;
	}
	[self _resourceLoadFinished:sender];
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource {
	if (self.webView == sender) {
		resourceLoadCount -= 1;
		if (resourceLoadCount == 0) {
			[self _resourceLoadFinished:sender];
		}
	} else {
		printResourceLoadCount -= 1;
		if (printResourceLoadCount == 0) {
			[self _resourceLoadFinished:sender];
		}
	}
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
	if (request.URL.isFileURL) {
		[listener use];
		return;
	}
	[NSWorkspace.sharedWorkspace openURL:request.URL];
}

- (void)_resourceLoadFinished:(WebView *)webview {
	if (_conversationViewFlags.frameLoaded == NO) {
		return;
	}

	if (self.printWebView != webview) {
		return;
	}
	
	NSPrintInfo *printInfo = [NSPrintInfo.sharedPrintInfo copy];
	printInfo.horizontalPagination = NSFitPagination;
	printInfo.horizontallyCentered = NO;
	printInfo.verticallyCentered = NO;
	NSPrintOperation *operation = [_printWebView.mainFrame.frameView printOperationWithPrintInfo:printInfo];
	operation.showsPrintPanel = YES;
	[operation runOperation];
}

- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowScriptObject forFrame:(WebFrame *)frame {	
	if (_webView == webView || _printWebView == webView) {
		[windowScriptObject setValue:self forKey:@"WindowController"];
	}
}

@end

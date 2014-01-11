//
//  DMConversationWindowController.m
//  DotMail
//
//  Created by Robert Widmann on 9/21/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMConversationWindowController.h"
#import "DMConversationViewController.h"

@interface DMConversationWindowController () <NSWindowDelegate>

@property (nonatomic, strong) DMConversationViewController *viewController;
@property (nonatomic, copy) void(^onCloseBlock)(id token);

@end

@implementation DMConversationWindowController

- (id)initWithConversation:(PSTConversation *)conversation {
	self = [super init];
	
	NSUInteger windowMask = (NSTitledWindowMask  | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask);
	NSWindow *window = [[NSWindow alloc]initWithContentRect:(NSRect){ .size = { 620, 630 } } styleMask:windowMask backing:NSBackingStoreBuffered defer:NO];
	window.delegate = self;
	window.title = conversation.subject;
	_viewController = [[DMConversationViewController alloc]initWithFrame:(NSRect){ .size = { 620, 630 } }];
	_viewController.account = conversation.account;
	_viewController.conversation = conversation;
	[_viewController load];
	window.contentView = _viewController.view;
	[window center];
	self.window = window;
	
	return self;
}


- (void)setOnCloseBlock:(void(^)(id token))block {
	_onCloseBlock = block;
}

- (void)windowWillClose:(NSNotification *)notification {
	[self.viewController unload];
	if (self.onCloseBlock) {
		self.onCloseBlock(self);
	}
}

@end

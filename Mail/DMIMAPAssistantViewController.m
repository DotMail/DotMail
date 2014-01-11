//
//  DMCustomLoginViewController.m
//  DotMail
//
//  Created by Robert Widmann on 10/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMIMAPAssistantViewController.h"
#import "DMAccountSetupWindowController.h"
#import <QuartzCore/QuartzCore.h>
#import <MailCore/mailcore.h>
#import "DMColoredView.h"
#import "DMSecureTextField.h"
#import "DMLayeredImageView.h"
#import "DMPopUpButton.h"
#include <pthread.h>

static CGSize const DMWelcomeViewControllerSize = (CGSize){ 320, 500 };

@interface DMIMAPAssistantViewController () <TUITextFieldDelegate>

@end

@implementation DMIMAPAssistantViewController

- (instancetype)init {
	if (self = [super init]) {
		
	}
	return self;
}

- (NSString *)title {
	return @"IMAP Assistant";
}

- (CGSize)contentSize {
	return DMWelcomeViewControllerSize;
}

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ {0, 0}, { 600, 500 } }];
	view.backgroundColor = NSColor.whiteColor;
	
	DMLayeredImageView *iconImageView = [[DMLayeredImageView alloc]initWithFrame:(NSRect){ { 110, 380 } , { 100, 100 } }];
	iconImageView.imageAlignment = NSImageAlignCenter;
	iconImageView.image = [NSImage imageNamed:NSImageNameAdvanced];
	iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
	[view addSubview:iconImageView];
	
	DMPopUpButton *accountsPopupButton = [[DMPopUpButton alloc]initWithFrame:(NSRect){ { 20, 200 }, { 280, 36 } }];
	accountsPopupButton.autoresizingMask = NSViewMinYMargin | NSViewWidthSizable;
	accountsPopupButton.autoenablesItems = YES;
	[accountsPopupButton setBordered:YES];
	[accountsPopupButton setTransparent:NO];
	[accountsPopupButton addItemsWithTitles:@[ @"IMAP", @"POP" ]];
	[view addSubview:accountsPopupButton];
	[accountsPopupButton.rac_selectionSignal subscribeNext:^(NSPopUpButton *button) {
	}];

	self.view = view;
}

- (void)setInfo:(NSMutableDictionary *)info {
	[super setInfo:info];
	[self.serverNameField setText:[info objectForKey:@"imapHostname"]];
	[self.loginField setText:[info objectForKey:@"imapLogin"]];
	[self.passwordField setText:[info objectForKey:@"imapPassword"]];
}


@end

//
//  DMWelcomeViewController.m
//  DotMail
//
//  Created by Robert Widmann on 10/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMWelcomeViewController.h"
#import "DMLayeredImageView.h"
#import "DMColoredView.h"
#import "DMLabel.h"
#import "DMFlatButton.h"

static CGSize const DMWelcomeViewControllerSize = (CGSize){ 600, 300 };

@interface DMWelcomeViewController ()

@end

@implementation DMWelcomeViewController

- (id)init {
	self = [super init];
	
	
	return self;
}

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc] initWithFrame:(NSRect){ { 0, 0} , { 600, 300 } }];
	view.backgroundColor = NSColor.whiteColor;
	
	DMLabel *welcomeLabel = [[DMLabel alloc]initWithFrame:(NSRect){ { 20, 220 }, { 310, 30 } }];
	welcomeLabel.text = @"Welcome to DotMail";
	welcomeLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:26];
	welcomeLabel.textColor = [NSColor colorWithCalibratedRed:0.121 green:0.136 blue:0.135 alpha:1.000];
	[view addSubview:welcomeLabel];

	DMLabel *welcomeSchpeelLabel = [[DMLabel alloc]initWithFrame:(NSRect){ { 20, 20 }, { 310, 190 } }];
	welcomeSchpeelLabel.text = @"You'll be guided through the steps to set up your email accounts and some additional social services if you choose.";
	welcomeSchpeelLabel.wraps = YES;
	welcomeSchpeelLabel.font = [NSFont fontWithName:@"Helvetica" size:16];
	welcomeSchpeelLabel.textColor = [NSColor colorWithCalibratedWhite:0.546 alpha:1.000];
	[view addSubview:welcomeSchpeelLabel];
	
	DMLayeredImageView *iconImageView = [[DMLayeredImageView alloc]initWithFrame:(NSRect){ { 350, 50 } , { 230, 230 } }];
	iconImageView.image = [NSImage imageNamed:@"DotMailIcns.icns"];
	iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
	[view addSubview:iconImageView];
	
	DMFlatButton *startButton = [[DMFlatButton alloc]initWithFrame:(NSRect){ { 20, 80 }, { 250, 40 } }];
	startButton.buttonType = NSMomentaryPushInButton;
	startButton.bordered = NO;
	startButton.tag = DMAssistantPaneBasicAssistant;
	startButton.target = [DMAccountSetupWindowController standardAccountSetupWindowController];
	startButton.action = @selector(switchView:);
	startButton.title = @"LET'S DO THIS!";
	startButton.verticalPadding = 12;
	startButton.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:13];
	startButton.backgroundColor = [NSColor colorWithCalibratedRed:0.871 green:0.000 blue:0.079 alpha:1.000];
	[view addSubview:startButton];
	
	self.view = view;
}

- (CGSize)contentSize {
	return DMWelcomeViewControllerSize;
}

@end

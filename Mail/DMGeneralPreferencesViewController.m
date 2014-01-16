//
//  DMGeneralPreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMGeneralPreferencesViewController.h"
#import "DMColoredView.h"


#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

static CGSize const kPreferencePaneContentSize = (CGSize){ 500, 300 };

@interface DMGeneralPreferencesViewController ()

@end

@implementation DMGeneralPreferencesViewController

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	
	CATextLayer *notificationsBlockLabel = [CATextLayer layer];
	notificationsBlockLabel.foregroundColor = [NSColor colorWithCalibratedRed:0.388 green:0.407 blue:0.415 alpha:1.000].CGColor;
	notificationsBlockLabel.frame = (NSRect){ .origin.x = 32, .origin.y = kPreferencePaneContentSize.height - 100, .size = { 200, 18 } };
	notificationsBlockLabel.wrapped = NO;
	CTFontRef font = CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Medium", 13.f, NULL);
	notificationsBlockLabel.font = font;
	notificationsBlockLabel.fontSize = 12.f;
	notificationsBlockLabel.string = @"Notifications";
	[view.layer addSublayer:notificationsBlockLabel];
	
	NSButton *useNotificationsButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 120, .origin.y = kPreferencePaneContentSize.height - 100, .size = { 300, 18 } }];
	[useNotificationsButton setTarget:self];
	[useNotificationsButton setAction:@selector(toggleDefaultMailReader:)];
	useNotificationsButton.state = PSTLaunchServicesManager.defaultManager.isCurrentApplicationRegisteredAsDefaultHandlerForEmail;
	useNotificationsButton.buttonType = NSSwitchButton;
	useNotificationsButton.bezelStyle = NSRegularSquareBezelStyle;
	useNotificationsButton.title = @"Use notifications";
	NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:useNotificationsButton.attributedTitle];
	[colorTitle addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0, colorTitle.length)];
	[useNotificationsButton setAttributedTitle:colorTitle];
	[view addSubview:useNotificationsButton];
	
	CATextLayer *systemBlockLabel = [CATextLayer layer];
	systemBlockLabel.foregroundColor = [NSColor colorWithCalibratedRed:0.388 green:0.407 blue:0.415 alpha:1.000].CGColor;
	systemBlockLabel.frame = (NSRect){ .origin.x = 60, .origin.y = kPreferencePaneContentSize.height - 150, .size = { 200, 18 } };
	systemBlockLabel.wrapped = NO;
	systemBlockLabel.font = font;
	systemBlockLabel.fontSize = 12.f;
	systemBlockLabel.string = @"System";
	[view.layer addSublayer:systemBlockLabel];
	
	NSButton *defaultMailReaderCheck = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 120, .origin.y = kPreferencePaneContentSize.height - 150, .size = { 300, 18 } }];
	[defaultMailReaderCheck setTarget:self];
	[defaultMailReaderCheck setAction:@selector(toggleDefaultMailReader:)];
	defaultMailReaderCheck.state = PSTLaunchServicesManager.defaultManager.isCurrentApplicationRegisteredAsDefaultHandlerForEmail;
	defaultMailReaderCheck.buttonType = NSSwitchButton;
	defaultMailReaderCheck.bezelStyle = NSRegularSquareBezelStyle;
	defaultMailReaderCheck.title = @"Make DotMail the default mail reader";
	colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:defaultMailReaderCheck.attributedTitle];
	[colorTitle addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0, colorTitle.length)];
	[defaultMailReaderCheck setAttributedTitle:colorTitle];
	[view addSubview:defaultMailReaderCheck];
	
	NSButton *startupItemToggle = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = 120, .origin.y = kPreferencePaneContentSize.height - 180, .size = { 300, 18 } }];
	[startupItemToggle setTarget:self];
	[startupItemToggle setAction:@selector(toggleStartupItem:)];
	startupItemToggle.state = [NSUserDefaults.standardUserDefaults boolForKey:@"PSTLaunchAtLoginEnabled"];
	startupItemToggle.buttonType = NSSwitchButton;
	startupItemToggle.bezelStyle = NSRegularSquareBezelStyle;
	startupItemToggle.title = @"Start DotMail at Login";
	colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:startupItemToggle.attributedTitle];
	[colorTitle addAttribute:NSForegroundColorAttributeName value:NSColor.whiteColor range:NSMakeRange(0, colorTitle.length)];
	[startupItemToggle setAttributedTitle:colorTitle];
	[view addSubview:startupItemToggle];
	
	self.view = view;
	CFRelease(font);
	
	[[NSUserDefaults.standardUserDefaults rac_valuesForKeyPath:@"PSTLaunchAtLoginEnabled" observer:self]subscribeNext:^(NSNumber *launchAtLogin) {
		if (launchAtLogin.boolValue) {
			[PSTLaunchServicesManager.defaultManager insertCurrentApplicationInStartupItems:NO];
		} else {
			[PSTLaunchServicesManager.defaultManager removeCurrentApplicationFromStartupItems];
		}
	}];
}

- (void)toggleStartupItem:(NSButton *)sender {
	[NSUserDefaults.standardUserDefaults setBool:(BOOL)sender.state forKey:@"PSTLaunchAtLoginEnabled"];
}

- (void)toggleDefaultMailReader:(NSButton *)sender {
	[PSTLaunchServicesManager.defaultManager toggleCurrentApplicationAsDefaultHandlerForEmail];
}

- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"General";
}

@end

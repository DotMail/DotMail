//
//  DMStatusBarManager.m
//  DotMail
//
//  Created by Robert Widmann on 12/22/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMStatusBarManager.h"


@interface DMStatusBarManager ()

@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation DMStatusBarManager

+ (instancetype)defaultManager {
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (instancetype)init {
	self = [super init];
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_countUpdated:) name:PSTMailAccountCountUpdated object:nil];
	[PSTAccountManager.defaultManager addObserver:self forKeyPath:@"accounts" options:0 context:NULL];
	[self _changeMenubarIconState];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self _countUpdated:NSApp];
}

- (void)_changeMenubarIconState {
	BOOL showStatusItem = [[NSUserDefaults standardUserDefaults]boolForKey:@"DMDisplayStatusItem"];
	if (showStatusItem) {
		self.statusItem = [[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
	}
	[self.statusItem setImage:[NSImage imageNamed:@"DMStatusBarIcon"]];
	[self.statusItem setAlternateImage:[NSImage imageNamed:@"DMStatusBarIcon_Highlighted"]];
	[self.statusItem setTitle:nil];
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setTarget:self];
	[self.statusItem setAction:@selector(statusBarClicked)];
	[self _countUpdated:NSApp];
}

- (void)_countUpdated:(id)sender {
	NSUInteger count = 0;
	for (PSTMailAccount *account in PSTAccountManager.defaultManager.accounts) {
		if ([account notificationsEnabled]) {
			count += [account unreadCountForFolder:PSTFolderTypeInbox];
		}
	}
	
	if (count == 0) {
		[self.statusItem setImage:[NSImage imageNamed:@"DMStatusBarIcon"]];
		[[NSApp dockTile] setBadgeLabel:nil];
		[[NSApp dockTile] display];
	} else {
		[self.statusItem setImage:[NSImage imageNamed:@"DMStatusBarIcon_Unread"]];
		[self.statusItem setTitle:[NSString stringWithFormat:@"%lu", count]];
		[[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%lu", count]];
		[[NSApp dockTile] display];
	}
}

- (void)statusBarClicked {
	[NSApplication.sharedApplication activateIgnoringOtherApps:YES];
	if ([NSApp mainWindow].isMiniaturized) {
		[[NSApp mainWindow] deminiaturize:self];
	}
	[[NSApp mainWindow] makeKeyAndOrderFront:self];
}

@end

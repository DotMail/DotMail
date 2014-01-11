//
//  CFIAppDelegate.m
//  DotMail
//
//  Created by Robert Widmann on 7/10/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAppDelegate.h"
#import "DMMainWindowController.h"
#import "DMConversationListController.h"
#import "DMComposeWindowController.h"
#import "DMAboutWindowController.h"
#import "DMStatusBarManager.h"
#import "PFMoveApplication.h"
#import "DMMainWindow.h"
#import "DMAccountSetupWindowController.h"
#import <MoonShine/MoonShine.h>
#import "DMPreferencesWindowController.h"

@implementation DMAppDelegate

#pragma mark - Lifecycle

+ (void)load {
	[NSUserDefaults.standardUserDefaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Defaults" ofType:@"plist"]]];
}

- (instancetype)init {
	self = [super init];
	
	DMDeployUpdateTokenIfNecessary();
	
	[MSHUpdater.standardUpdater beginAutomaticUpdateChecksAtInterval:300];
	[MCOMailProvidersManager sharedManager];
	[[PSTAccountManager defaultManager]initializeAccounts];
	[PSTAccountControllerManager defaultManager];
	[[PSTAddressBookManager sharedManager] initializeAddressBook];
	[DMStatusBarManager defaultManager];
	[QLPreviewPanel sharedPreviewPanel];
	
	self.mainWindowController = [[DMMainWindowController alloc]init];
	self.accountSetupWindowController = [DMAccountSetupWindowController standardAccountSetupWindowController];
	
	[NSApp setNextResponder:self.mainWindowController];
	[[QLPreviewPanel sharedPreviewPanel] updateController];

	return self;
}

- (void)awakeFromNib {
	[[RACObserve(PSTAccountManager.defaultManager,accounts) map:^id(NSArray *value) {
		return @(value.count != 0);
	}] subscribeNext:^(NSNumber *value) {
		if (value.boolValue) {
			[self._dmPreferencesButton setAction:@selector(showPreferences:)];			
			[self._dmComposeMessageMenuItem setAction:@selector(composeMessage:)];
			[self._dmReplyMenuItem setAction:@selector(replyMessage:)];
			[self._dmReplyAllMenuItem setAction:@selector(replyAllMessage:)];
		} else {
			[self._dmPreferencesButton setAction:NULL];
			[self._dmComposeMessageMenuItem setAction:NULL];
			[self._dmReplyMenuItem setAction:NULL];
			[self._dmReplyAllMenuItem setAction:NULL];
		}
	}];
	
	[self._dmUpdatesMenuItem setTarget:MSHUpdater.standardUpdater];
	[self._dmUpdatesMenuItem setAction:@selector(checkForUpdates)];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	return [self.mainWindowController validateMenuItem:menuItem];
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - NSApplicationDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	// Call this before any interface is shown to prevent confusion
	// and hopefully move DM to the main applications folder.
	if (getenv("DOTMAIL_TEST") == NULL) {
		CFICheckForOtherRunningInstancesOfCurrentApplication();
		PFMoveToApplicationsFolderIfNecessary();
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	if (PSTAccountManager.defaultManager.accounts.count != 0) {
		[self.mainWindowController setup];
		[self.mainWindowController showWindow:NSApp];
	} else {
		//there are no accounts, initialize the setup controller
		[self.accountSetupWindowController.window makeKeyAndOrderFront:self];
		[self.mainWindowController setup];
	}
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
	if (self.mainWindowController.window.isVisible) return NO;
	if (self.mainWindowController.window.isMiniaturized) {
		[self.mainWindowController.window deminiaturize:NSApp];
	}
	
	if (PSTAccountManager.defaultManager.accounts.count != 0) {
		[self.mainWindowController showWindow:NSApp];
	} else {
		//there are no accounts, initialize the setup controller
		[self.accountSetupWindowController showWindow:NSApp];
	}
	
	return NO;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
	[self.mainWindowController composeWithFilenames:@[filename]];
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
	[self.mainWindowController composeWithFilenames:filenames];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	if ([MSHUpdater.standardUpdater installUpdateIfNeeded]) {
		return NSTerminateLater;
	}
	return NSTerminateNow;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[PSTAvatarImageManager.defaultManager close];

	CFDictionaryRef rectDictionary = CGRectCreateDictionaryRepresentation(self.mainWindowController.window.frame);
	[NSUserDefaults.standardUserDefaults setObject:(__bridge NSDictionary*)rectDictionary forKey:PSTMainWindowAutosavedFrameKey];
	[NSUserDefaults.standardUserDefaults setBool:((self.mainWindowController.window.styleMask & NSFullScreenWindowMask) == NSFullScreenWindowMask) forKey:PSTMainWindowAutosavedFullscreenStateKey];
	[NSUserDefaults.standardUserDefaults synchronize];
	[self.mainWindowController unload];
	
	for (NSWindow *window in [NSApplication.sharedApplication orderedWindows]) {
		[window close];
	}
	
	for (PSTMailAccount *account in [PSTAccountManager.defaultManager accounts]) {
		[account save];
	}
	for (PSTMailAccount *account in [PSTAccountManager.defaultManager accounts]) {
		[account waitUntilAllOperationsHaveFinished];
	}
	[NSUserDefaults.standardUserDefaults synchronize];
	CFRelease(rectDictionary);
}

#pragma mark - Actions

- (IBAction)showAboutPanel:(id)sender {
	[self.aboutWindowController.window center];
	[self.aboutWindowController.window makeKeyAndOrderFront:NSApp];
}

- (DMAboutWindowController *)aboutWindowController {
	if (!_aboutWindowController) {
		_aboutWindowController = [[DMAboutWindowController alloc] initWithWindowNibName:@"DMAboutWindow"];
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeAboutPanel) name:NSWindowDidResignKeyNotification object:_aboutWindowController.window];
	}
	return _aboutWindowController;
}

- (void)closeAboutPanel {
	[self.aboutWindowController.window performClose:NSApp];
}


- (NSString *)bundleVersionNumber {
	return NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
}

- (NSString *)shortVersionNumber {
	return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString *)versionColloquialName {
	return @"Nights in White Satin";
}

- (void)showPreferences:(id)sender {
	[(NSWindow *)[DMPreferencesWindowController.standardPreferencesWindowController window] center];
	[(NSWindow *)[DMPreferencesWindowController.standardPreferencesWindowController window] makeKeyAndOrderFront:NSApp];
}

- (IBAction)print:(id)sender {
	[self.mainWindowController print:sender];
}

- (IBAction)replyMessage:(id)sender {
	[self.mainWindowController replyMessage:sender];
}

- (IBAction)replyAllMessage:(id)sender {
	[self.mainWindowController replyAllMessage:sender];
}

- (IBAction)composeMessage:(id)sender {
	[self.mainWindowController composeMessage:sender];
}

- (IBAction)dotMailTwitter:(id)sender {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://twitter.com/dotmailapp"]];
}

- (IBAction)aboutVanSchneider:(id)sender {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"http://www.vanschneider.com/about-me/"]];
}

- (IBAction)aboutCodaFi:(id)sender {
	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.github.com/codafi"]];
}

- (IBAction)selectPreviousAccount:(id)sender {
	[self.mainWindowController selectPreviousAccount:sender];
}

- (IBAction)selectNextAccount:(id)sender {
	[self.mainWindowController selectNextAccount:sender];
}

- (IBAction)selectInbox:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeInbox];
}

- (IBAction)selectNextSteps:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeNextSteps];

}

- (IBAction)selectFavourites:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeStarred];

}

- (IBAction)selectDrafts:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeDrafts];

}

- (IBAction)selectSent:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeSent];

}

- (IBAction)selectTrash:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeTrash];

}

- (IBAction)selectLabels:(id)sender {
	[self.mainWindowController selectMailbox:PSTFolderTypeLabel];

}


#pragma mark - QLPreviewPanel Support

- (void)togglePreviewPanel:(id)previewPanel {
	if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
		[[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
	} else {
		[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
	}
}


#pragma mark - Private

static void DMDeployUpdateTokenIfNecessary(void) {
	NSString *tokenPath = [[NSString stringWithFormat:@"~/Library/Application Support/DotMail/%@.dotmailtoken", NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]] stringByExpandingTildeInPath];
	if (![NSFileManager.defaultManager fileExistsAtPath:tokenPath]) {
		[[NSFileManager defaultManager]removeItemAtPath:[@"~/Library/Application Support/DotMail" stringByExpandingTildeInPath] error:nil];
		[[NSFileManager defaultManager]createDirectoryAtPath:[@"~/Library/Application Support/DotMail" stringByExpandingTildeInPath] withIntermediateDirectories:YES attributes:nil error:nil];
		NSData *token = [@"Better avoid that construction site." dataUsingEncoding:NSUTF8StringEncoding];
		[token writeToFile:tokenPath atomically:YES];
	}
}

static NSMachPort *existancePort = nil;

/**
 * Used by the CFICheckForOtherRunningInstancesOfCurrentApplication() function to
 * create a unique NSMachPort object.  This string *CANNOT CHANGE* in the future,
 * otherwise conflicting versions of an App will run on the same machine and
 * defeat the purpose of this function.
 */
static NSString *const CFIPortNameConstant = @"DotMailApp-Port";

/**
 * Attempts to find out whether the same port has been registered twice with
 * the Mach Bootstrap server.  If so, a message is presented and the other
 * instance of the app will terminate.
 */
static void CFICheckForOtherRunningInstancesOfCurrentApplication() {
	if (existancePort == nil) {
		existancePort = [[NSMachPort alloc] init];
	}
	BOOL noOtherInstance = [[NSMachBootstrapServer sharedInstance]registerPort:existancePort name:CFIPortNameConstant];
	if (noOtherInstance) return;
	
	NSString *applicationName = NSBundle.mainBundle.infoDictionary[@"CFBundleName"];
	NSString *alertText = [NSString stringWithFormat:@"Another instance of %@ is already running!", applicationName];
	NSString *alertInformativeText = [NSString stringWithFormat:@"Please quit the other instance of %@", applicationName];
	//The `%@, String` redundancy courtesy the Apple engineer who thought that was a good idea at the time.
	NSAlert *instanceAlert = [NSAlert alertWithMessageText:alertText defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", alertInformativeText];
	[instanceAlert runModal];
	[existancePort invalidate];
	[NSRunningApplication.currentApplication terminate];
}

@end

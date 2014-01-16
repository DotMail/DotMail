//
//  DMAccountSetupWindowController.m
//  DotMail
//
//  Created by Robert Widmann on 9/8/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAccountSetupWindowController.h"
#import "DMAccountSetupWindow.h"
#import "DMWelcomeViewController.h"
#import "DMBasicAssistantViewController.h"
#import "DMIMAPAssistantViewController.h"
#import "DMAppDelegate.h"

#define AnimationDuration 0.3

@interface DMAccountSetupWindowController ()
@property (nonatomic, strong) NSMutableOrderedSet *preferencePanes;
@property (nonatomic) NSUInteger visiblePaneIndex;
@property (nonatomic) BOOL isModal;
@end

@implementation DMAccountSetupWindowController

+ (instancetype)standardAccountSetupWindowController {
	static DMAccountSetupWindowController *instance;
	if (instance == nil) {
		instance = [[DMAccountSetupWindowController alloc]init];
		[instance buildUI];
	}
	return instance;
}

+ (instancetype)modalAccountSetupWindowController {
	static DMAccountSetupWindowController *instance;
	if (instance == nil) {
		instance = [[DMAccountSetupWindowController alloc]init];
		[instance buidlModalUI];
		instance.isModal = YES;
	}
	[instance resetAllPanes];
	return instance;
}

- (id)init {
	self = [super init];

	_preferencePanes = [NSMutableOrderedSet orderedSet];
	self.window = [[DMAccountSetupWindow alloc]init];
	
	return self;
}

- (void)showWindow:(id)sender {
	[super showWindow:sender];
}

- (void)buildUI {
	DMWelcomeViewController *welcomeViewController = [[DMWelcomeViewController alloc]init];
	DMBasicAssistantViewController *basicAssistantViewController = [[DMBasicAssistantViewController alloc]init];
	DMIMAPAssistantViewController *customIMAPAssistantViewController = [[DMIMAPAssistantViewController alloc]init];
	
	[self insertAssistantPane:welcomeViewController];
	[self insertAssistantPane:basicAssistantViewController];
	[self insertAssistantPane:customIMAPAssistantViewController];
}

- (void)buidlModalUI {
	DMBasicAssistantViewController *basicAssistantViewController = [[DMBasicAssistantViewController alloc] initInModalSheet];
	DMIMAPAssistantViewController *customIMAPAssistantViewController = [[DMIMAPAssistantViewController alloc]init];

	[self insertAssistantPane:basicAssistantViewController];
	[self insertAssistantPane:customIMAPAssistantViewController];
}

- (void)resetAllPanes {
	for (DMAssistantViewController *viewController in self.preferencePanes) {
		[viewController resetUI];
	}
}

- (void)insertAssistantPane:(DMAssistantViewController *)preferencePane {
	NSParameterAssert(preferencePane != nil);

	[self.preferencePanes addObject:preferencePane];
	
	if (self.preferencePanes.count == 1) {
		self.visiblePaneIndex = 0;
		[self.window setContentSize:preferencePane.contentSize];
		[self.window.contentView addSubview:preferencePane.view];
	}
}

- (DMAssistantViewController *)selectedPreferencePane {
	NSUInteger selected = [self visiblePaneIndex];
	return selected < [self.preferencePanes count] ? [[self preferencePanes] objectAtIndex:selected] : nil;
}

- (void)switchView:(id)sender {
	[self switchView:sender animate:YES];
}

- (void)switchView:(id)sender animate:(BOOL)animateFlag {
	NSInteger selectedTab;
	
	if([sender isKindOfClass:[NSButton class]])
		selectedTab = [sender tag];
	else if([sender isKindOfClass:[NSNumber class]])
		selectedTab = [sender integerValue];
	else return;
	
	DMAssistantViewController *currentPane = [self selectedPreferencePane];
	DMAssistantViewController *nextPane    = [[self preferencePanes] objectAtIndex:selectedTab];
	
	if(currentPane == nextPane) return;
	
	NSSize viewSize = [nextPane contentSize];
	NSView *view = [nextPane view];
		
	[self showView:view atSize:viewSize animate:animateFlag];
	
	[self setVisiblePaneIndex:selectedTab];
	
	[[self window] makeFirstResponder:[nextPane view]];
}

- (void)showView:(NSView *)view atSize:(NSSize)size animate:(BOOL)animateFlag {
	NSWindow *win = [self window];
	
	if(view == [win contentView]) return;
	
	NSRect contentRect = [win contentRectForFrameRect:[win frame]];
	contentRect.size = size;
	NSRect frameRect = [win frameRectForContentRect:contentRect];
	frameRect.origin.y += win.frame.size.height - frameRect.size.height;
	frameRect.origin.x += (win.frame.size.width/2) - (frameRect.size.width/2);
	[view setFrameSize:size];
	
	CAAnimation *anim = [win animationForKey:@"frame"];
	anim.duration = AnimationDuration;
	[win setAnimations:[NSDictionary dictionaryWithObject:anim forKey:@"frame"]];
	
	[CATransaction begin];
	
	id target = [win contentView];
	if(animateFlag) target = [target animator];
	
	if([[[win contentView] subviews] count] >= 1)
		[target replaceSubview:[[[win contentView] subviews] lastObject] with:view];
	else
		[target addSubview:view];
	
	[animateFlag ? [win animator] : win setFrame:frameRect display:YES];
	
	[CATransaction commit];
}

- (void)flagsChanged:(NSEvent *)theEvent {
	[self.selectedPreferencePane flagsChanged:theEvent];
	[super flagsChanged:theEvent];
}

#pragma mark - Modal Window

- (void)beginSheetModalForWindow:(NSWindow *)window {
	[NSApp beginSheet:self.window modalForWindow:window modalDelegate: self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo { }

#pragma mark - DMAccountSetupDelegate

- (void)finishCreatingAccount:(DMAssistantViewController *)sender {
	[self _finishedWithInfo:sender.info];
}

- (void)_finishedWithInfo:(NSDictionary *)info {
	if ([info objectForKey:@"PSTPOPService"]) {
		[self _createPOPAccountWithInfo:info];
	} else {
		[self _createIMAPAccountWithInfo:info];
	}
	
	[[(NSWindowController *)[(DMAppDelegate *)[NSApp delegate] mainWindowController] window]setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
	[(NSWindowController *)[(DMAppDelegate *)[NSApp delegate] mainWindowController] showWindow:NSApp];
	[[(NSWindowController *)[(DMAppDelegate *)[NSApp delegate] mainWindowController] window]setAnimationBehavior:NSWindowAnimationBehaviorNone];
	
	if (self.isModal) {
		[NSApp endSheet:self.window returnCode:NSCancelButton];
		[self.window orderOut:nil];
	} else {
		[NSApp endSheet:self.window];
		[self close];
	}
}

- (void)_createPOPAccountWithInfo:(NSDictionary *)info {
	[FXKeychain.defaultKeychain setObject:[info objectForKey:@"Password"] forKey:[info objectForKey:@"Email"]];
	PSTMailAccount *newAccount = [[PSTMailAccount alloc] initWithDictionary:info];
	if (![PSTAccountManager.defaultManager addAccount:newAccount]) return;
	if (newAccount.name.length == 0) {
		if (newAccount.email.length != 0) {
			[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div>%@</div>%@", [newAccount email], [PSTMailAccount defaultHTMLSignatureSuffix]]];
		}
		[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div></div>%@", [PSTMailAccount defaultHTMLSignatureSuffix]]];
	}
	[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div>%@</div>%@", [newAccount name], [PSTMailAccount defaultHTMLSignatureSuffix]]];
	[newAccount sync];
}

- (void)_createIMAPAccountWithInfo:(NSDictionary *)info {
	[FXKeychain.defaultKeychain setObject:[info objectForKey:@"PSTPassword"] forKey:[info objectForKey:@"PSTEmail"]];
	PSTMailAccount *newAccount = [[PSTMailAccount alloc] initWithDictionary:info];
	if (newAccount.name.length == 0) {
		if (newAccount.email.length != 0) {
			[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div>%@</div>%@", [newAccount email], [PSTMailAccount defaultHTMLSignatureSuffix]]];
		}
		[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div></div>%@", [PSTMailAccount defaultHTMLSignatureSuffix]]];
	}
	[newAccount setHtmlSignature:[NSString stringWithFormat:@"<div>--&nbsp;</div></div><div>%@</div>%@", [newAccount name], [PSTMailAccount defaultHTMLSignatureSuffix]]];
	[PSTAccountManager.defaultManager addAccount:newAccount];
	[newAccount sync];
}

@end

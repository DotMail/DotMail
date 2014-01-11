//
//  DMPreferencesWindowController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DMPreferencesWindowController.h"
#import "DMPreferencesWindow.h"
#import "DMPreferencesButton.h"

#import "DMGeneralPreferencesViewController.h"
#import "DMAccountsPreferencesViewController.h"
#import "DMSignaturePreferencesViewController.h"
#import "DMOrganizePreferencesViewController.h"
#import "DMAliasesPreferencesViewController.h"
#import "DMAdvancedPreferencesViewController.h"
#import "DMCloudPreferencesViewController.h"

#define AnimationDuration 0.3

@interface DMPreferencesWindowController ()
@property (nonatomic, strong) NSMutableOrderedSet *preferencePanes;
@property (nonatomic, strong) NSMutableOrderedSet *toolbarItems;
@property (nonatomic) NSUInteger visiblePaneIndex;
@end

@implementation DMPreferencesWindowController

+ (instancetype)standardPreferencesWindowController {
	static DMPreferencesWindowController *instance = nil;
	if (instance == nil) {
		instance = [[DMPreferencesWindowController alloc]init];
	}
	return instance;
}

- (DMPreferencesWindow *)window {
	return (DMPreferencesWindow *)[super window];
}

- (instancetype)init {
	self = [super init];
	
	_preferencePanes = [NSMutableOrderedSet orderedSet];
	_toolbarItems = [NSMutableOrderedSet orderedSet];
	NSUInteger windowMask = (NSTitledWindowMask | NSClosableWindowMask);
	self.window = [[DMPreferencesWindow alloc]initWithContentRect:(NSRect){ .size = { 500, 230 } } styleMask:windowMask backing:NSBackingStoreBuffered defer:YES];
	
	[self buildPreferencePanes];
	
	return self;
}

- (void)insertPreferencePane:(DMPreferencesViewController *)preferencePane {
	NSParameterAssert(preferencePane != nil);
	
	DMPreferencesButton *toolbarItem = [[DMPreferencesButton alloc]initWithFrame:(NSRect){ .size = { 68, 44 } }];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(switchView:)];
	toolbarItem.title = preferencePane.title;
	toolbarItem.tag = self.preferencePanes.count;
	[self.toolbarItems addObject:toolbarItem];
	[self.window addButtonToTitleBar:toolbarItem atXPosition:(self.preferencePanes.count * 65) + 20];
	
	[self.preferencePanes addObject:preferencePane];
	
	if (self.preferencePanes.count == 1) {
		self.visiblePaneIndex = 0;
		[toolbarItem setSelectedPreferenceButton:YES];
		[self.window setContentSize:preferencePane.contentSize];
		[self.window.contentView addSubview:preferencePane.view];
	}
}

- (void)buildPreferencePanes {
	DMGeneralPreferencesViewController *generalPane = [[DMGeneralPreferencesViewController alloc]init];
	DMAccountsPreferencesViewController *accountsPane = [[DMAccountsPreferencesViewController alloc]init];
	DMSignaturePreferencesViewController *signaturePane = [[DMSignaturePreferencesViewController alloc]init];
	DMOrganizePreferencesViewController *organizePane = [[DMOrganizePreferencesViewController alloc]init];
	DMAliasesPreferencesViewController *aliasesPane = [[DMAliasesPreferencesViewController alloc]init];
	DMCloudPreferencesViewController *cloudPane = [[DMCloudPreferencesViewController alloc]init];
	DMAdvancedPreferencesViewController *advancedPane = [[DMAdvancedPreferencesViewController alloc]init];

	[self insertPreferencePane:generalPane];
	[self insertPreferencePane:accountsPane];
	[self insertPreferencePane:signaturePane];
	[self insertPreferencePane:organizePane];
	[self insertPreferencePane:aliasesPane];
	[self insertPreferencePane:cloudPane];
	[self insertPreferencePane:advancedPane];
}

- (DMPreferencesViewController *)selectedPreferencePane {
	NSUInteger selected = [self visiblePaneIndex];
	return selected < [self.preferencePanes count] ? [[self preferencePanes] objectAtIndex:selected] : nil;
}

- (void)switchView:(id)sender {
	NSInteger selectedTab;
	
	if([sender isKindOfClass:[DMPreferencesButton class]])
		selectedTab = [sender tag];
	else if([sender isKindOfClass:[NSNumber class]])
		selectedTab = [sender integerValue];
	else return;
	
	DMPreferencesViewController *currentPane = [self selectedPreferencePane];
	DMPreferencesViewController *nextPane    = [[self preferencePanes] objectAtIndex:selectedTab];
	
	if(currentPane == nextPane) return;
	
	NSSize viewSize = [nextPane contentSize];
	NSView *view = [nextPane view];
	
	[[self window] setBaselineSeparatorColor:[NSColor blackColor]];
	
	[self showView:view atSize:viewSize];

	[self setVisiblePaneIndex:selectedTab];
	
	[[self window] makeFirstResponder:[nextPane view]];
}

- (void)showView:(NSView *)view atSize:(NSSize)size {
	NSWindow *window = [self window];
	
	if(view == window.contentView) return;
	
	NSRect contentRect = [window contentRectForFrameRect:[window frame]];
	contentRect.size = size;
	NSRect frameRect = [window frameRectForContentRect:contentRect];
	frameRect.origin.y += window.frame.size.height - frameRect.size.height;
	
	[view setFrameSize:size];
	
	CAAnimation *anim = [window animationForKey:@"frame"];
	anim.duration = AnimationDuration;
	[window setAnimations:[NSDictionary dictionaryWithObject:anim forKey:@"frame"]];
	
	[CATransaction begin];
	
	id target = [[window contentView] animator];
	if([[[window contentView] subviews] count] >= 1) {
		[target replaceSubview:[window.contentView subviews].lastObject with:view];
	} else {
		[target addSubview:view];
	}
	[window.animator setFrame:frameRect display:YES];
	
	[CATransaction commit];
}

- (void)setVisiblePaneIndex:(NSUInteger)visiblePaneIndex {
	[[self.toolbarItems objectAtIndex:_visiblePaneIndex]setSelectedPreferenceButton:NO];
	_visiblePaneIndex = visiblePaneIndex;
	[[self.toolbarItems objectAtIndex:_visiblePaneIndex]setSelectedPreferenceButton:YES];
}



@end

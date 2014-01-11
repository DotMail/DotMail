//
//  DMMainWindow.m
//  DotMail
//
//  Created by Robert Widmann on 9/2/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMMainWindow.h"
#import "DMMainWindowController.h"
#import "DMWindowErrorBanner.h"
#import "DMMainViewController.h"


@interface DMMainWindow ()

@property (nonatomic, strong) DMWindowErrorBanner *errorBanner;

@end

@implementation DMMainWindow {
	BOOL showingError;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	[self.contentView setWantsLayer:YES];
	[self setMinSize:NSMakeSize(937, 332)];
	self.titleBarHeight = 38.0;
	self.fullScreenButtonRightMargin = 12.0f;
	self.centerFullScreenButton = YES;
	self.trafficLightButtonsLeftMargin = 12.0f;
	self.centerTrafficLightButtons = YES;
	self.adjustsToolbarInFullscreen = YES;
	self.baselineSeparatorColor = [NSColor colorWithCalibratedWhite:0.300 alpha:1.000];

	_errorBanner = [[DMWindowErrorBanner alloc]initWithFrame:(NSRect){ .origin.y = NSHeight([[self contentView] frame]), .size.width = NSWidth(contentRect), .size.height = 22}];
	_errorBanner.autoresizingMask = (NSViewWidthSizable | NSViewMaxYMargin);
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_reachabilityHasChanged) name:NPReachabilityChangedNotification object:NPReachability.sharedInstance];
	[self performSelector:@selector(_reachabilityHasChanged) withObject:nil afterDelay:0.2];
	
	self.viewController = [[DMMainViewController alloc]initWithContentRect:[self.contentView frame]];
	[self.contentView addSubview:self.viewController.view];
	
	return self;
}

- (void)addButtonToTitleBar:(NSView *)viewToAdd atXPosition:(CGFloat)x {
	viewToAdd.frame = NSMakeRect(x, 0, viewToAdd.frame.size.width, [self heightOfTitleBar]);
	
	NSUInteger mask = NSViewMinYMargin;
	mask |= (x > self.frame.size.width / 2.0) ? NSViewMinXMargin : NSViewMaxXMargin;
	[viewToAdd setAutoresizingMask:mask];
	
	[self.titleBarView addSubview:viewToAdd];
}

- (CGFloat)heightOfTitleBar {
	NSRect outerFrame = [[self.contentView superview] frame];
	NSRect innerFrame = [self.contentView frame];
	
	return outerFrame.size.height - innerFrame.size.height;
}

- (void)addUpdatesViewToTitleBar:(NSView *)viewToAdd {
	CGFloat x = [[self contentView]frame].size.width/2;
	viewToAdd.frame = NSMakeRect(x - NSWidth(viewToAdd.frame), ([self heightOfTitleBar]/3), viewToAdd.frame.size.width, NSHeight(viewToAdd.frame));
	
	[viewToAdd setAutoresizingMask:(NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin)];
	
	[self.titleBarView addSubview:viewToAdd];
}


- (void)_postWindowWillGoIntoFullScreenNotification {
	
}

- (void)_postWindowDidGoIntoFullScreenNotification {
	
}

- (NSWindowCollectionBehavior)collectionBehavior {
	return (NSWindowCollectionBehaviorManaged | NSWindowCollectionBehaviorParticipatesInCycle | NSWindowCollectionBehaviorFullScreenPrimary);
}

- (void)presentError:(NSError *)error contextInfo:(void *)contextInfo {
	[self.errorBanner setError:error];
	if (!showingError) {
		[self.contentView addSubview:_errorBanner];
		[[_errorBanner animator]setFrame:(NSRect){ .origin.x = 25, .origin.y = 20, .size.width = NSWidth([self.contentView frame]) - 50, .size.height = 22}];
		showingError = YES;
	}
}

- (void)_reachabilityHasChanged {
	if (NPReachability.sharedInstance.isCurrentlyReachable) {
		[[_errorBanner animator]setFrame:(NSRect){ .origin.x = 25, .origin.y = -22, .size.width = NSWidth([self.contentView frame]) - 50, .size.height = 22}];
		showingError = NO;
		return;
	}
	NSError *unreachableErr = [NSError errorWithDomain:PSTErrorDomain code:-3000 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"It appears the internetz are down. (Oh silly internetz)" }];
	[self presentError:unreachableErr contextInfo:NULL];
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
	return [self.viewController acceptsPreviewPanelControl:panel];
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
	// This document is now responsible of the preview panel
	// It is allowed to set the delegate, data source and refresh panel.
	[self.viewController beginPreviewPanelControl:panel];
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
	// This document loses its responsisibility on the preview panel
	// Until the next call to -beginPreviewPanelControl: it must not
	// change the panel's delegate, data source or refresh it.
	[self.viewController endPreviewPanelControl:panel];
}

// Quick Look panel data source

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
	return [self.viewController numberOfPreviewItemsInPreviewPanel:panel];
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
	return [self.viewController previewPanel:panel previewItemAtIndex:index];
}

// Quick Look panel delegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
	// redirect all key down events to the table view
	return [self.viewController previewPanel:panel handleEvent:event];
}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
	return [self.viewController previewPanel:panel sourceFrameOnScreenForPreviewItem:item];
}

// This delegate method provides a transition image between the table view and the preview panel
- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
	return [self.viewController previewPanel:panel transitionImageForPreviewItem:item contentRect:contentRect];
}


@end

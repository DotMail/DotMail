//
//  DMAccountSetupWindow.m
//  DotMail
//
//  Created by Robert Widmann on 10/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAccountSetupWindow.h"
#import "DMColoredView.h"

@implementation DMAccountSetupWindow 

- (id)init {
	self = [super initWithContentRect:(NSRect){ { 0, 0 }, { 600, 300 } } styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	self.contentView = [[DMColoredView alloc]initWithFrame:self.frame];
	
	self.titleBarStartColor = NSColor.whiteColor;
	self.titleBarEndColor = NSColor.whiteColor;
	self.inactiveTitleBarEndColor = NSColor.whiteColor;
	self.inactiveTitleBarStartColor = NSColor.whiteColor;
	self.baselineSeparatorColor = NSColor.whiteColor;
	self.inactiveBaselineSeparatorColor = NSColor.whiteColor;

	[self center];
	
	return self;
}

- (BOOL)isMovable {
	return NO;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (void)flagsChanged:(NSEvent *)theEvent {
	[self.windowController flagsChanged:theEvent];
	[super flagsChanged:theEvent];
}

@end

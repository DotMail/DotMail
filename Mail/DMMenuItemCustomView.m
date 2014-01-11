//
//  DMMenuItemCustomView.m
//  DotMail
//
//  Created by Robert Widmann on 7/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMMenuItemCustomView.h"

@interface DMMenuItemCustomView ()
@property (nonatomic, strong) NSTextField *titleField;
@end

@implementation DMMenuItemCustomView {
	NSTrackingRectTag trackingRect;
	BOOL highlight;
}

+ (instancetype)customViewWithTitle:(NSString *)title {
	return [self customViewWithTitle:title tileColor:nil];;
}

+ (instancetype)customViewWithTitle:(NSString *)title tileColor:(NSColor *)color {
	DMMenuItemCustomView *item = [[DMMenuItemCustomView alloc]initWithFrame:(NSRect){ .size = { 100, 24 } }];
	item.title = title;
	item.tileColor = color;
	return item;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.backgroundColor = NSColor.whiteColor;
	
	trackingRect = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:NO];
	
	_titleField = [[NSTextField alloc]initWithFrame:CGRectOffset(CGRectInset(self.bounds, 14, 2), 6, 0)];
	_titleField.backgroundColor = NSColor.clearColor;
	[_titleField setBordered:NO];
	[_titleField setFont:[NSFont systemFontOfSize:14]];
	[_titleField setBezeled:NO];
	[_titleField setFocusRingType:NSFocusRingTypeNone];
	[_titleField setEditable:NO];
	[self addSubview:_titleField];
	
	return self;
}

- (void)setTitle:(NSString *)title {
	_title = title;
	[self.titleField setStringValue:title ?: @""];
}

- (void)viewDidMoveToWindow {
	[self removeTrackingRect:trackingRect];
	NSPoint loc = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
	BOOL inside = ([self hitTest:loc] == self);
	trackingRect = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:inside];
}

- (void)viewWillMoveToWindow:(NSWindow *)window {
	if (!window && [self window]) [self removeTrackingRect:trackingRect];
	[super viewWillMoveToWindow:window];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void)mouseUp:(NSEvent*) event {
	highlight = NO;
	self.titleField.textColor = NSColor.blackColor;
	[self setNeedsDisplay:YES];
	NSMenu *menu = self.enclosingMenuItem.menu;
	[menu cancelTracking];
	[menu performActionForItemAtIndex:[menu indexOfItem:self.enclosingMenuItem]];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[super mouseEntered:theEvent];
	highlight = YES;
	self.titleField.textColor = NSColor.selectedMenuItemTextColor;
	[self.titleField setNeedsDisplay:YES];
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[super mouseExited:theEvent];
	highlight = NO;
	self.titleField.textColor = NSColor.blackColor;
	[self.titleField setNeedsDisplay:YES];
	[self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)rect {
	[super drawRect:rect];
	if (highlight) {
		[[NSColor selectedMenuItemColor]set];
		NSRectFill(rect);
	} else {
		[[NSColor whiteColor]set];
	}
	[self.tileColor ?: NSColor.grayColor drawSwatchInRect:(NSRect){ .origin.x = 8, .origin.y = 8, .size = { 10, 10 } }];
}

@end

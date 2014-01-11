//
//  DMPreferencesWindow.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMPreferencesWindow.h"
#import "DMColoredView.h"

@implementation DMPreferencesWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	self.contentView = [[DMColoredView alloc]initWithFrame:NSZeroRect];
	((DMColoredView *)self.contentView).backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];

	[self setMinSize:NSMakeSize(937, 332)];
	self.titleBarHeight = 80.0;
	self.centerTrafficLightButtons = NO;
	self.showsTitle = YES;
	self.title = @"Preferences";
	
	
	self.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath) {
		[[NSColor colorWithCalibratedRed:0.124 green:0.126 blue:0.132 alpha:1.000]set];
		NSRectFill(drawingRect);
	};
	self.titleFont = [NSFont fontWithName:@"Helvetica" size:12.0f];
	self.titleTextColor = NSColor.whiteColor;
	
	return self;
}

- (void)addButtonToTitleBar:(NSView *)viewToAdd atXPosition:(CGFloat)x {
	viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, viewToAdd.frame.size.height);
	
	NSUInteger mask = 0;
	if( x > self.frame.size.width / 2.0 ) {
		mask |= NSViewMinXMargin;
	} else {
		mask |= NSViewMaxXMargin;
	}
	[viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
	
	[[[self contentView] superview] addSubview:viewToAdd];
}

- (CGFloat)heightOfTitleBar {
	NSRect outerFrame = [[self.contentView superview] frame];
	NSRect innerFrame = [self.contentView frame];
	
	return outerFrame.size.height - innerFrame.size.height;
}

@end

//
//  CFIComposeView.m
//  DotMail
//
//  Created by Robert Widmann on 7/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMComposeView.h"


@implementation DMComposeView

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.wantsLayer = YES;
		// Initialization code here.
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	// Drawing code here.
	
	[NSColor.whiteColor set];
	NSRectFill(self.bounds);
	
	CGContextRef c = TUIGraphicsGetCurrentContext();
	const CGFloat* colors = CGColorGetComponents([[NSColor colorWithCalibratedWhite:0.910 alpha:1.000]tui_CGColor]);
	CGContextSetStrokeColor(c, colors);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 0.0f, CGRectGetHeight(self.bounds) - 80);
	CGContextAddLineToPoint(c, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 80);
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 0.0f, CGRectGetHeight(self.bounds) - 112);
	CGContextAddLineToPoint(c, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 112);
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 0.0f, CGRectGetHeight(self.bounds) - 144);
	CGContextAddLineToPoint(c, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 144);
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 0.0f, CGRectGetHeight(self.bounds) - 174);
	CGContextAddLineToPoint(c, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 174);
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 0.0f, CGRectGetHeight(self.bounds) - 205);
	CGContextAddLineToPoint(c, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 205);
	CGContextStrokePath(c);
}

@end

@implementation DMAboutBackgroundView

- (void)drawRect:(NSRect)dirtyRect {
	[NSColor.whiteColor set];
	NSRectFill(self.bounds);
}

@end

@implementation DMAttachmentsSpacerFooterView

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithCalibratedRed:0.966 green:0.975 blue:0.975 alpha:1.000] set];
	NSRectFill(self.bounds);
}

@end
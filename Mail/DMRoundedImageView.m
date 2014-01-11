//
//  DMRoundedImageView.m
//  DotMail
//
//  Created by Robert Widmann on 4/25/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMRoundedImageView.h"

NSColor *DMRoundedImageViewDefaultBorderColor = nil;

@implementation DMRoundedImageView

- (instancetype)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	self.wantsLayer = YES;
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = 10.0;
	[self.cell setImageAlignment:NSImageAlignCenter];
	[self.cell setImageScaling:NSImageScaleProportionallyUpOrDown];
	DMRoundedImageViewDefaultBorderColor = [NSColor colorWithCalibratedRed:0.907 green:0.926 blue:0.941 alpha:1.000];
	
	return self;
}

- (void)setBorderColor:(NSColor *)color {
	_borderColor = color;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
	NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 2, 2)];
	
	[circlePath addClip];
	[super drawRect:dirtyRect];
	
	[self.borderColor ?: [NSColor colorWithCalibratedRed:0.907 green:0.926 blue:0.941 alpha:1.000] setStroke];
	[self.borderColor ?: [NSColor colorWithCalibratedRed:0.907 green:0.926 blue:0.941 alpha:1.000] setFill];
	
	NSBezierPath *circleOutline = [NSBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 2, 2)];
	[circleOutline setLineWidth:5];
	[circleOutline stroke];
}

@end

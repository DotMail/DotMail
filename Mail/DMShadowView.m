//
//  DMShadowView.m
//  DotMail
//
//  Created by Robert Widmann on 4/21/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMShadowView.h"

static const CGFloat colors[] = {
	0.93, 0.95, 0.96, 1.0f,
	0.95, 0.96, 0.97, 1.0f,
	0.98, 0.98, 0.98, 1.0f,
	0.99, 0.99, 1.0f, 1.0f,
};
static const CGFloat locations[] = {
	0.0f, 0.33, 0.66, 1.0
};

@interface DMColoredShadowView : DMShadowView @end

@implementation DMShadowView

+ (instancetype)coloredShadowViewWithFrame:(CGRect)frame {
	return [[DMColoredShadowView alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];

	NSShadow *dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.000 alpha:0.500]];
	[dropShadow setShadowOffset:NSMakeSize(5, 3.f)];
	[dropShadow setShadowBlurRadius:3.0];
	
	[self setWantsLayer:YES];
	[self setShadow:dropShadow];		

	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
	if (self.backgroundColor) {
		[self.backgroundColor set];
		NSRectFill(dirtyRect);
	}
	
	[NSGraphicsContext saveGraphicsState];
	NSShadow *dropShadow = [[NSShadow alloc] init];
	[dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.000 alpha:0.500]];
	[dropShadow setShadowOffset:self.inverted ? NSMakeSize(5, 3.f) : NSMakeSize(5, -3.f)];
	[dropShadow setShadowBlurRadius:3.0];
	[dropShadow set];
	[NSGraphicsContext restoreGraphicsState];
}

@end

@implementation DMColoredShadowView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.shadow = nil;
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGRect b = self.bounds;

	CGContextRef ctx = TUIGraphicsGetCurrentContext();
	
	CGFloat maxy = CGRectGetMaxY(b);
	
	[[NSColor colorWithRed:0.93 green:0.95 blue:0.96 alpha:1.0]set];
	CGContextSetLineWidth(ctx, 1.0f);
	CGContextMoveToPoint(ctx, 0, 0);
	CGContextAddLineToPoint(ctx, 1, maxy);
	CGContextStrokePath(ctx);
	[[NSColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0]set];
	CGContextSetLineWidth(ctx, 1.0f);
	CGContextMoveToPoint(ctx, 1, 0);
	CGContextAddLineToPoint(ctx, 2, maxy);
	CGContextStrokePath(ctx);
	[[NSColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0]set];
	CGContextSetLineWidth(ctx, 1.0f);
	CGContextMoveToPoint(ctx, 2, 0);
	CGContextAddLineToPoint(ctx, 3, maxy);
	CGContextStrokePath(ctx);
	[[NSColor colorWithRed:0.99 green:0.99 blue:1.00 alpha:1.0]set];
	CGContextSetLineWidth(ctx, 1.0f);
	CGContextMoveToPoint(ctx, 3, 0);
	CGContextAddLineToPoint(ctx, 4, maxy);
	CGContextStrokePath(ctx);
}

@end

//
//  DMLabel.m
//  DotMail
//
//  Created by Robert Widmann on 9/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLabel.h"
#import <QuartzCore/QuartzCore.h>

static NSString *DMTruncationModeMap[4] = {
	@"none",
	@"start",
	@"middle",
	@"end"
};

static NSString *DMTextAlignmentModeMap[5] = {
	@"left",
	@"right",
	@"center",
	@"justified",
	@"natural"
};

@interface DMTextLayer : CATextLayer
@property (nonatomic, strong) NSColor *shadowColor;
@property (nonatomic, strong) NSColor *backgroundFillColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) BOOL drawsBackground;
@end

@implementation DMTextLayer

- (void)drawInContext:(CGContextRef)ctx {
	CGContextSaveGState(ctx);
	
	if (self.drawsBackground && self.backgroundFillColor != nil) {
		CGContextSetFillColorWithColor(ctx, self.backgroundFillColor.CGColor);
		CGContextFillRect(ctx, self.bounds);
		
		CGContextSetShouldSmoothFonts(ctx, YES);
		CGContextSetAllowsAntialiasing(ctx, YES);
		CGContextSetAllowsFontSubpixelPositioning(ctx, YES);
		CGContextSetAllowsFontSubpixelQuantization(ctx, YES);
	}
	
	CGContextSetShadowWithColor(ctx, self.shadowOffset, self.shadowRadius, self.shadowColor.CGColor);
	[super drawInContext:ctx];
	
	CGContextRestoreGState(ctx);
}

@end

@interface DMLabel()
@property (nonatomic, strong) DMTextLayer *layer;
@end

@implementation DMLabel
@dynamic layer;

- (void)setup {
	self.layer = [DMTextLayer layer];
	self.layer.delegate = self;
	self.wantsLayer = YES;
	
	self.textColor = [NSColor blackColor];
	self.font = [NSFont fontWithName:@"Helvetica" size:13.0];
	self.textAlignment = NSLeftTextAlignment;
	
	self.shadowColor = [NSColor clearColor];
	self.shadowOffset = CGSizeZero;
	self.shadowRadius = 0.f;
	
	self.drawsBackground = NO;
	self.backgroundColor = [NSColor whiteColor];
	
	self.wraps = NO;
	self.truncationMode = DMLabelTruncationModeNone;
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	[self setup];
	return self;
}

- (void)viewDidChangeBackingProperties {
	self.layer.contentsScale = self.window.backingScaleFactor;
}

- (void)setFont:(NSFont *)font {
	if (font != nil && _font != font) {
		_font = font;
		self.layer.font = (__bridge CFTypeRef)(font);
		self.layer.fontSize = font.pointSize;
	}
}

- (void)setText:(NSString *)text {
	if (_text != text) {
		_text = text;
		self.layer.string = text;
	}
}

- (void)setTextColor:(NSColor *)textColor {
	if (_textColor != textColor) {
		_textColor = textColor;
		self.layer.foregroundColor = textColor.CGColor;
	}
}

- (void)setShadowColor:(NSColor *)shadowColor {
	self.layer.shadowColor = shadowColor;
}

- (NSColor *)shadowColor {
	return self.layer.shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
	self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset {
	return self.layer.shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
	self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
	return self.layer.shadowRadius;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	self.layer.alignmentMode = DMTextAlignmentModeMap[textAlignment];
}

- (void)setDrawsBackground:(BOOL)drawsBackground {
	self.layer.drawsBackground = drawsBackground;
}

- (BOOL)drawsBackground {
	return self.layer.drawsBackground;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.layer.backgroundFillColor = backgroundColor;
}

- (NSColor *)backgroundColor {
	return self.layer.backgroundFillColor;
}

- (void)setWraps:(BOOL)wraps {
	_wraps = wraps;
	self.layer.wrapped = wraps;
}

- (void)setTruncationMode:(DMLabelTruncationMode)truncationMode {
	_truncationMode = truncationMode;
	self.layer.truncationMode = DMTruncationModeMap[truncationMode];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
	return (id<CAAction>)[NSNull null];
}

@end

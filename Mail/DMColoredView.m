//
//  DMColoredView.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMColoredView.h"

@implementation DMColoredView

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	CALayer *layer = [CALayer layer];
	self.layer = layer;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	self.wantsLayer = YES;
	return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.layer.backgroundColor = backgroundColor.CGColor;
}

@end

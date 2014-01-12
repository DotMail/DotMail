//
//  DMOrganizeFolderCellView.m
//  DotMail
//
//  Created by Robert Widmann on 1/11/14.
//  Copyright (c) 2014 CodaFi Inc. All rights reserved.
//

#import "DMOrganizeFolderCellView.h"
#import "DMColoredView.h"
#import "DMRoundedImageView.h"
#import "DMLabel.h"

@interface DMOrganizeFolderCellView ()
@property (nonatomic, strong) DMColoredView *innerView;
@property (nonatomic, strong) DMLabel *accountEmailField;
@end

@implementation DMOrganizeFolderCellView

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.layer = CALayer.layer;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	self.wantsLayer = YES;
	
	_innerView = [[DMColoredView alloc]initWithFrame:self.bounds];
	_innerView.backgroundColor = [NSColor colorWithCalibratedRed:0.296 green:0.303 blue:0.315 alpha:1.000];
	[self addSubview:_innerView];
	
	_accountEmailField = [[DMLabel alloc]initWithFrame:NSZeroRect];
	_accountEmailField.font = [NSFont fontWithName:@"Helvetica-Neue" size:16];
	_accountEmailField.textColor = NSColor.whiteColor;
	[_innerView addSubview:_accountEmailField];
	
	return self;
}

- (void)setLabel:(NSString *)label {
	self.accountEmailField.text = label;
	_label = label;
}

- (void)setLabelColor:(NSColor *)labelColor {
	self.innerView.backgroundColor = labelColor;
	_accountEmailField.textColor = DMReadableTextColorForBackgroundColor(labelColor);
	_labelColor = labelColor;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	
	self.innerView.frame = self.bounds;
	self.accountEmailField.frame = (NSRect){ {8, 7}, {NSWidth(frameRect) - 66, 20} };
}

- (BOOL)isFlipped {
	return NO;
}

// http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
static NSColor *DMReadableTextColorForBackgroundColor(NSColor *backgroundColor) {
	const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);
	CGFloat contrast = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
	return (contrast >= 175) ? [NSColor blackColor] : [NSColor whiteColor];
}

@end

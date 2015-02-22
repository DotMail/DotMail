//
//  DMFlatButton.m
//  DotMail
//
//  Created by Robert Widmann on 10/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMFlatButton.h"
#import "DMLabel.h"
#import "NSColor+DMUIColors.h"
#include <objc/message.h>

@interface DMFlatButton ()

@property (nonatomic, strong) DMLabel *label;

@end

@implementation DMFlatButton

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.layer = CALayer.layer;
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = 4.0f;
	self.wantsLayer = YES;
	
	_label = [[DMLabel alloc]initWithFrame:self.bounds];
	_label.textColor = NSColor.whiteColor;
	_label.textAlignment = NSCenterTextAlignment;
	[self addSubview:_label];
		
	return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
	self.layer.backgroundColor = [self.backgroundColor darkerColor].CGColor;
	[self.layer setNeedsDisplay];
}

- (void)mouseUp:(NSEvent *)theEvent {
	self.layer.backgroundColor = self.backgroundColor.CGColor;
	[self.layer setNeedsDisplay];
	void(*DMFlatButtonMouseUpMsgSend)(id self, SEL _cmd, DMFlatButton *sender) = (void *)objc_msgSend;
	DMFlatButtonMouseUpMsgSend(self.target, self.action, self);
}

- (void)setTitle:(NSString *)aString {
	self.label.text = aString;
}

- (void)setFont:(NSFont *)fontObj {
	self.label.font = fontObj;
}

- (void)setVerticalPadding:(CGFloat)padding {
	_label.frame = CGRectOffset(self.bounds, 0, padding);
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	_backgroundColor = backgroundColor;
	self.layer.backgroundColor = backgroundColor.CGColor;
	[self.layer setNeedsDisplay];
}

@end

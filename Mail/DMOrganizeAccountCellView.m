//
//  DMAccountCell.m
//  DotMail
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMOrganizeAccountCellView.h"
#import "DMColoredView.h"
#import "DMRoundedImageView.h"
#import "DMLabel.h"

@interface DMOrganizeAccountCellView ()
@property (nonatomic, strong) DMColoredView *innerView;
@property (nonatomic, strong) DMLabel *accountEmailField;
@end

@implementation DMOrganizeAccountCellView

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

- (void)setAccount:(PSTMailAccount *)account {
	self.accountEmailField.text = account.email;
	_account = account;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	
	self.innerView.frame = self.bounds;
	self.accountEmailField.frame = (NSRect){ {12, 12}, {NSWidth(frameRect) - 66, 20} };
}

- (void)setSelected:(BOOL)selected {
	self.innerView.backgroundColor = selected ? [NSColor colorWithCalibratedRed:0.109 green:0.120 blue:0.129 alpha:1.000] : [NSColor colorWithCalibratedRed:0.296 green:0.303 blue:0.315 alpha:1.000];
	[super setSelected:selected];
}

- (BOOL)isFlipped {
	return NO;
}

@end

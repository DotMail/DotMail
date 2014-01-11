//
//  DMAccountCell.m
//  DotMail
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAccountCell.h"
#import "DMColoredView.h"
#import "DMRoundedImageView.h"
#import "DMLabel.h"

NSString * const DMAccountRequestDeletionNotification = @"DMAccountRequestDeletionNotification";

@interface DMAccountCell ()
@property (nonatomic, strong) DMColoredView *innerView;
@property (nonatomic, strong) DMRoundedImageView *iconImageView;
@property (nonatomic, strong) DMLabel *accountEmailField;
@property (nonatomic, assign) BOOL actionStepsOpen;
@end

@implementation DMAccountCell {
	NSTrackingRectTag trackingRect;
	CALayer *actionStepOne;
}

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
		
	self.layer = CALayer.layer;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	self.wantsLayer = YES;
	
	actionStepOne = CALayer.layer;
	actionStepOne.frame = NSMakeRect(0, 0, 50, 50);
	actionStepOne.contentsScale = NSScreen.mainScreen.backingScaleFactor;
	actionStepOne.backgroundColor = [NSColor colorWithCalibratedRed:0.91 green:0.09 blue:0.09 alpha:1.0].CGColor;
	[self.layer addSublayer:actionStepOne];
	
	CATextLayer *notificationsBlockLabel = [CATextLayer layer];
	notificationsBlockLabel.backgroundColor = NSColor.clearColor.CGColor;
	notificationsBlockLabel.frame = (NSRect){ {0, 0}, {50, 38} };
	notificationsBlockLabel.wrapped = NO;
	CTFontRef font = CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Medium", 20.f, NULL);
	notificationsBlockLabel.font = font;
	notificationsBlockLabel.fontSize = 20.f;
	notificationsBlockLabel.alignmentMode = kCAAlignmentCenter;
	notificationsBlockLabel.string = @"X";
	[self.layer addSublayer:notificationsBlockLabel];
	
	_innerView = [[DMColoredView alloc]initWithFrame:self.bounds];
	_innerView.backgroundColor = [NSColor colorWithCalibratedRed:0.296 green:0.303 blue:0.315 alpha:1.000];
	[self addSubview:_innerView];
	
	_iconImageView = [[DMRoundedImageView alloc]initWithFrame:(NSRect){ {16, 5}, {40, 40} }];
	[_innerView addSubview:_iconImageView];
	
	_accountEmailField = [[DMLabel alloc]initWithFrame:NSZeroRect];
	_accountEmailField.font = [NSFont fontWithName:@"Helvetica-Neue" size:16];
	_accountEmailField.textColor = NSColor.whiteColor;
	[_innerView addSubview:_accountEmailField];
	
	[[[[RACObserve(self,actionStepsOpen) skip:1] distinctUntilChanged] filter:^BOOL(NSNumber *value) {
		return self.window.isKeyWindow || !value.boolValue;
	}] subscribeNext: ^(NSNumber *keyWindow) {
		[self openActionSteps:keyWindow.boolValue];
	}];
	
	CFRelease(font);
	
	return self;
}

- (void)openActionSteps:(BOOL)open {
	[self.innerView.animator setFrame:open ? CGRectOffset(self.bounds, 50, 0) : self.bounds];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.actionStepsOpen = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.actionStepsOpen = NO;
}

- (void)mouseDown:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (CGRectContainsPoint(NSMakeRect(0, 0, 50, 50), mousePoint)) {
		actionStepOne.backgroundColor = [NSColor colorWithCalibratedRed:0.601 green:0.059 blue:0.059 alpha:1.000].CGColor;
	}
}

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (CGRectContainsPoint(NSMakeRect(0, 0, 50, 50), mousePoint)) {
		[NSNotificationCenter.defaultCenter postNotificationName:DMAccountRequestDeletionNotification object:nil userInfo:@{ @"Account" : self.account }];
	}
	actionStepOne.backgroundColor = [NSColor colorWithCalibratedRed:0.91 green:0.09 blue:0.09 alpha:1.0].CGColor;
}

- (void)viewDidMoveToWindow {
	trackingRect = [self addTrackingRect:(NSRect){ .size = { 40, NSHeight(self.bounds) } } owner:self userData:NULL assumeInside:NO];
}

- (void)setAccount:(PSTMailAccount *)account {
	self.iconImageView.image = [PSTAvatarImageManager.defaultManager avatarForEmail:account.email];
	self.accountEmailField.text = account.email;
	_account = account;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	
	self.innerView.frame = self.bounds;
	self.iconImageView.frame = (NSRect){ {16, 5}, {40, 40} };
	self.accountEmailField.frame = (NSRect){ {72, 12}, {NSWidth(frameRect) - 66, 20} };
}

- (BOOL)isFlipped {
	return NO;
}

@end

//
//  DemoView.m
//  JAListView
//
//  Created by Josh Abernathy on 9/29/10.
//  Copyright 2010 Maybe Apps. All rights reserved.
//

#import "DMMessageCell.h"

static const CGFloat colors[] = {
	238.0f / 255.0f, 242.0f / 255.0f, 244.0f / 255.0f, 1.0f,
	248.0f / 255.0f, 250.0f / 255.0f, 250.0f / 255.0f, 1.0f,
	248.0f / 255.0f, 250.0f / 255.0f, 250.0f / 255.0f, 1.0f,
	222.0f / 255.0f, 230.0f / 255.0f, 235.0f / 255.0f, 1.0f
};
static const CGFloat locations[] = {
	1.0f, 108.0 / 112.0, 3.0 / 112.0, 0.0
};

@interface DMMessageCell ()

@property (nonatomic, strong) CALayer *readIndicatorLayer;
@property (nonatomic, strong) DMActionStepButton *actionStepButton;
@property (nonatomic, strong) CATextLayer *from;
@property (nonatomic, strong) CATextLayer *subject;
@property (nonatomic, strong) CATextLayer *bodyPreview;
@property (nonatomic, strong) CATextLayer *timeStamp;
@property (nonatomic, strong) CATextLayer *separatorLayer;
@property (nonatomic, strong) CATextLayer *replyCount;
@property (nonatomic, strong) CALayer *replyBackgroundLayer;
@property (nonatomic, assign) BOOL actionStepsOpen;
@property (nonatomic, strong) RACDisposable *bodyPreviewDisposable;

@end

@implementation DMMessageCell {
	NSTrackingRectTag trackingRect;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	self.layer = CALayer.layer;
	self.layer.delegate = self;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	self.wantsLayer = YES;
	_actionStepsOpen = NO;
	self.layer.masksToBounds = YES;
	
	_readIndicatorLayer = [CALayer layer];
	_readIndicatorLayer.frame = CGRectMake(6, 70, 9, 9);
	_readIndicatorLayer.contents = (id)[NSImage imageNamed:@"unread_circle"];
	[self.layer addSublayer:_readIndicatorLayer];

	_actionStepButton = [[DMActionStepButton alloc] initWithFrame:CGRectMake( -38, 0, 40, NSHeight(self.frame) )];
	_actionStepButton.delegate = self;
	[self addSubview:_actionStepButton];
	
	CTFontRef bodyFont = CTFontCreateWithName(CFSTR("HelveticaNeue"), 13.f, NULL);
	CTFontRef timestampFont = CTFontCreateWithName(CFSTR("HelveticaNeue"), 11.f, NULL);
	CTFontRef fromFont = CTFontCreateWithName(CFSTR("HelveticaNeue-Bold"), 18.f, NULL);
	
	_bodyPreview = [CATextLayer layer];
	_bodyPreview.frame = CGRectMake(0, 9, NSWidth(self.frame) - 62, 38);
	_bodyPreview.font = bodyFont;
	_bodyPreview.wrapped = YES;
	_bodyPreview.fontSize = 13.f;
	_bodyPreview.foregroundColor = [NSColor colorWithCalibratedRed:0.552 green:0.594 blue:0.629 alpha:1.000].CGColor;
	_bodyPreview.alignmentMode = @"left";
	_bodyPreview.backgroundColor = NSColor.clearColor.CGColor;
	_bodyPreview.autoresizingMask = kCALayerWidthSizable;
	
	_subject = [CATextLayer layer];
	_subject.frame = CGRectMake(0, 51, NSWidth(self.bounds) - 71, 20);
	_subject.font = bodyFont;
	_subject.fontSize = 13.f;
	_subject.alignmentMode = @"left";
	_subject.foregroundColor = [NSColor colorWithCalibratedWhite:0.278 alpha:1.000].CGColor;
	_subject.backgroundColor = NSColor.clearColor.CGColor;
	_subject.autoresizingMask = kCALayerWidthSizable;
	
	_timeStamp = [CATextLayer layer];
	_timeStamp.frame = CGRectMake(0, 79, NSWidth(self.frame) - 175, 14);
	_timeStamp.font = timestampFont;
	_timeStamp.fontSize = 11.f;
	_timeStamp.alignmentMode = @"right";
	_timeStamp.foregroundColor = [NSColor colorWithCalibratedRed:0.371 green:0.506 blue:0.651 alpha:1.000].CGColor;
	_timeStamp.backgroundColor = NSColor.clearColor.CGColor;
	_timeStamp.autoresizingMask = kCALayerMinXMargin;
	
	_from = [CATextLayer layer];
	_from.frame = CGRectMake(0, 75, NSWidth(self.frame) - 100, 22);
	_from.foregroundColor = [NSColor colorWithCalibratedRed:0.145 green:0.169 blue:0.189 alpha:1.000].CGColor;
	_from.font = fromFont;
	_from.fontSize = 18.f;
	_from.alignmentMode = @"left";
	_from.backgroundColor = NSColor.clearColor.CGColor;
	_from.autoresizingMask = kCALayerWidthSizable;

	_replyCount = [CATextLayer layer];
	_replyCount.frame = CGRectMake(0, NSWidth(self.frame) - 30, 18, 18);
	_replyCount.foregroundColor = [NSColor colorWithCalibratedRed:0.652 green:0.674 blue:0.687 alpha:1.000].CGColor;
	_replyCount.font = fromFont;
	_replyCount.fontSize = 10.f;
	_replyCount.alignmentMode = @"center";
	_replyCount.backgroundColor = NSColor.clearColor.CGColor;

	_replyBackgroundLayer = [CALayer layer];
	_replyBackgroundLayer.cornerRadius = 2.0f;
	_replyBackgroundLayer.masksToBounds = YES;
	_replyBackgroundLayer.frame = self.replyCount.frame;
	_replyBackgroundLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.878 green:0.893 blue:0.897 alpha:1.000].CGColor;

	_separatorLayer = [CALayer layer];
	_separatorLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.871 green:0.902 blue:0.922 alpha:1.000].CGColor;
	[self.layer addSublayer:_separatorLayer];
	
	[self.layer addSublayer:_bodyPreview];
	[self.layer addSublayer:_subject];
	[self.layer addSublayer:_timeStamp];
	[self.layer addSublayer:_from];
	[self.layer addSublayer:_separatorLayer];
	[self.layer addSublayer:_replyBackgroundLayer];
	[self.layer addSublayer:_replyCount];

	[[[[RACObserve(self,actionStepsOpen) skip:1] distinctUntilChanged] filter:^BOOL(NSNumber *value) {
		return self.window.isKeyWindow || !value.boolValue;
	}] subscribeNext: ^(NSNumber *keyWindow) {
		[self openActionSteps:keyWindow.boolValue];
	}];
	
	CFRelease(fromFont);
	CFRelease(timestampFont);
	CFRelease(bodyFont);
	
	return self;
}

- (void)viewDidMoveToWindow {
	trackingRect = [self addTrackingRect:(NSRect){ .size = { 40, NSHeight(self.bounds) } } owner:self userData:NULL assumeInside:NO];
}

- (void)prepareForReuse {
	self.bodyPreview.opacity = 0.f;
	self.bodyPreview.string = @"";
}

- (void)setConversation:(PSTConversation *)conversation {
	[self.bodyPreviewDisposable dispose];
	[self.conversation.cache removeObserverForUID];
	_conversation = conversation;
	
	[RACObserve(conversation,cache) doNext:^(id x) {
		[self _reloadData];
	}];
	[_conversation loadCache];
	@weakify(self);
	self.bodyPreviewDisposable = [[self.conversation.cache.previewSignal deliverOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(id x) {
		[TUIView setAnimateContents:YES];
		@strongify(self);
		self.bodyPreview.string = x;
		[TUIView animateWithDuration:0.5 animations:^{
			self.bodyPreview.opacity = 1.f;
		}];
		[self setNeedsDisplay:YES];
		[TUIView setAnimateContents:NO];
	}];
	[self.conversation.cache loadPreviewSignals];
	self.account = self.conversation.account;
	self.actionStepValue = _conversation.actionStep;
	[self _reloadData];
	[self setNeedsDisplay:YES];
}

- (void)setSelected:(BOOL)selected {
	if (!selected) {
		[super setSelected:selected];
		return;
	}
	[self.conversation load];
	MCOMessageFlag flags = self.conversation.cache.flags;
	if (selected && !(flags & MCOMessageFlagSeen)) {
		[self toggleUnread];
	}
	[super setSelected:selected];
}

- (void)toggleUnread {
	BOOL didSetRead = NO;
	[self.conversation load];
	MCOMessageFlag flags = self.conversation.cache.flags;
	[self.account beginConversationUpdates];
	if ((flags & MCOMessageFlagSeen) == NO) {
		for (MCOIMAPMessage *message in self.conversation.messages) {
			message.flags |= MCOMessageFlagSeen;
			[self.account addModifiedMessage:message atPath:self.conversation.folder.path];
		}
		didSetRead = YES;
	} else {
		for (MCOIMAPMessage *message in self.conversation.messages) {
			message.flags &= ~MCOMessageFlagSeen;
			[self.account addModifiedMessage:message atPath:self.conversation.folder.path];
		}
	}
	[self.account endConversationUpdates];
	[self.conversation updateCacheFlags];
	[self setRead:didSetRead];
}

- (void)setRead:(BOOL)read {
	_read = read;
	self.readIndicatorLayer.opacity = read ? 0.f : 1.f;
	[self setNeedsDisplay:YES];
}

- (void)setActionStepValue:(PSTActionStepValue)actionStepValue {
	_actionStepValue = actionStepValue;
	[self.actionStepButton relayoutForNextStepMode:actionStepValue];
}

#pragma mark - Layout

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];

	self.bodyPreview.frame = CGRectMake(20, 16, NSWidth(frameRect) - 62, 34);
	self.subject.frame = CGRectMake(20, 51, NSWidth(frameRect) - 71, 20);
	self.from.frame = CGRectMake(20, 75, NSWidth(frameRect) - 100, 22);
	self.actionStepButton.frame = CGRectMake( -38, 0, 40, NSHeight(frameRect));
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	self.timeStamp.frame = CGRectMake(158, 79, NSWidth(frameRect) - 175, 14);
	self.replyCount.frame = CGRectMake(NSWidth(frameRect) - 30, 42, 18, 18);
	self.replyBackgroundLayer.frame = CGRectMake(NSWidth(frameRect) - 30, 44, 18, 18);
	[CATransaction commit];
	if (self.actionStepValue != PSTActionStepValueNone) {
		[self.actionStepButton setFrame:CGRectMake( -36, 0, 40, NSHeight(frameRect))];
		[self.actionStepButton relayoutForNextStepMode:self.actionStepValue];
	} else {
		[self.actionStepButton relayoutForNextStepMode:PSTActionStepValueNone];
	}
	self.separatorLayer.frame = CGRectMake(0, 0, NSWidth(frameRect), 1);
}

#pragma mark - Drawing

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	CGRect b = self.bounds;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat minx = CGRectGetMinX(b);
	CGFloat miny = CGRectGetMinY(b), maxy = CGRectGetMaxY(b);
	
	if (self.isSelected) {
		CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1);
		CGContextFillRect(ctx, b);
		
		CGGradientRef myGradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
		CGContextDrawLinearGradient(ctx, myGradient, CGPointMake(minx, miny), CGPointMake(minx, maxy), 0);
		CGGradientRelease(myGradient);
	}
	CGColorSpaceRelease(colorSpace);
}

- (BOOL)isFlipped {
	return NO;
}

- (BOOL)clipsToBounds {
	return YES;
}

- (void)highPriorityClicked {
	[self.conversation load];
	[self.conversation setActionStep:PSTActionStepValueHigh];
	[self.conversation updateCacheActionstepValue];
	self.actionStepValue = PSTActionStepValueHigh;
	[self.actionStepButton relayoutForNextStepMode:self.actionStepValue];
	[self openActionSteps:NO];
}

- (void)mediumPriorityClicked {
	[self.conversation load];
	[self.conversation setActionStep:PSTActionStepValueMedium];
	[self.conversation updateCacheActionstepValue];
	self.actionStepValue = PSTActionStepValueMedium;
	[self.actionStepButton relayoutForNextStepMode:self.actionStepValue];
	[self openActionSteps:NO];
}

- (void)lowPriorityClicked {
	[self.conversation load];
	[self.conversation setActionStep:PSTActionStepValueLow];
	[self.conversation updateCacheActionstepValue];
	self.actionStepValue = PSTActionStepValueLow;
	[self.actionStepButton relayoutForNextStepMode:self.actionStepValue];
	[self openActionSteps:NO];
}

- (void)resetPriorityClicked {
	[self.conversation load];
	[self.conversation setActionStep:PSTActionStepValueNone];
	[self.conversation updateCacheActionstepValue];
	self.actionStepValue = PSTActionStepValueNone;
	[self.actionStepButton relayoutForNextStepMode:self.actionStepValue];
	[self openActionSteps:NO];
}

#pragma mark - NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@:%p %@>", [self class], self, self.conversation];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self _reloadData];
}

- (void)_reloadData {
	[self.from setString:[self.conversation.cache.senders dm_AddressDisplayString]];
	[self.timeStamp setString:[[self.conversation sortDate] dmFormatString]];
	[self.subject setString:[self.conversation subject]];
	[self.readIndicatorLayer setOpacity:self.conversation.isSeen ? 0.f : 1.f];
	self.replyCount.hidden = self.conversation.cache.messages.count <= 1;
	self.replyBackgroundLayer.hidden = self.replyCount.hidden;
	[self.replyCount setString:[NSString stringWithFormat:@"%lu", self.conversation.cache.messages.count]];
	[self setNeedsDisplay:YES];
}

#pragma mark - Tracking

- (void) openActionSteps:(BOOL)open {
	if (open) {
		[TUIView animateWithDuration:0.25 animations: ^{
			[self.bodyPreview setFrame:CGRectMake(60, 16, NSWidth(self.frame) - 62, 34)];
			[self.subject setFrame:CGRectMake(60, 51, NSWidth(self.frame) - 71, 20)];
			[self.timeStamp setFrame:CGRectMake(188, 79, NSWidth(self.frame) - 175, 14)];
			[self.from setFrame:CGRectMake(60, 75, NSWidth(self.frame) - 100, 22)];
			[self.actionStepButton.animator setFrame:CGRectMake(-2, 0, 40, NSHeight(self.frame) )];
			self.readIndicatorLayer.frame = CGRectMake(46, 70, 9, 9);
			self.replyCount.frame = CGRectMake(NSWidth(self.frame), 42, 18, 18);
			self.replyBackgroundLayer.frame = CGRectMake(NSWidth(self.frame), 44, 18, 18);
		}];
	} else {
		if (self.actionStepValue != PSTActionStepValueNone) {
			[TUIView animateWithDuration:0.25 animations: ^{
				[self.bodyPreview setFrame:CGRectMake(20, 16, NSWidth(self.frame) - 62, 34)];
				[self.subject setFrame:CGRectMake(20, 51, NSWidth(self.frame) - 71, 20)];
				[self.timeStamp setFrame:CGRectMake(158, 79, NSWidth(self.frame) - 175, 14)];
				[self.from setFrame:CGRectMake(20, 75, NSWidth(self.frame) - 100, 22)];
				[self.actionStepButton.animator setFrame:CGRectMake( -36, 0, 40, NSHeight(self.frame) )];
				self.readIndicatorLayer.frame = CGRectMake(6, 70, 9, 9);
				self.replyCount.frame = CGRectMake(NSWidth(self.frame) - 30, 42, 18, 18);
				self.replyBackgroundLayer.frame = CGRectMake(NSWidth(self.frame) - 30, 44, 18, 18);
			}];
		} else {
			[TUIView animateWithDuration:0.25 animations: ^{
				[self.bodyPreview setFrame:CGRectMake(20, 16, NSWidth(self.frame) - 62, 34)];
				[self.subject setFrame:CGRectMake(20, 51, NSWidth(self.frame) - 71, 20)];
				[self.timeStamp setFrame:CGRectMake(158, 79, NSWidth(self.frame) - 175, 14)];
				[self.from setFrame:CGRectMake(20, 75, NSWidth(self.frame) - 100, 22)];
				[self.actionStepButton.animator setFrame:CGRectMake( -38, 0, 40, NSHeight(self.frame) )];
				self.readIndicatorLayer.frame = CGRectMake(6, 70, 9, 9);
				self.replyCount.frame = CGRectMake(NSWidth(self.frame) - 30, 42, 18, 18);
				self.replyBackgroundLayer.frame = CGRectMake(NSWidth(self.frame) - 30, 44, 18, 18);
			}];
		}
	}
}

- (void)keyDown:(NSEvent *)theEvent {
	switch (theEvent.keyCode) {
		case 51: {
			if (self.actionStepValue != 0) {
				[self resetPriorityClicked];
				return;
			}
			[self.conversation.account deleteConversation:self.conversation];
			return;
		}
			break;
			
		default:
			break;
	}
	[super keyDown:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.actionStepsOpen = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.actionStepsOpen = NO;
}

@end

@implementation DMActionStepButton {
	NSTrackingArea *trackingArea;
	BOOL pushed;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
		
	self.layer = CALayer.layer;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	self.wantsLayer = YES;
	
	_checkmarkActionStep = CALayer.layer;
	_checkmarkActionStep.frame = self.bounds;
	_checkmarkActionStep.opacity = 0.f;
	
	_actionStepOne = CALayer.layer;
	_actionStepOne.frame = NSMakeRect(0, 75, 38, 38);
	_actionStepOne.contentsScale = NSScreen.mainScreen.backingScaleFactor;
	_actionStepTwo = CALayer.layer;
	_actionStepTwo.frame = NSMakeRect(0, 38, 38, 38);
	_actionStepTwo.contentsScale = NSScreen.mainScreen.backingScaleFactor;
	_actionStepThree = CALayer.layer;
	_actionStepThree.frame = NSMakeRect(0, 0, 38, 38);
	_actionStepThree.contentsScale = NSScreen.mainScreen.backingScaleFactor;

	[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOne.png"]];
//		@weakify(self);
//		[self.actionStepOne addActionForControlEvents:TUIControlEventMouseHover block:^{
//			@strongify(self);
//			[self.actionStepOne setImage:[NSImage imageNamed:@"ActionStepOneHover.png"] forState:TUIControlStateNormal];
//		}];
//		[self.actionStepOne addActionForControlEvents:TUIControlEventEditingDidEndOnExit block:^{
//			@strongify(self);
//			[self.actionStepOne setImage:[NSImage imageNamed:@"ActionStepOne.png"] forState:TUIControlStateNormal];
//		}];
	[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwo.png"]];
//		[self.actionStepTwo addActionForControlEvents:TUIControlEventMouseHover block:^{
//			@strongify(self);
//			[self.actionStepTwo setImage:[NSImage imageNamed:@"ActionStepTwoHover.png"] forState:TUIControlStateNormal];
//		}];
//		[self.actionStepTwo addActionForControlEvents:TUIControlEventEditingDidEndOnExit block:^{
//			@strongify(self);
//			[self.actionStepTwo setImage:[NSImage imageNamed:@"ActionStepTwo.png"] forState:TUIControlStateNormal];
//		}];
	[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThree.png"]];
//		[self.actionStepThree addActionForControlEvents:TUIControlEventMouseHover block:^{
//			@strongify(self);
//			[self.actionStepThree setImage:[NSImage imageNamed:@"ActionStepThreeHover.png"] forState:TUIControlStateNormal];
//		}];
//		[self.actionStepThree addActionForControlEvents:TUIControlEventEditingDidEndOnExit block:^{
//			@strongify(self);
//			[self.actionStepThree setImage:[NSImage imageNamed:@"ActionStepThree.png"] forState:TUIControlStateNormal];
//		}];
//		
	[self.layer addSublayer:self.actionStepOne];
	[self.layer addSublayer:self.actionStepTwo];
	[self.layer addSublayer:self.actionStepThree];
	[self.layer addSublayer:self.checkmarkActionStep];

	return self;
}

- (void)ensureTrackingArea {
	if (trackingArea == nil) {
		int opts = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
		trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:opts owner:self userInfo:nil];
	}
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	[self ensureTrackingArea];
	if (![[self trackingAreas] containsObject:trackingArea]) {
		[self addTrackingArea:trackingArea];
	}
}


- (void)mouseEntered:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (self.checkmarkActionStep.opacity != 1.f) {
		if (CGRectContainsPoint(self.actionStepOne.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOneHover.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwo.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThree.png"]];
		} else if (CGRectContainsPoint(self.actionStepTwo.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOne.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwoHover.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThree.png"]];
		} else if (CGRectContainsPoint(self.actionStepThree.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOne.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwo.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThreeHover.png"]];
		}
	}
}

- (void)mouseMoved:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (self.checkmarkActionStep.opacity != 1.f) {
		if (CGRectContainsPoint(self.actionStepOne.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOneHover.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwo.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThree.png"]];
		} else if (CGRectContainsPoint(self.actionStepTwo.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOne.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwoHover.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThree.png"]];
		} else if (CGRectContainsPoint(self.actionStepThree.frame, mousePoint)) {
			[self.actionStepOne setContents:[NSImage imageNamed:@"ActionStepOne.png"]];
			[self.actionStepTwo setContents:[NSImage imageNamed:@"ActionStepTwo.png"]];
			[self.actionStepThree setContents:[NSImage imageNamed:@"ActionStepThreeHover.png"]];
		}
	}
}

- (void)mouseDown:(NSEvent *)event {

}

- (void)mouseUp:(NSEvent *)event {
	NSPoint mousePoint = [self convertPoint:event.locationInWindow fromView:nil];
	if (self.checkmarkActionStep.opacity != 1.f) {
		if (CGRectContainsPoint(self.actionStepOne.frame, mousePoint)) {
			[self.delegate highPriorityClicked];
		} else if (CGRectContainsPoint(self.actionStepTwo.frame, mousePoint)) {
			[self.delegate mediumPriorityClicked];
		} else if (CGRectContainsPoint(self.actionStepThree.frame, mousePoint)) {
			[self.delegate lowPriorityClicked];
		}
	} else {
		[self.delegate resetPriorityClicked];
	}
}

- (void)relayoutForNextStepMode:(PSTActionStepValue)actionStep {
	@weakify(self);
	switch (actionStep) {
		case PSTActionStepValueNone: {
			[TUIView animateWithDuration:0.5 animations:^{
				@strongify(self);
				self.checkmarkActionStep.opacity = 0.f;
			}];
			break;
		}
		case PSTActionStepValueLow: {
			[self.checkmarkActionStep setContents:[NSImage imageNamed:@"ActionStepThreeCheckmark.png"]];
			[self.checkmarkActionStep setFrame:self.bounds];
			self.checkmarkActionStep.opacity = 1.f;

		}
			break;
		case PSTActionStepValueMedium: {
			[self.checkmarkActionStep setContents:[NSImage imageNamed:@"ActionStepTwoCheckmark.png"]];
			[self.checkmarkActionStep setFrame:self.bounds];
			self.checkmarkActionStep.opacity = 1.f;

		}
			break;
		case PSTActionStepValueHigh: {
			[self.checkmarkActionStep setContents:[NSImage imageNamed:@"ActionStepOneCheckmark.png"]];
			[self.checkmarkActionStep setFrame:self.bounds];
			self.checkmarkActionStep.opacity = 1.f;

			break;
		}
	}
}

- (void)resetCursorRects {
	[self addCursorRect:self.bounds cursor:NSCursor.pointingHandCursor];
}

@end
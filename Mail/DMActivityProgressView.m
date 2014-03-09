//
//  DMActivityProgressView.m
//  DotMail
//
//  Created by Robert Widmann on 7/16/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMActivityProgressView.h"

@interface DMActivityProgressView ()
@property (nonatomic, strong) TUILabel *label;
@property (nonatomic, strong) PSTActivity *topActivity;
@property (nonatomic, assign) BOOL actionStepsOpen;
@property (nonatomic, copy) void(^layoutSubviewsBlock)(NSRect frame);
@end

@implementation DMActivityProgressView {
	NSTrackingRectTag trackingRect;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.layer = CALayer.layer;
	self.wantsLayer = YES;
	
	self.layer.backgroundColor = NSColor.clearColor.CGColor;
	
	CATextLayer *label = CATextLayer.layer;
	label.frame = (CGRect){ .origin.x = 14, .origin.y = 22, .size = { frame.size.width - 28, 18 } };
	label.foregroundColor = NSColor.whiteColor.CGColor;
	label.font = (__bridge CTFontRef)[NSFont fontWithName:@"HelveticaNeue" size:14.0f];
	label.fontSize = 14.f;
	label.autoresizingMask = kCALayerWidthSizable;
	label.opacity = 0.0f;
	[self.layer addSublayer:label];

	CALayer *progressTrack = CALayer.layer;
	progressTrack.frame = (CGRect){ .size.width = frame.size.width, .size.height = 6 };
	progressTrack.backgroundColor = [NSColor colorWithCalibratedRed:0.189 green:0.198 blue:0.222 alpha:1.000].CGColor;
	[self.layer addSublayer:progressTrack];

	CALayer *metaProgressBar = CALayer.layer;
	metaProgressBar.frame = (CGRect){ .size.width = 0, .size.height = 6 };
	metaProgressBar.backgroundColor = [NSColor colorWithCalibratedRed:0.732 green:0.736 blue:0.209 alpha:1.000].CGColor;
	[self.layer addSublayer:metaProgressBar];
	
	CALayer *progressBar = CALayer.layer;
	progressBar.frame = (CGRect){ .size.width = 0, .size.height = 6 };
	progressBar.backgroundColor = [NSColor colorWithCalibratedRed:0.736 green:0.035 blue:0.068 alpha:1.000].CGColor;
	[self.layer addSublayer:progressBar];
	
	@weakify(self);
	[[[RACObserve(self,topActivity) filter:^BOOL(id value) {
		return value != nil;
	}] map:^id (PSTActivity *value) {
		return [[[RACSignal combineLatest:@[RACObserve(value,percentValue), RACObserve(value,metaPercentValue)]] doNext:^(RACTuple *progresses) {
			NSNumber *progress = progresses.first;
			NSNumber *metaprogress = progresses.second;
			@strongify(self);
			dispatch_async(dispatch_get_main_queue(), ^{
				if (self.actionStepsOpen) {
					progressTrack.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28), .size.height = 6 };
					progressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * progress.floatValue, .size.height = 6 };
					metaProgressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * metaprogress.floatValue, .size.height = 6 };
				} else {
					progressTrack.frame = (CGRect){ .size.width = self.frame.size.width, .size.height = 6 };
					progressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * progress.floatValue, .size.height = 6 };
					metaProgressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * metaprogress.floatValue, .size.height = 6 };
				}
				[progressBar setNeedsDisplay];
				[metaProgressBar setNeedsDisplay];
			});
		}] subscribeCompleted:^{ }];
	}] subscribeCompleted:^{ }];
	
	[[[[RACObserve(self,topActivity) skip:1] filter:^BOOL(id value) {
		return value != nil;
	}] map:^id(PSTActivity *value) {
		return [[RACObserve(value,activityDescription) doNext:^(NSString *x) {
			dispatch_async(dispatch_get_main_queue(), ^{
				label.string = x;
				[label setNeedsDisplay];
			});
		}] subscribeCompleted:^{ }];
	}]subscribeCompleted:^{ }];
	
	RACSignal *animateInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);
		[TUIView animateWithDuration:0.5 animations:^{
		
			CGRect rect = self.frame;
			rect.origin.y = 0;
			self.frame = rect;
		}];
		return nil;
	}];
	
	RACSignal *animateOutSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);
		[TUIView animateWithDuration:0.5 animations:^{
			CGRect rect = self.frame;
			rect.origin.y -= 50;
			self.frame = rect;
		}];
		
		return nil;
	}];
	
	[[RACSignal if:[[RACObserve(PSTActivityManager.sharedManager,activities) map:^id(NSArray *value) {
		if (value.count == 0) {
			return @NO;
		}
		return @YES;
	}] distinctUntilChanged] then:animateInSignal else:animateOutSignal]subscribeNext:^(id x) {
		
	}];
	
	[self rac_liftSelector:@selector(setTopActivity:) withSignals:[[RACObserve(PSTActivityManager.sharedManager,activities) map:^id(NSArray *value) {
		if (value.count == 0) {
			return nil;
		}
		return value[0];
	}] doNext:^(PSTActivity *x) {
		if (self.actionStepsOpen) {
			progressTrack.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28), .size.height = 6 };
			progressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * x.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * x.metaPercentValue, .size.height = 6 };
		} else {
			progressTrack.frame = (CGRect){ .size.width = self.frame.size.width, .size.height = 6 };
			progressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * x.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * x.metaPercentValue, .size.height = 6 };
		}
	}], nil];
	
	[[[RACObserve(self,actionStepsOpen) skip:1] distinctUntilChanged] subscribeNext: ^(id x) {
		if ([x boolValue]) {
			self.layer.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000].CGColor;
			label.opacity = 1.0f;
			progressTrack.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28), .size.height = 6 };
			progressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * self.topActivity.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(self.frame) - 28) * self.topActivity.metaPercentValue, .size.height = 6 };
		} else {
			label.opacity = 0.0f;
			self.layer.backgroundColor = NSColor.clearColor.CGColor;
			progressTrack.frame = (CGRect){ .size.width = self.frame.size.width, .size.height = 6 };
			progressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * self.topActivity.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .size.width = CGRectGetWidth(self.frame) * self.topActivity.metaPercentValue, .size.height = 6 };
		}
	}];
	
	self.layoutSubviewsBlock = ^(NSRect frame) {
		@strongify(self);
		if (self.actionStepsOpen) {
			progressTrack.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(frame) - 28), .size.height = 6 };
			progressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(frame) - 28) * self.topActivity.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .origin.x = 14, .origin.y = 10, .size.width = (CGRectGetWidth(frame) - 28) * self.topActivity.metaPercentValue, .size.height = 6 };
		} else {
			progressTrack.frame = (CGRect){ .size.width = frame.size.width, .size.height = 6 };
			progressBar.frame = (CGRect){ .size.width = CGRectGetWidth(frame) * self.topActivity.percentValue, .size.height = 6 };
			metaProgressBar.frame = (CGRect){ .size.width = CGRectGetWidth(frame) * self.topActivity.metaPercentValue, .size.height = 6 };
		}
	};

	return self;
}

- (void)viewDidMoveToWindow {
	trackingRect = [self addTrackingRect:(NSRect){ .size.width = self.frame.size.width, .size.height = 6 } owner:self userData:NULL assumeInside:NO];
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	if (self.layoutSubviewsBlock != NULL) {
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		self.layoutSubviewsBlock(frameRect);
		[CATransaction commit];
	}
}

- (void)mouseEntered:(NSEvent *)theEvent {
	self.actionStepsOpen = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.actionStepsOpen = NO;
}

@end

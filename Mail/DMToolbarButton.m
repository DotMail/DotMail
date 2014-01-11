//
//  DMToolbarButton.m
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMToolbarButton.h"

@implementation DMToolbarButton

- (instancetype)initWithImage:(NSImage *)image {
	self = [super initWithFrame:(NSRect){ .size = { 30, 30 } }];

	self.wantsLayer = YES;
	self.buttonType = NSMomentaryChangeButton;
	self.bordered = NO;
	self.image = image;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	
	return self;
}

- (RACSignal *)rac_selectionSignal {
	@weakify(self);
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);
		
		[self setTarget:subscriber];
		[self setAction:@selector(sendNext:)];
		[self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
			[subscriber sendCompleted];
		}]];
		
		return [RACDisposable disposableWithBlock:^{
			@strongify(self);
			[self setTarget:nil];
			[self setAction:NULL];
		}];
	}];
}

@end

@interface DMBadgedToolbarButton ()

@property (nonatomic, strong) CALayer *backgroundBadgeLayer;
@property (nonatomic, strong) CATextLayer *socialCounter;

@end

@implementation DMBadgedToolbarButton

- (instancetype)initWithImage:(NSImage *)image {
	self = [super initWithImage:image];

	self.layer.masksToBounds = NO;

	_backgroundBadgeLayer = [CALayer layer];
	_backgroundBadgeLayer.frame = CGRectMake(18, 7, 14, 13);
	_backgroundBadgeLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.871 green:0.000 blue:0.079 alpha:1.000].CGColor;
	[self.layer addSublayer:_backgroundBadgeLayer];

	_socialCounter = [CATextLayer layer];
	_socialCounter.frame = CGRectMake(18, 7, 14, 13);
	_socialCounter.foregroundColor = NSColor.whiteColor.CGColor;
	_socialCounter.fontSize = 10.f;
	_socialCounter.alignmentMode = @"center";
	_socialCounter.backgroundColor = NSColor.clearColor.CGColor;
	[self.layer addSublayer:_socialCounter];

	return self;
}

- (void)setBadgeCount:(NSUInteger)count {
	self.socialCounter.hidden = count <= 0;
	self.backgroundBadgeLayer.hidden = count <= 0;
	unsigned numDigits = count > 0 ? (int)log10((double) count) + 1 : 1;
	_socialCounter.frame = CGRectMake(18, 7, 14, 12 + (numDigits * 3));
	_socialCounter.frame = CGRectMake(18, 7, 14, 12 + (numDigits * 3));
	self.socialCounter.string = [NSString stringWithFormat:@"%lu", count];
}

@end
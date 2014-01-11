//
//  DMSocialNotificationCell.m
//  DotMail
//
//  Created by Robert Widmann on 4/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSocialNotificationCell.h"

static NSString *DMSocialModeTitleTable[] = {
	@"Twitter",  // DMSocialPopoverModeTwitter,
	@"Dribbble", // DMSocialPopoverModeDribbble,
	@"Facebook",  // DMSocialPopoverModeFacebook
};

static const CGFloat colors[] = {
	238.0f / 255.0f, 242.0f / 255.0f, 244.0f / 255.0f, 1.0f,
	248.0f / 255.0f, 250.0f / 255.0f, 250.0f / 255.0f, 1.0f,
	248.0f / 255.0f, 250.0f / 255.0f, 250.0f / 255.0f, 1.0f,
	222.0f / 255.0f, 230.0f / 255.0f, 235.0f / 255.0f, 1.0f
};
static const CGFloat locations[] = {
	0.0f, 3.0 / 112.0, 110.0 / 112.0, 1.0
};

@interface DMSocialNotificationCell ()
@property (nonatomic, strong) RACDisposable *bodyPreviewDisposable;
@property (nonatomic, strong) TUILabel *from;
@property (nonatomic, strong) TUILabel *subject;
@property (nonatomic, strong) TUILabel *bodyPreview;
@property (nonatomic, strong) TUILabel *timeStamp;
@end

@implementation DMSocialNotificationCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(TUITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	self.layer.masksToBounds = YES;
			
	_bodyPreview = [[TUILabel alloc] initWithFrame:CGRectMake(0, 9, NSWidth(self.frame) - 62, 38)];
	[_bodyPreview setSelectable:NO];
	[_bodyPreview setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.0f]];
	[_bodyPreview setTextColor:[NSColor colorWithCalibratedRed:0.552 green:0.594 blue:0.629 alpha:1.000]];
	[_bodyPreview setAlignment:TUITextAlignmentLeft];
	[_bodyPreview setBackgroundColor:[NSColor clearColor]];
	[_bodyPreview setLineBreakMode:(TUILineBreakModeWordWrap)];
	[_bodyPreview setAutoresizingMask:(TUIViewAutoresizingFlexibleWidth)];
	
	_subject = [[TUILabel alloc] initWithFrame:CGRectMake(0, 51, NSWidth(self.bounds) - 71, 20)];
	[_subject setSelectable:NO];
	[_subject setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.0f]];
	[_subject setAlignment:TUITextAlignmentLeft];
	[_subject setTextColor:[NSColor colorWithCalibratedWhite:0.278 alpha:1.000]];
	[_subject setBackgroundColor:[NSColor clearColor]];
	[_subject setLineBreakMode:TUILineBreakModeTailTruncation];
	[_subject setAutoresizingMask:(TUIViewAutoresizingFlexibleWidth)];
	
	_timeStamp = [[TUILabel alloc] initWithFrame:CGRectMake(0, 79, NSWidth(self.frame) - 175, 14)];
	[_timeStamp setSelectable:NO];
	[_timeStamp setFont:[NSFont fontWithName:@"HelveticaNeue" size:11.0f]];
	[_timeStamp setTextColor:[NSColor colorWithCalibratedRed:0.371 green:0.506 blue:0.651 alpha:1.000]];
	[_timeStamp setBackgroundColor:[NSColor clearColor]];
	[_timeStamp setAlignment:TUITextAlignmentRight];
	[_timeStamp setAutoresizingMask:(TUIViewAutoresizingFlexibleLeftMargin)];
	
	_from = [[TUILabel alloc] initWithFrame:CGRectMake(0, 75, NSWidth(self.frame) - 100, 22)];
	[_from setSelectable:NO];
	[_from setTextColor:[NSColor colorWithCalibratedRed:0.145 green:0.169 blue:0.189 alpha:1.000]];
	[_from setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
	[_from setAlignment:TUITextAlignmentLeft];
	[_from setBackgroundColor:[NSColor clearColor]];
	[_from setLineBreakMode:TUILineBreakModeTailTruncation];
	[_from setAutoresizingMask:(TUIViewAutoresizingFlexibleWidth)];
	
	[self addSubview:_bodyPreview];
	[self addSubview:_subject];
	[self addSubview:_timeStamp];
	[self addSubview:_from];

	return self;
}

- (void)prepareForReuse {
	self.bodyPreview.text = @"";
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self _reloadData];
}

#pragma mark - Drawing

- (void)layoutSubviews {
	[self.bodyPreview setFrame:CGRectMake(20, 9, NSWidth(self.frame) - 62, 38)];
	[self.subject setFrame:CGRectMake(20, 51, NSWidth(self.frame) - 71, 20)];
	[self.timeStamp setFrame:CGRectMake(158, 79, NSWidth(self.frame) - 175, 14)];
	[self.from setFrame:CGRectMake(20, 75, NSWidth(self.frame) - 100, 22)];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
	CGRect b = self.bounds;
	CGContextRef ctx = TUIGraphicsGetCurrentContext();
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat minx = CGRectGetMinX(b);
	CGFloat miny = CGRectGetMinY(b), maxy = CGRectGetMaxY(b);
	
	if (self.isSelected) {
		[NSColor.whiteColor set];
		NSRectFill(b);
		
		CGGradientRef myGradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, 4);
		CGContextDrawLinearGradient(ctx, myGradient, CGPointMake(minx, miny), CGPointMake(minx, maxy), 0);
		CGGradientRelease(myGradient);
	} else {
		[NSColor.whiteColor set];
		NSRectFill(b);
		
		[[NSColor colorWithCalibratedRed:0.871 green:0.902 blue:0.922 alpha:1.000] drawSwatchInRect:NSMakeRect(0, 0, NSWidth(dirtyRect), 1.0f)];
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, minx, maxy);
		CGPathAddLineToPoint(path, NULL, minx, maxy);
		CGPathCloseSubpath(path);
		CGPathRelease(path);
	}
	CGColorSpaceRelease(colorspace);
}

#pragma mark - Overrides

- (void)setNotification:(PSTConversation *)notification {
	[self.bodyPreviewDisposable dispose];
	[_notification.cache removeObserverForUID];
	if (_notification != nil) {
		[_notification removeObserver:self forKeyPath:@"cache"];
	}
	_notification = notification;
	[_notification addObserver:self forKeyPath:@"cache" options:0 context:NULL];
	[_notification loadCache];
	@weakify(self);
	self.bodyPreviewDisposable = [[self.notification.cache.previewSignal deliverOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(id x) {
		@strongify(self);
		self.bodyPreview.text = x;
		[self setNeedsDisplay];
	}];
	[_notification.cache loadPreviewSignals];
	[self _reloadData];
	[self setNeedsDisplay];
}

#pragma mark - Private

- (void)_reloadData {
	[self.from setText:DMSocialModeTitleTable[self.socialMode]];
	[self.timeStamp setText:[[self.notification sortDate] dmFormatString]];
	[self.subject setText:[self.notification subject]];
	[self setNeedsDisplay];
}

@end


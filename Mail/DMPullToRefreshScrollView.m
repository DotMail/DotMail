//
//  DMPullToRefreshScrollView.m
//  DotMail
//
//  Created by Robert Widmann on 9/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMPullToRefreshScrollView.h"
#import "DMColoredView.h"
#import "DMRefreshChevron.h"
#import "DMLabel.h"

#define REFRESH_HEADER_HEIGHT 40.0f

@interface DMPullToRefreshScrollView ()
@property (nonatomic, strong) DMColoredView *refreshHeader;
@property (nonatomic, strong) DMRefreshChevron *chevron;
@property (nonatomic, strong) DMLabel *textLabel;
@property (nonatomic, strong) NSProgressIndicator *refreshSpinner;
@property (getter = isRefreshing) BOOL refreshing;
@end

@implementation DMPullToRefreshScrollView {
	BOOL overHeaderView;
	struct {
		unsigned int delegateTriggeredRefresh:1;
	} flags;
}

- (void)viewDidMoveToWindow {
	NSRect contentRect = [self.contentView.documentView frame];
	
	self.verticalScrollElasticity = NSScrollElasticityAllowed;
	self.contentView.postsFrameChangedNotifications = YES;
	self.contentView.postsBoundsChangedNotifications = YES;
	
	_refreshHeader = [[DMColoredView alloc]initWithFrame:NSMakeRect(0, 0 - REFRESH_HEADER_HEIGHT, contentRect.size.width, REFRESH_HEADER_HEIGHT)];
	_refreshHeader.autoresizingMask = NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin;
	
	_textLabel = [[DMLabel alloc]initWithFrame:NSMakeRect(40, 8, contentRect.size.width - 40, 20)];
	_textLabel.autoresizingMask = kPSTAutoresizingMaskAll;
	_textLabel.textColor = NSColor.blackColor;
	_textLabel.text = @"Pull to Refresh";
	[self.refreshHeader addSubview:_textLabel];

	_chevron = [[DMRefreshChevron alloc]initWithFrame:(NSRect){ .size = { 40, 40 } }];
	[self.refreshHeader addSubview:_chevron];
	
	_refreshSpinner = [[NSProgressIndicator alloc]initWithFrame:(NSRect){ .origin = { 12, 12 }, .size = { 14, 12 } }];
	_refreshSpinner.style = NSProgressIndicatorSpinningStyle;
	_refreshSpinner.controlSize = NSSmallControlSize;
	_refreshSpinner.displayedWhenStopped = NO;
	_refreshSpinner.usesThreadedAnimation = YES;
	_refreshSpinner.indeterminate = YES;
	_refreshSpinner.bezeled = NO;
	[_refreshSpinner sizeToFit];
	[self.refreshHeader addSubview:_refreshSpinner];

	[NSNotificationCenter.defaultCenter addObserverForName:NSViewBoundsDidChangeNotification object:self.contentView queue:nil usingBlock:^(NSNotification *note) {
		if (_refreshing) return;
		
		if (self.overRefreshView) {
			self.chevron.inverted = YES;
			overHeaderView = YES;
			_textLabel.text = @"Release to Refresh";
		} else {
			self.chevron.inverted = NO;
			_textLabel.text = @"Pull to Refresh";
			overHeaderView = NO;
		}
	}];
	
	[self.contentView addSubview:self.refreshHeader];
	[self.contentView scrollToPoint:NSMakePoint(contentRect.origin.x, 0)];
	[self reflectScrolledClipView:self.contentView];
}

- (void)scrollWheel:(NSEvent *)event {
	if (event.phase == NSEventPhaseEnded) {
		if (overHeaderView && !_refreshing) {
			[self startLoading];
		}
	}
	[super scrollWheel:event];
}

- (BOOL)overRefreshView {
	NSClipView *clipView = self.contentView;
	NSRect bounds = clipView.bounds;
	
	CGFloat scrollValue = bounds.origin.y;
	return (scrollValue <= -40.f);
}

- (void)startLoading {
	_textLabel.text = @"Refreshing...";

	self.refreshing = YES;
	
	self.chevron.hidden = YES;
	[_refreshSpinner startAnimation:self];
	
	if (self.target && [self.target respondsToSelector:self.selector]) {
		[self.target performSelectorOnMainThread:self.selector withObject:self waitUntilDone:YES];
	}
	[self refreshPTRScrollViewContents];
}

- (void)stopLoading {
	_textLabel.text = @"Pull to Refresh";
	
	self.chevron.hidden = NO;
	[_refreshSpinner stopAnimation:self];
	
	self.refreshing = NO;
	
	CGEventRef cgEvent = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitLine, 2, 1, 0);
	NSEvent *scrollEvent = [NSEvent eventWithCGEvent:cgEvent];
	[self scrollWheel:scrollEvent];
	CFRelease(cgEvent);
}

- (CGFloat)minimumScroll {
	return (0 - _refreshHeader.frame.size.height);
}

- (void)refreshPTRScrollViewContents {
	if (flags.delegateTriggeredRefresh == 1) {
		[_delegate scrollViewDidTriggerRefresh:self];
	}
}

- (void)setDelegate:(id<DMPullToRefreshScrollViewDelegate>)delegate {
	_delegate = delegate;
	flags.delegateTriggeredRefresh = [_delegate respondsToSelector:@selector(scrollViewDidTriggerRefresh:)];
}

@end
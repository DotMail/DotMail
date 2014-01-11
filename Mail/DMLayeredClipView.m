//
//  DMLayeredClipView.m
//  DotMail
//
//  Created by Robert Widmann on 8/8/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLayeredClipView.h"
#import "DMPullToRefreshScrollView.h"

@implementation DMLayeredClipView

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	
	self.layer = [CAScrollLayer layer];
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
	
	return self;
}

@end

@implementation DMPullToRefreshClipView

- (NSPoint)constrainScrollPoint:(NSPoint)proposedNewOrigin {
	NSPoint constrained = [super constrainScrollPoint:proposedNewOrigin];
	CGFloat scrollValue = proposedNewOrigin.y;
	BOOL over = scrollValue <= -52.f;
	
	if (self.isRefreshing && scrollValue <= 0) {
		if (over) {
			proposedNewOrigin.y = -52.f;
		}
		return NSMakePoint(constrained.x, proposedNewOrigin.y);
	}
	return constrained;
}

- (BOOL)isFlipped {
	return YES;
}

- (NSRect)documentRect {
	NSRect sup = [super documentRect];
	if (self.isRefreshing) {
		sup.size.height += 52.f;
		sup.origin.y -= 52.f;
	}
	return sup;
}

- (BOOL)isRefreshing {
	return [(DMPullToRefreshScrollView *)self.superview isRefreshing];
}


@end
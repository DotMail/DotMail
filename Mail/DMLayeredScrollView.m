//
//  DMLayeredScrollView.m
//  DotMail
//
//  Created by Robert Widmann on 8/8/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLayeredScrollView.h"
#import "DMLayeredClipView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DMLayeredScrollView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];

	[self swapClipView];
	
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	if (![self.contentView isKindOfClass:DMLayeredClipView.class] ) {
		[self swapClipView];
	}
}

- (void)swapClipView {
	self.wantsLayer = YES;
	id documentView = self.documentView;
	DMLayeredClipView *clipView = [[DMLayeredClipView alloc] initWithFrame:self.contentView.frame];
	self.contentView = clipView;
	self.documentView = documentView;
}

@end


//
//  DMRefreshChevron.m
//  DotMail
//
//  Created by Robert Widmann on 9/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMRefreshChevron.h"

@interface DMRefreshChevron ()
@property (nonatomic, strong) CALayer *leftChevron;
@property (nonatomic, strong) CALayer *rightChevron;
@end

@implementation DMRefreshChevron

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
		
	_leftChevron = CALayer.layer;
	_leftChevron.backgroundColor = NSColor.grayColor.CGColor;
	_leftChevron.frame = (CGRect){ .origin = { 5, 20 }, .size = { 16, 2 } };
	_leftChevron.transform = CATransform3DMakeRotation(-(M_PI/4) * 3, 0.0, 0.0, 1.0);

	_rightChevron = CALayer.layer;
	_rightChevron.backgroundColor = NSColor.grayColor.CGColor;
	_rightChevron.frame = (CGRect){ .origin = { 15, 20 }, .size = { 16, 2 } };
	_rightChevron.transform = CATransform3DMakeRotation((M_PI/4) * 3, 0.0, 0.0, 1.0);
	
	[self.layer addSublayer:_leftChevron];
	[self.layer addSublayer:_rightChevron];
	
	return self;
}

- (void)setInverted:(BOOL)invert {
	_inverted = invert;
	if (invert) {
		_leftChevron.transform = CATransform3DMakeRotation(-M_PI/4, 0.0, 0.0, 1.0);
		_rightChevron.transform = CATransform3DMakeRotation(M_PI/4, 0.0, 0.0, 1.0);
	} else {
		_leftChevron.transform = CATransform3DMakeRotation(-(M_PI/4) * 3, 0.0, 0.0, 1.0);
		_rightChevron.transform = CATransform3DMakeRotation((M_PI/4) * 3, 0.0, 0.0, 1.0);

	}
}


@end

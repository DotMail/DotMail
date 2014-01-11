//
//  DMLayeredImageView.m
//  DotMail
//
//  Created by Robert Widmann on 9/22/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLayeredImageView.h"

@implementation DMLayeredImageView

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];

	return self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return NO;
}

- (NSView *)hitTest:(NSPoint)aPoint {
	return nil;
}

@end

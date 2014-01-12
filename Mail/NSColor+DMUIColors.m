//
//  NSColor+DMUIColors.m
//  DotMail
//
//  Created by Robert Widmann on 9/8/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "NSColor+DMUIColors.h"

@implementation NSColor (DMUIColors)

- (NSColor *)lighterColor {
	CGFloat h, s, b, a;
	[self getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSColor colorWithCalibratedHue:h saturation:s brightness:MIN(b * 1.3, 1.0) alpha:a];
	return nil;
}

- (NSColor *)darkerColor {
	CGFloat h, s, b, a;
	[self getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSColor colorWithCalibratedHue:h saturation:s brightness:b * 0.75 alpha:a];
	return nil;
}

@end


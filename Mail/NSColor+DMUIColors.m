//
//  NSColor+DMUIColors.m
//  DotMail
//
//  Created by Robert Widmann on 9/8/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "NSColor+DMUIColors.h"

@implementation NSColor (DMUIColors)

+ (NSColor *)colorWithHexColorString:(NSString *)inColorString {
	NSColor* result = nil;
	unsigned colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString) {
		NSScanner* scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode]; // ignore error
	}
	redByte = (unsigned char)(colorCode >> 16);
	greenByte = (unsigned char)(colorCode >> 8);
	blueByte = (unsigned char)(colorCode); // masks off high bits
	
	result = [NSColor
			  colorWithCalibratedRed:(CGFloat)redByte / 0xff
			  green:(CGFloat)greenByte / 0xff
			  blue:(CGFloat)blueByte / 0xff
			  alpha:1.0];
	return result;
}

- (NSString *)hexadecimalValue {
	double redFloatValue, greenFloatValue, blueFloatValue;
	int redIntValue, greenIntValue, blueIntValue;
	NSString *redHexValue, *greenHexValue, *blueHexValue;
	
	NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if(convertedColor) {
		[convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
		
		redIntValue = (int)(redFloatValue*255.99999f);
		greenIntValue = (int)(greenFloatValue*255.99999f);
		blueIntValue = (int)(blueFloatValue*255.99999f);
		
		redHexValue = [NSString stringWithFormat:@"%02x", redIntValue];
		greenHexValue = [NSString stringWithFormat:@"%02x", greenIntValue];
		blueHexValue = [NSString stringWithFormat:@"%02x", blueIntValue];
		
		return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
	}
	
	return nil;
}

+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex { 
	if ([hex hasPrefix:@"#"]) {
		hex = [hex substringWithRange:NSMakeRange(1, [hex length] - 1)];
	}
	
	unsigned int colorCode = 0;
	
	if (hex) {
		NSScanner *scanner = [NSScanner scannerWithString:hex];
		(void)[scanner scanHexInt:&colorCode];
	}
	
	return [NSColor colorWithDeviceRed:((colorCode>>16)&0xFF)/255.0 green:((colorCode>>8)&0xFF)/255.0 blue:((colorCode)&0xFF)/255.0 alpha:1.0];
}

+ (NSColor *)inboxCounterColor {
	static NSColor* counterColor = nil;
	if (counterColor == nil) {
		counterColor = [NSColor colorWithCalibratedRed:0.899 green:0.000 blue:0.077 alpha:1.000];
	}
	return counterColor;
}

+ (NSColor *)tableViewBackgroundColor {
	static NSColor* staticColor = nil;
	if (staticColor == nil) {
		staticColor = [NSColor colorWithCalibratedRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
	}
	return staticColor;
}

+ (NSColor *)separatorColor {
	static NSColor* staticColor = nil;
	if (staticColor == nil) {
		staticColor = [NSColor colorWithCalibratedRed:222.0f/255.0f green:230.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
	}
	return staticColor;
}

+ (NSColor *)bodyPreviewColor {
	static NSColor* staticColor = nil;
	if (staticColor == nil) {
		staticColor = [NSColor colorWithCalibratedRed:0.552 green:0.594 blue:0.629 alpha:1.000];

	}
	return staticColor;
}

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


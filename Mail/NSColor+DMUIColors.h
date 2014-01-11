//
//  NSColor+DMUIColors.h
//  DotMail
//
//  Created by Robert Widmann on 9/8/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@interface NSColor (DMUIColors)

- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;
+ (NSColor*)colorWithHexColorString:(NSString *)inColorString;
+ (NSColor *)inboxCounterColor;
+ (NSColor *)tableViewBackgroundColor;
+ (NSColor *)separatorColor;


+ (NSColor *)bodyPreviewColor;

- (NSColor *)lighterColor;
- (NSColor *)darkerColor;

@end

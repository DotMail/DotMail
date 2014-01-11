//
//  DMMenuItemCustomView.h
//  DotMail
//
//  Created by Robert Widmann on 7/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMMenuItemCustomView : NSView

+ (instancetype)customViewWithTitle:(NSString *)title;
+ (instancetype)customViewWithTitle:(NSString *)title tileColor:(NSColor *)color;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, strong) NSColor *tileColor;

@end

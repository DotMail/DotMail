//
//  DMLabel.h
//  DotMail
//
//  Created by Robert Widmann on 9/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

typedef NS_ENUM(NSInteger, DMLabelTruncationMode) {
	DMLabelTruncationModeNone, // does not truncate
	DMLabelTruncationModeStart, // truncates the beginning
	DMLabelTruncationModeMiddle, // truncates the middle
	DMLabelTruncationModeEnd // truncates the end
};

@interface DMLabel : NSView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSColor *textColor;
@property (nonatomic, strong) NSColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL drawsBackground;
@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, assign) BOOL wraps;
@property (nonatomic, assign) DMLabelTruncationMode truncationMode;

@end

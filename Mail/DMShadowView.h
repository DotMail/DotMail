//
//  DMShadowView.h
//  DotMail
//
//  Created by Robert Widmann on 4/21/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@interface DMShadowView : NSView

+ (instancetype)coloredShadowViewWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, assign) BOOL inverted;

@end

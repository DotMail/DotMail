//
//  DMFlatButton.h
//  DotMail
//
//  Created by Robert Widmann on 10/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLabel.h"

@interface DMFlatButton : NSButton

- (void)setVerticalPadding:(CGFloat)padding;

@property (nonatomic, strong, readonly) DMLabel *label;
@property (nonatomic, strong) NSColor *backgroundColor;

@end

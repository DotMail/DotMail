//
//  CFIToolbar.h
//  DotMail
//
//  Created by Robert Widmann on 7/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@interface DMToolbarView : NSView

- (void)setLeftButtonItem:(NSButton *)button;
- (void)setRightButtonItem:(NSButton *)button;

@end

@interface CFISendButtonCell : NSButtonCell

@end

@interface CFISaveButtonCell : NSButtonCell

@end
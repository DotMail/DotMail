//
//  DMSearchFieldCell.h
//  DotMail
//
//  Created by Robert Widmann on 11/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMSearchFieldCell : NSTextFieldCell <NSTextViewDelegate, NSLayoutManagerDelegate>

- (id)_fieldEditor;

@end

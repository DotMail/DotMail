//
//  CFISecureFormField.m
//  DotMail
//
//  Created by Robert Widmann on 7/25/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMSecureTextFieldCell.h"

@implementation DMSecureTextFieldCell

- (NSRect)drawingRectForBounds:(NSRect)theRect {
    // Get the parent's idea of where we should draw
    NSRect newRect = [super drawingRectForBounds:theRect];
    
    if (mIsEditingOrSelecting == NO) {
        // Get our ideal size for current text
        NSSize textSize = [self cellSizeForBounds:theRect];
        
        // Center that in the proposed rect
        CGFloat heightDelta = newRect.size.height - textSize.height;
        if (heightDelta > 0) {
            newRect.size.height -= heightDelta;
            newRect.origin.y += (heightDelta / 2);
        }
        
        // For some reason right aligned text doesn't work.  This section makes it work if set in IB.
        // HACK: using _cFlags isn't a great idea, but I couldn't find another way to find the alignment.
        // TODO: replace _cFlags usage if a better solution is found.
        CGFloat widthDelta = newRect.size.width - textSize.width;
        if (_cFlags.alignment == NSRightTextAlignment && widthDelta > 0) {
            newRect.size.width -= widthDelta;
            newRect.origin.x += widthDelta;
        }
        
    }
    
    return newRect;
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    aRect = [self drawingRectForBounds:aRect];
    mIsEditingOrSelecting = YES;
    [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
    mIsEditingOrSelecting = NO;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    aRect = [self drawingRectForBounds:aRect];
    mIsEditingOrSelecting = YES;
    [super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
    mIsEditingOrSelecting = NO;
}


- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
    // super would normally draw text at the top of the cell
    CGFloat offset = floor((NSHeight(frame) - (self.font.ascender - self.font.descender)-2) / 2);
    return NSInsetRect(frame, 0.0, offset);
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
    [super drawInteriorWithFrame:
     [self adjustedFrameToVerticallyCenterText:frame] inView:view];
}

@end
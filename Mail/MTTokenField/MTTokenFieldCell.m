//
//  MTTokenFieldCell.m
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTokenFieldCell.h"
#import "_MTTokenTextView.h"
#import "MTTokenField.h"
@implementation MTTokenFieldCell
@synthesize tokenizingCharacterSet= tokenizingCharacterSet_;
-(void)dealloc{
    [tokenizingCharacterSet_ release];
    [super dealloc];
}
- (void)selectWithFrame:(NSRect)aRect inView:(MTTokenField *)controlView editor:(_MTTokenTextView *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength{
	aRect = [self drawingRectForBounds:aRect];
    mIsEditingOrSelecting = YES;
    [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
    mIsEditingOrSelecting = NO;
	[textObj setTokenArray:[controlView tokenArray]];
    [textObj setSelectedRange:NSMakeRange([[textObj textStorage] length], 0)];
}

- (_MTTokenTextView *)fieldEditorForView:(NSView *)aControlView{
    static _MTTokenTextView * tokenTextView = nil;
    if (!tokenTextView){
        tokenTextView = [[_MTTokenTextView alloc] init];
        [tokenTextView setFieldEditor:YES];
    }
    return tokenTextView;
}

-(NSText*)setUpFieldEditorAttributes:(NSText*)textObj{
    id result =    [super setUpFieldEditorAttributes:textObj];
    [[result textStorage] setFont:[NSFont systemFontOfSize:14]];
    return result;
}

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
        
    }
    
    return newRect;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    aRect = [self drawingRectForBounds:aRect];
    mIsEditingOrSelecting = YES;
    [super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
    mIsEditingOrSelecting = NO;
}


- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
    // super would normally draw text at the top of the cell
    CGFloat offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])-6) / 2);
    return NSInsetRect(frame, 0.0, offset);
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[[NSColor whiteColor]set];
	NSRectFill(controlView.bounds);
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:cellFrame] inView:controlView];
}


@end

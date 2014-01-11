//
//  DMSearchTokenAttachmentCell.m
//  DotMail
//
//  Created by Robert Widmann on 11/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSearchTokenAttachmentCell.h"

@implementation DMSearchTokenAttachmentCell {
	NSRect _cellFrame;
}

- (id)init {
	self = [self initTextCell:@""];
	
	return self;
}

- (id)initTextCell:(NSString *)aString {
	self = [super initTextCell:aString];
	
	self.alignment = NSCenterTextAlignment;
	self.lineBreakMode = NSLineBreakByTruncatingTail;
	self.editable = YES;
	_cellFrame = CGRectNull;
	
	return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	_cellFrame = cellFrame;
	[self drawTokenWithFrame:cellFrame inView:controlView];
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawTokenWithFrame:(NSRect)rect inView:(NSView *)controlView {
	
}

- (BOOL)isPointInside:(NSPoint)point {
	CGRect frameRect = _cellFrame;
	if (!CGRectEqualToRect(_cellFrame, CGRectNull)) {
		frameRect = [self drawingRectForBounds:frameRect];
	}
	return NSPointInRect(point, frameRect);
}

@end

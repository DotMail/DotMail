//
//  DMSearchField.m
//  DotMail
//
//  Created by Robert Widmann on 7/5/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSearchField.h"
#import "DMSearchFieldCell.h"
#import "DMSearchTokenAttachment.h"
#import "DMSearchTokenAttachmentCell.h"

@interface DMSearchField ()
@end

@implementation DMSearchField {
	BOOL updatingCells;
	NSCell *_lastCell;
	void (^_cellUpdateBlock)(NSNotification *note);
}

- (NSText *)currentEditor {
	NSText *currentEditor = [super currentEditor];
	[currentEditor setDrawsBackground:YES];
	return currentEditor;
}

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];

	@weakify(self);
	_cellUpdateBlock = ^(NSNotification *note) {
		@strongify(self);
		if (!self->updatingCells) {
			if (self.window) {
				self->updatingCells = YES;
				NSText *currentEditor = [self currentEditor];
				NSRange selectedRange = (NSRange){ .location = 0, .length = self.attributedStringValue.length };
				if (currentEditor) {
					selectedRange = currentEditor.selectedRange;
				}
				[self validateEditing];
				NSAttributedString *copyString = self.attributedStringValue.copy;
				[copyString enumerateAttribute:NSAttachmentAttributeName inRange:selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
					
				}];
				[self setStringValue:@""];
				[self setAttributedStringValue:copyString];
				if (currentEditor) {
					[self.currentEditor setSelectedRange:selectedRange];
				}
				self->updatingCells = NO;
			}
		}
	};

	[NSNotificationCenter.defaultCenter addObserverForName:NSViewBoundsDidChangeNotification object:self queue:nil usingBlock:_cellUpdateBlock];
	[NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification object:self queue:nil usingBlock:_cellUpdateBlock];

	return self;
}

- (void)setSearchTerms:(NSArray *)searchTerms {
	NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc]init];
	for (DMSearchTokenAttachment *attachment in searchTerms) {
		if (attachment.kind == 0xb) {
			[attributedResult appendAttributedString:[[NSAttributedString alloc] initWithString:attachment.value]];
		} else {
			DMSearchTokenAttachment *att = [[DMSearchTokenAttachment alloc] init];
			[att setMaxWidth:CGRectGetWidth(self.bounds)];
			[att setControlSize:NSSmallControlSize];
			[att setTerm:attachment.value];
			[attributedResult appendAttributedString:[NSAttributedString attributedStringWithAttachment:att]];
		}
	}
	[self setAttributedStringValue:attributedResult];
	
}

- (void)setAttributedStringValue:(NSAttributedString *)obj {
	[super setAttributedStringValue:obj];
	_cellUpdateBlock(nil);
}

- (id)__fieldEditor {
	if (![self.cell respondsToSelector:@selector(_fieldEditor)]) {
		return nil;
	}
	return [(DMSearchFieldCell *)self.cell _fieldEditor];
}

- (void)updateTrackingAreas {
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:(NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved) owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	
}

- (void)mouseExited:(NSEvent *)theEvent {
	if (_lastCell == nil) {
		return;
	}
	[_lastCell setCellAttribute:NSCellHighlighted to:0];
	_lastCell = nil;
	[self setNeedsDisplay:YES];
}

@end


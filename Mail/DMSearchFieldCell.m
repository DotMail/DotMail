//
//  DMSearchFieldCell.m
//  DotMail
//
//  Created by Robert Widmann on 11/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSearchFieldCell.h"
#import "DMSearchTokenTextView.h"

@implementation DMSearchFieldCell {
	DMSearchTokenTextView *_searchFieldEditor;
}

- (id)_fieldEditor {
	if (_searchFieldEditor == nil) {
		_searchFieldEditor = [[DMSearchTokenTextView alloc] init];
		_searchFieldEditor.usesFontPanel = NO;
		_searchFieldEditor.fieldEditor = YES;
		_searchFieldEditor.delegate = self;
		_searchFieldEditor.drawsBackground = YES;
		_searchFieldEditor.backgroundColor = NSColor.whiteColor;
	}
	return _searchFieldEditor;
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj {
	NSTextView *fieldEditor = (NSTextView *)[super setUpFieldEditorAttributes:textObj];
	fieldEditor.layoutManager.delegate = self;
	return fieldEditor;
}

- (NSArray *)textView:(NSTextView *)view writablePasteboardTypesForCell:(id<NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex {
	return [DMSearchTokenTextView dmPasteboardTypes];
}

- (BOOL)textView:(NSTextView *)view writeCell:(id<NSTextAttachmentCell>)cell atIndex:(NSUInteger)charIndex toPasteboard:(NSPasteboard *)pboard type:(NSString *)type {
	if (![type isEqualToString:@"DMSearchTokenPasteboardType"]) {
		return NO;
	}
	
	[pboard setData:[NSKeyedArchiver archivedDataWithRootObject:[NSAttributedString attributedStringWithAttachment:[cell attachment]]] forType:type];
	return YES;
}

@end

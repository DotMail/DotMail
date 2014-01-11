//
//  DMPreferencesButton.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMPreferencesButton.h"



@interface DMPreferencesButton ()

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, strong) CALayer *selectionLayer;

@end

@implementation DMPreferencesButton

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	[self setWantsLayer:YES];
	[super setTitle:@""];
	self.buttonType = NSMomentaryChangeButton;
	self.bordered = NO;
	
	_titleTextField = [[NSTextField alloc]initWithFrame:self.bounds];
	_titleTextField.backgroundColor = NSColor.clearColor;
	_titleTextField.textColor = NSColor.whiteColor;
	[_titleTextField setAlignment:NSCenterTextAlignment];
	[_titleTextField setBordered:NO];
	[_titleTextField setFont:[NSFont fontWithName:@"HelveticaNeue" size:12.f]];
	[_titleTextField setBezeled:NO];
	[_titleTextField setFocusRingType:NSFocusRingTypeNone];
	[_titleTextField.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_titleTextField.cell setTruncatesLastVisibleLine:YES];
	[_titleTextField setEditable:NO];
	[self addSubview:_titleTextField];
	
	CGRect slice, remainder;
	CGRectDivide(self.bounds, &slice, &remainder, 2, CGRectMaxYEdge);
	
	_selectionLayer = [CALayer layer];
	_selectionLayer.backgroundColor = [NSColor.clearColor CGColor];
	_selectionLayer.frame = slice;
	[self.layer addSublayer:_selectionLayer];
	
	return self;
}

- (void)setTitle:(NSString *)aString {
	self.titleTextField.stringValue = aString ?: @"";
}

- (void)setSelectedPreferenceButton:(BOOL)selectedPreferenceButton {
	self.selectionLayer.backgroundColor = selectedPreferenceButton ? [NSColor.whiteColor CGColor] : [NSColor.clearColor CGColor];
}

@end

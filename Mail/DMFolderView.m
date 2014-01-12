//
//  DMFolderView.m
//  DotMail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMFolderView.h"

#import "NSColor+DMUIColors.h"
#import "NS(Attributed)String+Geometrics.h"

@interface DMFolderView ()

@property (nonatomic, assign) NSUInteger lastCount;
@property (nonatomic, strong) TUIButton *button;
@property (nonatomic, strong) TUIView *colorWell;
@property (nonatomic, strong) TUIView *underlineView;

@end

@implementation DMFolderView 

- (instancetype)init{
	self = [super initWithFrame:CGRectZero];
	
	_label = [[TUILabel alloc]initWithFrame:CGRectZero];
	[_label setFont:[NSFont fontWithName:@"HelveticaNeue" size:14.0f]];
	[_label setOpaque:NO];
	[_label setBackgroundColor:[NSColor clearColor]];
	[_label setUserInteractionEnabled:NO];
	[_label setAutoresizingMask:TUIViewAutoresizingFlexibleWidth];
	[self addSubview:_label];
	
	_underlineView = [[TUIView alloc]initWithFrame:CGRectZero];
	[_underlineView setBackgroundColor:[NSColor whiteColor]];
	[_underlineView setHidden:YES];
	[self addSubview:_underlineView];
	
	_labelColor = [NSColor whiteColor];
	_colorWell = [[TUIView alloc]initWithFrame:CGRectZero];
	[_colorWell setBackgroundColor:[NSColor whiteColor]];
	[self addSubview:_colorWell];
	
	_counterView = [[TUILabel alloc]initWithFrame:CGRectZero];
	[_counterView setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:10.0f]];
	[_counterView setTextColor:[NSColor colorWithCalibratedRed:0.909 green:0.000 blue:0.077 alpha:1.000]];
	[_counterView setOpaque:NO];
	[_counterView setAlignment:TUITextAlignmentRight];
	[_counterView setBackgroundColor:[NSColor clearColor]];
	[_counterView setUserInteractionEnabled:NO];
	[_counterView setAutoresizingMask:(TUIViewAutoresizingFlexibleTopMargin | TUIViewAutoresizingFlexibleLeftMargin)];
	[self addSubview:_counterView];

	_button = [[TUIButton alloc]initWithFrame:CGRectZero];
	[_button setBackgroundColor:[NSColor clearColor]];
	[_button addTarget:self action:@selector(clicked:) forControlEvents:TUIControlEventMouseUpInside];
	[self addSubview:_button];

	return self;
}

- (void)dealloc {
	self.button = nil;
	[NSNotificationCenter.defaultCenter removeObserver:self];
}


- (void)setSelection:(PSTFolderType)selection {
	_selection = selection;
	if (selection == PSTFolderTypeNextSteps) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCount) name:PSTMailAccountActionStepCountUpdated object:self.account.mainAccount];
	}
	[self _update];
}

- (void)setAccount:(PSTAccountController *)account {
	_account = account;
	[self _update];
}

- (void)setPath:(NSString *)path {
	_path = path;
	[self _update];
}

- (NSString *)title {
	return DMFolderTitleFromSelection(self.selection, self.path);
}

- (void)setLabelColor:(NSColor *)labelColor {
	_labelColor = labelColor;
	[self.colorWell setBackgroundColor:labelColor];
	[self.colorWell setNeedsDisplay];
}

- (void)setLevel:(NSUInteger)level {
	_level = level;
	switch (level) {
		case 0:
			[self.label setFont:[NSFont fontWithName:@"HelveticaNeue" size:14.0f]];
			break;
		case 1:
			[self.label setFont:[NSFont fontWithName:@"HelveticaNeue" size:12.0f]];
			break;
		default:
			break;
	}
}

- (void)setSelected:(BOOL)selected {
	if (_selected == selected) {
		return;
	} else {
		_selected = selected;
		[self _update];
		[self.underlineView setHidden:!selected];
	}

}

- (void)_update {
	[self _updateLabel];
	[self updateCount];
}

- (void)updateCount {
	[self _updateCount];
	[self setNeedsLayout];
}

- (void)_updateLabel {
	if (self.selected) {
		[self.label setTextColor:[NSColor whiteColor]];
		[_label setFont:[NSFont fontWithName:@"HelveticaNeue-Medium" size:(self.level == 0) ? 14.0f : 12.0f]];
	} else {
		[self.label setTextColor:[NSColor colorWithCalibratedRed:0.388 green:0.407 blue:0.415 alpha:1.000]];
		[_label setFont:[NSFont fontWithName:@"HelveticaNeue" size:(self.level == 0) ? 14.0f : 12.0f]];
	}
	[self.label setText:DMFolderTitleFromSelection(self.selection, self.path)];
	[self setNeedsDisplay];
}

static NSString * DMFolderTitleFromSelection(PSTFolderType selection, NSString *path) {
	NSString* result = nil;
	switch (selection) {
		case PSTFolderTypeNone:
			result = @"";
			break;
		case PSTFolderTypeInbox:
			result = @"Inbox";
			break;
		case PSTFolderTypeNextSteps:
			result = @"Next Steps";
			break;
		case PSTFolderTypeStarred:
			result = @"Favorites";
			break;
		case PSTFolderTypeDrafts:
			result = @"Drafts";
			break;
		case PSTFolderTypeSent:
			result = @"Sent";
			break;
		case PSTFolderTypeTrash:
			result = @"Trash";
			break;
		case PSTFolderTypeAllMail:
			result = @"All Mail";
			break;
		case PSTFolderTypeSpam:
			result = @"Spam";
			break;
		case PSTFolderTypeLabel:
			result = (path != nil ? path : @"");
			break;
		default:
			result = @"";
			break;
	}
	return result;
}

- (void)_updateCount {
	if (self.selection >= PSTFolderTypeLabel) {
		self.lastCount = 0;
		return;
	}
	switch (self.selection) {
		case PSTFolderTypeInbox:
			self.lastCount = [self.account unreadCountForFolder:self.selection];
			break;
		case PSTFolderTypeNextSteps:
		case PSTFolderTypeStarred:
		case PSTFolderTypeDrafts:
			self.lastCount = [self.account countForFolder:self.selection];
			break;
		default:
			break;
	}
}

- (void)setLastCount:(NSUInteger)lastCount {
	if (lastCount == 0) {
		[self.counterView setAlpha:0.f];
	} else {
		[TUIView animateWithDuration:0.3 animations:^{
			[self.counterView setAlpha:1.f];
		}];
		[self.counterView setText:[NSString stringWithFormat:@"%lu", lastCount]];
	}
	_lastCount = lastCount;
}

- (void)clicked:(id)sender {
	if (self.selection == PSTFolderTypeLabel && self.path == nil) {
		return;
	}
	if (self.isSelected == NO) {
		[self.actionDelegate folderViewDidBecomeSelected:self];
	} else {
		[self.actionDelegate folderViewWantsRefresh:self];
	}
}

- (void)layoutSubviews {
	CGRect labelFrame = self.bounds;
	if (self.level == 0) {
		labelFrame.origin.x += 20;
		labelFrame.size.width -= 20;
	} else {
		CGFloat y = CGRectGetMaxY(labelFrame);
		if (y != 0) y /= 2;
		[self.colorWell setFrame:CGRectMake(29, y - 4, 10, 10)];
		labelFrame.origin.x += 44;
		labelFrame.size.width -= 44;
	}
	[self.label setFrame:labelFrame];
	
	CGRect underlineFrame = labelFrame;
	underlineFrame.size.height = 1;
	underlineFrame.size.width = [self.label.text sizeForWidth:labelFrame.size.width height:labelFrame.size.height font:self.label.font].width;
	if (self.level == 0) {
		CGFloat x = CGRectGetMinX(labelFrame);
		if (x != 0) x /= 2;
		underlineFrame.origin.y += 4;
		underlineFrame.size.width -= x;
	} else {
		CGFloat x = CGRectGetMinX(labelFrame);
		if (x != 0) x /= 2;
		underlineFrame.origin.y += 2;
		underlineFrame.size.width -= (x - 14);
	}
	[self.underlineView setFrame:underlineFrame];
	
	CGRect counterFrame = self.bounds;
	counterFrame.origin.x -= 6;
	counterFrame.size.width -= 6;
	[self.counterView setFrame:counterFrame];
	
	[self.button setFrame:self.bounds];
}

- (NSString *)description {
	if (self.label.text.length != 0) {
		return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, self.label.text];
	} else if (self.path.length != 0) {
		return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, self.path];
	} else {
		return [NSString stringWithFormat:@"<%@: %p %@>", [self class], self, @"(none)"];
	}
	return nil;
}

@end

@implementation DMLabelSeparatorView

- (void)_updateLabel {
	[super _updateLabel];
	[self.label setText:@"____"];
	[self setNeedsDisplay];
}

- (BOOL)isUserInteractionEnabled {
	return NO;
}

@end

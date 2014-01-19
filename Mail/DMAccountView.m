//
//  DMAccountView.m
//  DotMail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAccountView.h"


@interface DMAccountView ()

@property (nonatomic, assign) NSUInteger lastCount;
@property (nonatomic, strong) TUILabel *label;

@end

@implementation DMAccountView

- (instancetype)init {
	if (self = [super initWithFrame:CGRectZero]) {
		[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.142 green:0.157 blue:0.169 alpha:1.000]];
		self.label = [[TUILabel alloc]initWithFrame:CGRectZero];
		[self.label setOpaque:NO];
		[self.label setBackgroundColor:[NSColor clearColor]];
		[self.label setUserInteractionEnabled:NO];
		[self.label setAutoresizingMask:TUIViewAutoresizingFlexibleSize];
		[self setSelected:NO];
		[self addSubview:self.label];
	}
	return self;
}

- (void)setAccount:(PSTAccountController *)account {
	_account = account;
	[self _update];
}

- (void)updateCount {
	[self _updateCount];
	[self setNeedsLayout];
}

- (void)_updateCount { }

- (void)setSelected:(BOOL)selected {
	self.backgroundColor = selected ? [NSColor colorWithCalibratedRed:0.109 green:0.120 blue:0.129 alpha:1.000] : [NSColor colorWithCalibratedRed:0.142 green:0.157 blue:0.169 alpha:1.000];
}

- (void)_update {
	[self _updateCount];
	[self.label setAlignment:TUITextAlignmentCenter];
	[self.label setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
	[self.label setTextColor:[NSColor colorWithCalibratedRed:0.330 green:0.352 blue:0.371 alpha:1.000]];
	[self.label setText:[self _titleString]];
	[self.label setFrame:self.bounds];
}


- (NSString *)_titleString {
	if (self.account.accounts.count >= 2) {
		return @"Unified Inbox";
	} else {
		return self.account.email;
	}
	return nil;
}

- (void)mouseDown:(NSEvent *)theEvent {
	if (self.isSelected) {
		[self.actionDelegate accountViewWantsRefresh:self];
	} else {
		[self.actionDelegate accountViewDidBecomeSelected:self];
	}
	[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.109 green:0.120 blue:0.129 alpha:1.000]];
}

- (void)mouseUp:(NSEvent *)theEvent {
//	[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.142 green:0.157 blue:0.169 alpha:1.000]];
}

- (void)mouseDown:(NSEvent *)event onSubview:(TUIView *)subview {
	if (self.isSelected) {
		[self.actionDelegate accountViewWantsRefresh:self];
	} else {
		[self.actionDelegate accountViewDidBecomeSelected:self];
	}
	[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.109 green:0.120 blue:0.129 alpha:1.000]];
}

- (void)mouseUp:(NSEvent *)event fromSubview:(TUIView *)subview {
	[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.142 green:0.157 blue:0.169 alpha:1.000]];
}

@end



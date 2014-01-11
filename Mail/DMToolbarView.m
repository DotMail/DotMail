//
//  CFIToolbar.m
//  DotMail
//
//  Created by Robert Widmann on 7/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMToolbarView.h"

@implementation DMToolbarView

- (instancetype)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code here.
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithCalibratedRed:23.0f/255.0f green:27.0f/255.0f blue:31.0f/255.0f alpha:1.0f]set];
	NSRectFill(NSMakeRect(0, 4, NSWidth(self.bounds), NSHeight(self.bounds)));
	NSSize size = CGSizeMake(NSWidth(self.bounds), 8.0f);
	NSImage *bigImage = [[NSImage alloc] initWithSize:size];
	[bigImage lockFocus];
	[[NSColor colorWithPatternImage:[NSImage imageNamed:@"sendMarquee.png"]] set];
	NSRectFill(NSMakeRect(0, 0, NSWidth(self.bounds), 4.0f));
	[bigImage unlockFocus];
	[bigImage drawInRect:NSMakeRect(0, 0, NSWidth(self.bounds), 8.0f) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];

}

- (void)setLeftButtonItem:(NSButton *)button {
	[button.cell setImagePosition:NSImageOnly];
	button.autoresizingMask = NSViewMaxXMargin;
	NSRect buttonFrame = button.frame;
	buttonFrame.origin.x = 15;
	buttonFrame.origin.y = 12;
	button.frame = buttonFrame;
	[self addSubview:button];
}

- (void)setRightButtonItem:(NSButton *)button {
	[button.cell setImagePosition:NSImageOnly];
	button.autoresizingMask = NSViewMinXMargin;
	NSRect buttonFrame = button.frame;
	buttonFrame.origin.x = NSWidth(self.bounds) - 100;
	buttonFrame.origin.y = 12;
	button.frame = buttonFrame;
	[self addSubview:button];
}

@end

@implementation CFISendButtonCell

- (void)awakeFromNib {
	[self setBackgroundColor:[NSColor colorWithCalibratedRed:234.0f/255.0f green:21.0f/255.0f blue:5.0f/255.0f alpha:1.0f]];
	NSColor *txtColor = [NSColor whiteColor];
	NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
	NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"Send" attributes:txtDict];
	[self setAttributedStringValue:attrStr];
}

@end

@implementation CFISaveButtonCell

- (void)awakeFromNib {
	[self setBackgroundColor:[NSColor blackColor]];
}

@end

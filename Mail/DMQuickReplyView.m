//
//  DMQuickReplyView.m
//  DotMail
//
//  Created by Robert Widmann on 4/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMQuickReplyView.h"

@interface DMQuickReplyView ()

@property (nonatomic, strong) NSButton *sendButton;
@property (nonatomic, strong) NSButton *cancelButton;
@property (nonatomic, strong) NSTextField *toLabel;

@property (nonatomic, strong) NSTextView *editingTextView;

@end

@implementation DMQuickReplyView

- (instancetype)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	_cancelButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(frame) - 40, .origin.y = NSHeight(frame) - 30, .size.height = 12, .size.width = 12 }];
	_cancelButton.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin;
	[_cancelButton setAction:@selector(_cancelQuickReply)];
	_cancelButton.buttonType = NSMomentaryPushInButton;
	_cancelButton.bordered = NO;
	[_cancelButton setImage:[NSImage imageNamed:@"QuickReplyCancel.png"]];
	[self addSubview:_cancelButton];
	
	_toLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(frame) - 190, .origin.y = NSHeight(frame) - 42, .size.width = 150, .size.height = 30 }];
	_toLabel.backgroundColor = [NSColor colorWithCalibratedRed:0.966 green:0.975 blue:0.975 alpha:1.000];
	_toLabel.autoresizingMask = NSViewWidthSizable | NSViewMaxXMargin;
	[_toLabel setAlignment:NSLeftTextAlignment];
	[_toLabel setStringValue:@"To: widmannrobert@gmail.com"];
	[_toLabel setTextColor:[NSColor colorWithCalibratedWhite:0.318 alpha:1.000]];
	[_toLabel setBordered:NO];
	[_toLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:12.f]];
	[_toLabel setBezeled:NO];
	[_toLabel setFocusRingType:NSFocusRingTypeNone];
	[_toLabel.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_toLabel.cell setTruncatesLastVisibleLine:YES];
	[_toLabel setEditable:NO];
	[self addSubview:_toLabel];
	
	self.wantsLayer = YES;
	_editingTextView = [[NSTextView alloc]initWithFrame:CGRectOffset(CGRectInset(self.bounds, 45, 20), 45, -20)];
	_editingTextView.backgroundColor = [NSColor colorWithCalibratedRed:0.966 green:0.975 blue:0.975 alpha:1.000];
	_editingTextView.autoresizingMask = (NSViewMaxXMargin | NSViewWidthSizable | NSViewMinYMargin);

	[self addSubview:_editingTextView];
	
	_sendButton = [[NSButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(frame) - 140, .size.height = 30, .size.width = 100 }];
	_sendButton.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin;
//	[_sendButton setAction:@selector(showActivityPopover:)];
	_sendButton.buttonType = NSMomentaryPushInButton;
	_sendButton.bordered = NO;
	[_sendButton setImage:[NSImage imageNamed:@"SendBtn.png"]];
	[self addSubview:_sendButton];
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:0.966 green:0.975 blue:0.975 alpha:1.000]set];
	NSRectFill(dirtyRect);
	// Drawing code here.
	NSGraphicsContext *context = [NSGraphicsContext currentContext];
	[context saveGraphicsState];
	
	[context setCompositingOperation:NSCompositePlusDarker];
	
	NSBezierPath *path = [NSBezierPath
						  bezierPathWithRoundedRect:[self bounds]
						  xRadius:2.0f
						  yRadius:2.0f];
	
	[[NSColor whiteColor] setStroke];
	
	NSShadow * shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0f alpha:0.25f]];
	[shadow setShadowBlurRadius:3.0f];
	[shadow set];
	
	[path stroke];
	
	[context restoreGraphicsState];
	[super drawRect:dirtyRect];
}

- (void)_cancelQuickReply {
	[self.delegate cancelQuickReply];
}

- (void)focusTextView:(BOOL)isQuickReplying {
	[self.editingTextView setHidden:!isQuickReplying];
	[self.editingTextView setEditable:isQuickReplying];
	if (isQuickReplying) {
		[self.window makeFirstResponder:self.editingTextView];
	} else {
		[self.editingTextView setString:@""];
		[self.window makeFirstResponder:nil];
	}
}

@end

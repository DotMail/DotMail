//
//  DMComposeTopView.m
//  DotMail
//
//  Created by Robert Widmann on 4/25/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMComposeView.h"
#import "DMConversationHeaderView.h"
#import "DMRoundedImageView.h"

#import <TwUI/TUICGAdditions.h>

@interface PSTConversationHeaderView ()
@property (nonatomic, assign) BOOL quickReplying;
@property (nonatomic, strong) DMComposeView *quickreplyCoverView;

@property (nonatomic, strong) NSTextField *subjectField;
@property (nonatomic, strong) NSTextField *subtitleField;
@property (nonatomic, strong) NSImageView *iconImageView;

@property (nonatomic, strong) NSButton *replyButton;
@property (nonatomic, strong) NSButton *starButton;
@property (nonatomic, strong) NSButton *actionstepDropdown;

@end

@implementation PSTConversationHeaderView

- (instancetype)initWithFrame:(NSRect)frameRect  {
	self = [super initWithFrame:frameRect];
	
	self.quickReplying = YES;
	
	_subtitleField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_subtitleField setAlignment:NSLeftTextAlignment];
	[_subtitleField setTextColor:[NSColor colorWithCalibratedWhite:0.318 alpha:1.000]];
	[_subtitleField setBordered:NO];
	[_subtitleField setFont:[NSFont fontWithName:@"HelveticaNeue" size:13.f]];
	[_subtitleField setBezeled:NO];
	[_subtitleField setFocusRingType:NSFocusRingTypeNone];
	[_subtitleField.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_subtitleField.cell setTruncatesLastVisibleLine:YES];
	[_subtitleField setEditable:NO];
	[self addSubview:_subtitleField];
	
	_subjectField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_subjectField setAlignment:NSLeftTextAlignment];
	[_subjectField setBordered:NO];
	[_subjectField setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:30.f]];
	[_subjectField setBezeled:NO];
	[_subjectField setFocusRingType:NSFocusRingTypeNone];
	[_subjectField.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_subjectField.cell setTruncatesLastVisibleLine:YES];
	[_subjectField setEditable:NO];
	[self addSubview:_subjectField];
	
	_replyButton = [[NSButton alloc]initWithFrame:NSZeroRect];
	[_replyButton setAction:@selector(_quickReply)];
	[_replyButton setTarget:self];
	_replyButton.buttonType = NSMomentaryPushInButton;
	_replyButton.bordered = NO;
	[_replyButton setImage:[NSImage imageNamed:@"ReplyButton.png"]];
	[self addSubview:_replyButton];
	
	_starButton = [[NSButton alloc]initWithFrame:NSZeroRect];
//	[_starButton setAction:@selector(showActivityPopover:)];
	_starButton.buttonType = NSMomentaryPushInButton;
	_starButton.bordered = NO;
	[_starButton setImage:[NSImage imageNamed:@"BodyStar.png"]];
	[self addSubview:_starButton];
	
	_actionstepDropdown = [[NSButton alloc]initWithFrame:NSZeroRect];
//	[_actionstepDropdown setAction:@selector(showActivityPopover:)];
	_actionstepDropdown.buttonType = NSMomentaryPushInButton;
	_actionstepDropdown.bordered = NO;
	[_actionstepDropdown setImage:[NSImage imageNamed:@"BodyNextStep.png"]];
	[self addSubview:_actionstepDropdown];
	
	_iconImageView = [[DMRoundedImageView alloc]initWithFrame:NSZeroRect];
	[self addSubview:_iconImageView];
	
	_quickreplyCoverView = [[DMComposeView alloc]initWithFrame:NSZeroRect];
	[self addSubview:_quickreplyCoverView];
	
	[self.subjectField setFrame:(NSRect){ .origin.x = 85, .origin.y = 34, .size.width = NSWidth(self.frame) - 185, .size.height = 38 }];
	[self.iconImageView setFrame:(NSRect){ .origin.x = 25, .origin.y = 20, .size.width = 50, .size.height = 50 }];
	[self.subtitleField setFrame:(NSRect){ .origin.x = 85, .origin.y = 20, .size.width = NSWidth(self.frame) - 185, .size.height = 20 }];
		
	[self.iconImageView setAlphaValue:0];
	[self.replyButton setAlphaValue:0];
	[self.starButton setAlphaValue:0];
	[self.actionstepDropdown setAlphaValue:0];
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_updateSenderImageView) name:PSTAvatarImageManagerDidUpdateNotification object:nil];

	return self;
}

- (void)_updateSenderImageView {
	[self.iconImageView setImage:self.conversation.iconImage];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	CGRect b = self.bounds;
	CGContextRef ctx = TUIGraphicsGetCurrentContext();
	
	CGFloat minx = CGRectGetMinX(b);
	CGFloat maxy = CGRectGetMaxY(b) + 1;

	CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
	CGContextFillRect(ctx, b);
	
	[[NSColor colorWithCalibratedRed:222.0f / 255.0f green:230.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f] drawSwatchInRect:NSMakeRect(0, 0, NSWidth(dirtyRect), 1.0f)];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, minx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, maxy);
	CGPathCloseSubpath(path);
	CGPathRelease(path);
	
	NSImage *bigImage = [[NSImage alloc] initWithSize:CGSizeMake(NSWidth(self.bounds), 8.0f)];
	[bigImage lockFocus];
	[[NSColor colorWithPatternImage:[NSImage imageNamed:@"sendMarquee.png"]]set];
	NSRectFill(NSMakeRect(0, 0, NSWidth(self.bounds), 4.0f));
	[bigImage unlockFocus];    
	[bigImage drawInRect:NSMakeRect(0, 1, NSWidth(self.bounds), 8.0f) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

- (void)setConversation:(PSTConversation *)conversation {
	self.quickReplying = YES;
	if (conversation == nil) {
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[[NSAnimationContext currentContext]setCompletionHandler:^{
			[self.iconImageView setImage:nil];
		}];
		[[self.quickreplyCoverView animator] setAlphaValue:1];
		[[self.iconImageView animator] setAlphaValue:0];
		[[self.replyButton animator] setAlphaValue:0];
		[[self.starButton animator] setAlphaValue:0];
		[[self.actionstepDropdown animator] setAlphaValue:0];
		[NSAnimationContext endGrouping];
		[self.subjectField setStringValue:@""];
		[self.subtitleField setStringValue:@""];
		_conversation = conversation;
		return;
	} else if (_conversation == nil && conversation != nil) {
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[[self.iconImageView animator] setAlphaValue:1];
		[[self.replyButton animator] setAlphaValue:1];
		[[self.starButton animator] setAlphaValue:1];
		[[self.quickreplyCoverView animator] setAlphaValue:1];
		[[self.actionstepDropdown animator] setAlphaValue:1];
		[NSAnimationContext endGrouping];
	} else {
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[[self.quickreplyCoverView animator] setAlphaValue:1];
		[NSAnimationContext endGrouping];
	}
	[self.subjectField setStringValue:(conversation.subject ? conversation.subject : @"")];
	[self.iconImageView setImage:conversation.iconImage];
	[self.subtitleField setAttributedStringValue:subtitleStringFromConversation(conversation)];
	[self setNeedsDisplay:YES];
	_conversation = conversation;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	
	[self.subjectField setFrame:(NSRect){ .origin.x = 85, .origin.y = 34, .size.width = NSWidth(self.frame) - 185, .size.height = 38 }];
	[self.iconImageView setFrame:(NSRect){ .origin.x = 25, .origin.y = 20, .size.width = 50, .size.height = 50 }];
	[self.subtitleField setFrame:(NSRect){ .origin.x = 85, .origin.y = 20, .size.width = NSWidth(self.frame) - 185, .size.height = 20 }];
	[self.actionstepDropdown setFrame:(NSRect){ .origin.x = NSWidth(self.frame) - 34, .origin.y = 52, .size.height = 15, .size.width = 16 }];
	[self.starButton setFrame:(NSRect){ .origin.x = NSWidth(self.frame) - 60, .origin.y = 52, .size.height = 15, .size.width = 16 }];
	[self.replyButton setFrame:(NSRect){ .origin.x = NSWidth(self.frame) - 86, .origin.y = 52, .size.height = 15, .size.width = 16 }];
	[self.quickreplyCoverView setFrame:(NSRect){ .origin.y = 1, .size.width = NSWidth(self.frame), .size.height = 8 }];
}

- (void)_quickReply {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.2];
	[[self.quickreplyCoverView animator] setAlphaValue:self.quickReplying ? 0 : 1];
	[NSAnimationContext endGrouping];

	[self.delegate toggleQuickReply:self.quickReplying];
	
	self.quickReplying = !self.quickReplying;
}

static NSAttributedString *subtitleStringFromConversation(PSTConversation *conversation) {
	NSString *senderName = [conversation.cache.senders[0] displayName];
	if (senderName == nil) {
		senderName = [conversation.cache.senders[0] mailbox];
	}
	
	if (conversation.cache.recipients.count <= 1) {
		NSString *subtitle = [NSString stringWithFormat:@"%@ to %@", senderName, conversation.account.email];
		NSMutableAttributedString *retVal = [[NSMutableAttributedString alloc]initWithString:subtitle];
		[retVal addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.128 green:0.433 blue:0.686 alpha:1.000] range:NSMakeRange(0, senderName.length)];
		[retVal addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13.f] range:NSMakeRange(0, senderName.length)];
		return retVal;
	} else {
//		return [NSString stringWithFormat:@"%@ to %@ and %lu others", senderName, conversation.account.name, (conversation.cache.recipients.count - 1)];
	}
	return [[NSAttributedString alloc]initWithString:@""];
}

@end

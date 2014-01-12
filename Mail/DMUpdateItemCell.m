//
//  DMUpdateItemCell.m
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMUpdateItemCell.h"
#import "NSColor+DMUIColors.h"

@interface DMUpdateItemCell ()
@property (nonatomic, strong) TUITextRenderer *descriptionRenderer;
@property (nonatomic, strong) TUIImageView *actionStepImageView;
@end

@implementation DMUpdateItemCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(TUITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super init];
	
	self.descriptionRenderer = [[TUITextRenderer alloc]init];
	self.textRenderers = @[self.descriptionRenderer];
	
	self.actionStepImageView = [[TUIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
	self.actionStepImageView.backgroundColor = NSColor.clearColor;
	[self addSubview:self.actionStepImageView];

	return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	CGRect b = self.bounds;
	CGContextRef ctx = TUIGraphicsGetCurrentContext();

	CGFloat minx = CGRectGetMinX(b), maxx = CGRectGetMaxX(b);
	CGFloat miny = CGRectGetMinY(b);
	
	//top to bottom
	CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1);
	CGContextFillRect(ctx, b);

	CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithCalibratedRed:222.0f/255.0f green:230.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor);
	CGContextBeginPath (ctx);
	CGContextMoveToPoint(ctx, minx, miny);
	CGContextAddLineToPoint(ctx, maxx, miny);
	CGContextStrokePath(ctx);
	

	[self.descriptionRenderer setFrame:[self centeredTitleRect:b withTitleString:self.descriptionRenderer.attributedString]];
	[self.descriptionRenderer draw];
	
}

- (CGRect)centeredTitleRect:(CGRect)rect withTitleString:(NSAttributedString *)titleString {
	CGRect descriptionRendererFrame = self.bounds;
	
	if (titleString.length >= 40) {
		descriptionRendererFrame.origin.x += 48;
		descriptionRendererFrame.size.width -= 48;
		descriptionRendererFrame.size.height -= 3;
		descriptionRendererFrame.origin.y -= 3;
	}
	else {
		descriptionRendererFrame.origin.x += 48;
		descriptionRendererFrame.size.width -= 48;
		descriptionRendererFrame.size.height -= 7;
		descriptionRendererFrame.origin.y -= 7;
	}
	return descriptionRendererFrame;
}

#pragma mark - Overrides

- (void)setUpdateItemDescription:(NSString *)newUpdateItemDescription {
	
	if ([newUpdateItemDescription rangeOfString:@"[1]"].location != NSNotFound) {
		[self.actionStepImageView setImage:[NSImage imageNamed:@"ActionStepOneHover.png"]];
		_updateItemDescription = [[newUpdateItemDescription stringByTrimmingLeadingWhitespace]substringFromIndex:4];
	}
	if ([newUpdateItemDescription rangeOfString:@"[2]"].location != NSNotFound) {
		[self.actionStepImageView setImage:[NSImage imageNamed:@"ActionStepTwoHover.png"]];
		_updateItemDescription = [[newUpdateItemDescription stringByTrimmingLeadingWhitespace]substringFromIndex:4];
	}
	if ([newUpdateItemDescription rangeOfString:@"[3]"].location != NSNotFound) {
		[self.actionStepImageView setImage:[NSImage imageNamed:@"ActionStepThreeHover.png"]];
		_updateItemDescription = [[newUpdateItemDescription stringByTrimmingLeadingWhitespace]substringFromIndex:4];
	}
	TUIAttributedString *attributedItemDescription = [TUIAttributedString stringWithString:_updateItemDescription];
	[attributedItemDescription setFont:[NSFont fontWithName:@"HelveticaNeue" size:12]];
	
	[self.descriptionRenderer setAttributedString:attributedItemDescription];
}

@end

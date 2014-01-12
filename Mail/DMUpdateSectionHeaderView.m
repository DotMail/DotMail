//
//  DMUpdateSectionHeaderView.m
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMUpdateSectionHeaderView.h"
#import "NSColor+DMUIColors.h"

@interface DMUpdateSectionHeaderView ()

@property (nonatomic, strong) TUITextRenderer *versionRenderer;

@end

@implementation DMUpdateSectionHeaderView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
		
	_versionRenderer = [[TUITextRenderer alloc]init];
	self.textRenderers = @[ self.versionRenderer ];
		
	return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	CGRect b = self.bounds;

	[[NSColor blackColor]set];
	NSRectFill(rect);

	CGRect versionRendererFrame = b;
	versionRendererFrame.size.width -= 10;
	versionRendererFrame.origin.x += 10;
	versionRendererFrame.origin.y -= 4;
	
	[self.versionRenderer setFrame:versionRendererFrame];
	[self.versionRenderer draw];
}

#pragma mark - Overrides

- (void)setVersion:(NSString *)newVersion {
	_version = newVersion;
	TUIAttributedString *attributedVersion = [TUIAttributedString stringWithString:newVersion];
	[attributedVersion setFont:[NSFont fontWithName:@"HelveticaNeue" size:12]];
	[attributedVersion setColor:[NSColor colorWithCalibratedRed:0.552 green:0.594 blue:0.629 alpha:1.000]];
	[self.versionRenderer setAttributedString:attributedVersion];
}
	
@end

//
//  DMWindowErrorBanner.m
//  DotMail
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMWindowErrorBanner.h"
#import <Puissant/PSTConstants.h>

@interface DMWindowErrorBanner ()

@property (nonatomic, strong) NSTextField *warningLabel;

@end

@implementation DMWindowErrorBanner

- (instancetype)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	
	_warningLabel = [[NSTextField alloc]initWithFrame:self.bounds];
	_warningLabel.autoresizingMask = kPSTAutoresizingMaskAll;
	[_warningLabel setAlignment:NSCenterTextAlignment];
	[_warningLabel setTextColor:NSColor.whiteColor];
	[_warningLabel setBackgroundColor:NSColor.clearColor];
	[_warningLabel setBordered:NO];
	[_warningLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:14.f]];
	[_warningLabel setBezeled:NO];
	[_warningLabel setFocusRingType:NSFocusRingTypeNone];
	[_warningLabel.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_warningLabel.cell setTruncatesLastVisibleLine:YES];
	[_warningLabel setEditable:NO];
	[self addSubview:_warningLabel];
	

	self.backgroundColor = NSColor.redColor;
	
	return self;
}

- (void)setError:(NSError *)error {
	[self.warningLabel setStringValue:error.userInfo[NSLocalizedFailureReasonErrorKey]];
}

@end

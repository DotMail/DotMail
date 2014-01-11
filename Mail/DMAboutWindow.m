//
//  DMAboutWindow.m
//  DotMail
//
//  Created by Robert Widmann on 11/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAboutWindow.h"
#import "DMColoredView.h"

@implementation DMAboutWindow

- (void)awakeFromNib {
	
	self.titleBarStartColor = NSColor.whiteColor;
	self.titleBarEndColor = NSColor.whiteColor;
	self.inactiveTitleBarEndColor = NSColor.whiteColor;
	self.inactiveTitleBarStartColor = NSColor.whiteColor;
	self.baselineSeparatorColor = NSColor.whiteColor;
	self.inactiveBaselineSeparatorColor = NSColor.whiteColor;
	
	[self center];

}

@end

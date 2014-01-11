//
//  DMAdvancedPreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAdvancedPreferencesViewController.h"
#import "DMColoredView.h"

static CGSize const kPreferencePaneContentSize = (CGSize){ 500, 490 };

@interface DMAdvancedPreferencesViewController ()

@end

@implementation DMAdvancedPreferencesViewController

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	self.view = view;
}

- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"Advanced";
}

@end
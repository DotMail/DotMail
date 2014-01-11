//
//  DMCloudPreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 8/4/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMCloudPreferencesViewController.h"
#import "DMColoredView.h"

static CGSize const kPreferencePaneContentSize = (CGSize){ 500, 350 };

@interface DMCloudPreferencesViewController ()

@end

@implementation DMCloudPreferencesViewController

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	self.view = view;
}

- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"Cloud";
}

@end
//
//  DMAliasesPreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAliasesPreferencesViewController.h"
#import "DMColoredView.h"
#import "DMLayeredScrollView.h"

static CGSize const kPreferencePaneContentSize = (CGSize){ 500, 250 };

@interface DMAliasesPreferencesViewController ()

@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSScrollView *scrollView;

@end

@implementation DMAliasesPreferencesViewController

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	NSSize contentSize = [NSScrollView contentSizeForFrameSize:view.bounds.size hasHorizontalScroller:YES hasVerticalScroller:NO borderType:NSGrooveBorder];
	NSTableColumn *column = [[NSTableColumn alloc]init];
	[column setWidth:contentSize.width];
	[column setEditable:NO];
	[column.dataCell setFont:[NSFont fontWithName:@"Helvetica" size:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	self.tableView = [[NSTableView alloc]initWithFrame:view.bounds];
	self.tableView.autoresizingMask = NSViewWidthSizable;
	[self.tableView addTableColumn:column];
	[self.tableView setGridStyleMask:NSTableViewGridNone];
	[self.tableView setCornerView:nil];
	[self.tableView setHeaderView:nil];
	[self.tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setTarget:self];
	//	[self.tableView setAction:@selector(acceptCompletion)];
	[self.tableView setBackgroundColor:NSColor.clearColor];
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.tableView.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways owner:nil userInfo:nil];
	[self.tableView addTrackingArea:trackingArea];
	DMColoredView *coloredView = [[DMColoredView alloc]init];
	[coloredView setBackgroundColor:NSColor.whiteColor];
	coloredView.layer.cornerRadius = 0xf;
	DMLayeredScrollView *scrollView = [[DMLayeredScrollView alloc]initWithFrame:self.tableView.bounds];
	scrollView.drawsBackground = NO;
	scrollView.borderType = NSNoBorder;
	scrollView.hasVerticalScroller = YES;
	scrollView.autoresizingMask = 0x12;
	scrollView.documentView = self.tableView;
	scrollView.autohidesScrollers = YES;
	self.scrollView = scrollView;
	
	
	self.view = view;
}


- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"Aliases";
}

@end
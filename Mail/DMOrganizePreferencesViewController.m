//
//  DMOrganizePreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMOrganizePreferencesViewController.h"
#import "DMColoredView.h"
#import "DMLayeredScrollView.h"
#import "DMOrganizeAccountCellView.h"
#import "DMOrganizeFolderCellView.h"
#import "DMPersistentStateManager.h"
#import "MKColorWell.h"

static const CGSize kPreferencePaneContentSize = (CGSize){ 500, 370 };
static const NSInteger kFoldersTableViewTag = 100;
static const NSInteger kAccountsTableViewTag = 101;

@interface DMOrganizePreferencesViewController ()

@property (nonatomic, strong) MKColorWell *colorWell;
@property (nonatomic, strong) PSTMailAccount *selectedAccount;
@property (nonatomic, strong) NSArray *allVisibleLabels;

@end

@implementation DMOrganizePreferencesViewController

- (void)loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	
	NSScrollView *accountsScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(view.bounds)/2, NSHeight(view.bounds) - 56)];
	accountsScrollView.hasVerticalScroller = YES;
	NSTableView *accountsTableView = [[NSTableView alloc] initWithFrame:accountsScrollView.bounds];
	accountsTableView.tag = kAccountsTableViewTag;
	accountsTableView.dataSource = self;
	accountsTableView.delegate = self;
	accountsTableView.headerView = nil;
	accountsTableView.target = self;
	accountsTableView.allowsMultipleSelection = YES;
	accountsTableView.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	accountsScrollView.documentView = accountsTableView;
	[view addSubview:accountsScrollView];
	
	NSScrollView *foldersScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(NSWidth(view.bounds)/2, 0, NSWidth(view.bounds)/2, NSHeight(view.bounds) - 56)];
	foldersScrollView.hasVerticalScroller = YES;
	NSTableView *foldersTableView = [[NSTableView alloc] initWithFrame:foldersScrollView.bounds];
	foldersTableView.tag = kFoldersTableViewTag;
	foldersTableView.dataSource = self;
	foldersTableView.delegate = self;
	foldersTableView.headerView = nil;
	foldersTableView.target = self;
	foldersTableView.allowsMultipleSelection = YES;
	foldersTableView.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	foldersScrollView.documentView = foldersTableView;
	[view addSubview:foldersScrollView];
	
	_colorWell = [[MKColorWell alloc]initWithFrame:NSZeroRect];
	[_colorWell awakeFromNib];
	[_colorWell setAnimatePopover:YES];
	_colorWell.alphaValue = 0.0f;
	[foldersScrollView addSubview:_colorWell];

	[RACObserve(self.colorWell,color) subscribeNext:^(NSColor *color) {
		if (foldersTableView.selectedRow > -1) {
			DMOrganizeFolderCellView *cell = [foldersTableView rowViewAtRow:foldersTableView.selectedRow makeIfNecessary:NO];
			[cell setLabelColor:color];
			[self.selectedAccount setColor:color forLabel:cell.label];
		}
	}];
	
	[RACObserve(PSTAccountManager.defaultManager,accounts) subscribeNext:^(id x) {
		[accountsTableView reloadData];
		if (!_selectedAccount) {
			[accountsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
		}
	}];
	
	
	[RACObserve(self,selectedAccount) subscribeNext:^(PSTMailAccount *account) {
		NSMutableArray *labels = account.allLabels.mutableCopy;
		if ([account isSelectionAvailable:PSTFolderTypeSpam]) {
			[labels insertObject:@"Spam" atIndex:0];
		}
		if ([account isSelectionAvailable:PSTFolderTypeAllMail]) {
			[labels insertObject:@"All Mail" atIndex:0];
		}
		self.allVisibleLabels = labels;
		[foldersTableView reloadData];
	}];
	
	self.view = view;
}

- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"Organize";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	if (tableView.tag == kFoldersTableViewTag) {
		return 35.f;
	}
	return 50.f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if (tableView.tag == kFoldersTableViewTag) {
		DMOrganizeFolderCellView *tableCellView = (DMOrganizeFolderCellView *)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
		return tableCellView;
	}
	DMOrganizeAccountCellView *tableCellView = (DMOrganizeAccountCellView *)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	return tableCellView;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
	if (tableView.tag == kFoldersTableViewTag) {
		NSString *label = self.allVisibleLabels[row];
		[(DMOrganizeFolderCellView *)rowView setLabel:label];
		[(DMOrganizeFolderCellView *)rowView setLabelColor:[self.selectedAccount colorForLabel:label]];
	} else {
		[(DMOrganizeAccountCellView *)rowView setAccount:PSTAccountManager.defaultManager.accounts[row]];
	}
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	if (tableView.tag == kFoldersTableViewTag) {
		DMOrganizeFolderCellView *cell = [[DMOrganizeFolderCellView alloc]initWithFrame:NSZeroRect];
		return cell;
	}
	DMOrganizeAccountCellView *cell = [[DMOrganizeAccountCellView alloc]initWithFrame:NSZeroRect];
	return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSTableView *tableView = (NSTableView *)notification.object;
	if (tableView.tag == kAccountsTableViewTag && tableView.selectedRow < (NSInteger)PSTAccountManager.defaultManager.accounts.count) {
		if (tableView.selectedRow != NSIntegerMax) {
			self.selectedAccount = PSTAccountManager.defaultManager.accounts[tableView.selectedRow];
		}
	} else {
		NSRect selectedRect = CGRectOffset([tableView rectOfRow:tableView.selectedRow], 0, [tableView.enclosingScrollView documentVisibleRect].origin.y + 10);
		_colorWell.frame = selectedRect;
		[_colorWell mouseDown:nil];
	}
	
}

#pragma mark -  NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	if (tableView.tag == kFoldersTableViewTag) {
		return self.allVisibleLabels.count;
	}
	return PSTAccountManager.defaultManager.accounts.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if (tableView.tag == kFoldersTableViewTag) {
		return @"";
	}
	return PSTAccountManager.defaultManager.accounts[row];
}

@end

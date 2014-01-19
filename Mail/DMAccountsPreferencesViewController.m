//
//  DMAccountsPreferencesViewController.m
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAccountsPreferencesViewController.h"
#import "DMColoredView.h"
#import "DMAccountCell.h"
#import "DMFlatButton.h"
#import "DMAccountSetupWindowController.h"

static CGSize const kPreferencePaneContentSize = (CGSize){ 500, 450 };
static CGFloat const DMAccountCellHeight = 50.f;

@interface DMAccountsPreferencesViewController ()
@property (nonatomic) NSUInteger selectedRow;
@end

@implementation DMAccountsPreferencesViewController

- (void)loadView {	
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ .size = kPreferencePaneContentSize }];
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	
	NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(view.bounds), NSHeight(view.bounds) - 56)];
	scrollView.hasVerticalScroller = YES;
	NSTableView *accountsTableView = [[NSTableView alloc] initWithFrame:scrollView.bounds];
	accountsTableView.dataSource = self;
	accountsTableView.delegate = self;
	accountsTableView.headerView = nil;
	accountsTableView.target = self;
	accountsTableView.allowsMultipleSelection = YES;
	accountsTableView.backgroundColor = [NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000];
	scrollView.documentView = accountsTableView;
	[view addSubview:scrollView];
	
	[RACObserve(PSTAccountManager.defaultManager,accounts) subscribeNext:^(id x) {
		[accountsTableView reloadData];
	}];
	
	[NSNotificationCenter.defaultCenter addObserverForName:PSTAvatarImageManagerDidUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		[accountsTableView reloadData];
	}];
	
	[NSNotificationCenter.defaultCenter addObserverForName:DMAccountRequestDeletionNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		PSTMailAccount *accountToRemove = note.userInfo[@"Account"];
		static NSString *const messageText = @"Confirm account deletion";
		NSAlert *alert = [NSAlert alertWithMessageText:messageText defaultButton:@"Delete" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"This will permanently remove the account and settings for %@", accountToRemove.email];
		[alert beginSheetModalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(confirmAccountDeletion:returnCode:contextInfo:) contextInfo:(__bridge void *)(note.userInfo[@"Account"])];
	}];
	
	DMFlatButton *createAccountButton = [[DMFlatButton alloc]initWithFrame:(NSRect){ { 0, -4 }, { NSWidth(view.bounds), 30 } }];
	createAccountButton.keyEquivalent = @"\r";
	createAccountButton.buttonType = NSMomentaryPushInButton;
	createAccountButton.bordered = NO;
	createAccountButton.target = self;
	createAccountButton.action = @selector(addAccount:);
	createAccountButton.verticalPadding = 6;
	createAccountButton.title = @"+ Add Account";
	createAccountButton.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:13];
	createAccountButton.backgroundColor = [NSColor colorWithCalibratedRed:0.296 green:0.303 blue:0.315 alpha:1.000];
	[view addSubview:createAccountButton];
	
	self.view = view;
}

- (void)addAccount:(id)sender {
	[DMAccountSetupWindowController.modalAccountSetupWindowController beginSheetModalForWindow:self.view.window];
}

- (void)confirmAccountDeletion:(NSAlert *)alert returnCode:(NSUInteger)code contextInfo:(void *)context {
	id account = (__bridge id)(context);
	if (code == NSAlertDefaultReturn) {
		[PSTAccountManager.defaultManager removeAccount:account];
		_selectedRow = NSNotFound;
		if (PSTAccountManager.defaultManager.accounts.count == 0) {
			[self.view.window close];
		}
	}
}

- (CGSize)contentSize {
	return kPreferencePaneContentSize;
}

- (NSString *)title {
	return @"Accounts";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return DMAccountCellHeight;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
	return row == (NSInteger)PSTAccountManager.defaultManager.accounts.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	DMAccountCell *tableCellView = (DMAccountCell*)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	return tableCellView;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(DMAccountCell *)rowView forRow:(NSInteger)row {
	[rowView setAccount:PSTAccountManager.defaultManager.accounts[row]];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	DMAccountCell *cell = [[DMAccountCell alloc]initWithFrame:NSZeroRect];
	return cell;
}

#pragma mark -  NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return PSTAccountManager.defaultManager.accounts.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return (row == (NSInteger)PSTAccountManager.defaultManager.accounts.count) ? @"Add" : PSTAccountManager.defaultManager.accounts[row];
}

@end


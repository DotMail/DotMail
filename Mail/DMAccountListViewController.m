//
//  DMAccountListController.m
//  Mail
//
//  Created by Robert Widmann on 10/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAccountListViewController.h"
#import "DMAccountListView.h"
#import "NSColor+DMUIColors.h"

@interface DMAccountListViewController () <DMAccountListViewActionDelegate>
@property (nonatomic, strong) DMAccountListView *accountListView;
@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic, assign) PSTFolderType selected;
@end

@implementation DMAccountListViewController {
	CGRect _contentRect;
}

#pragma mark - Lifecycle

- (instancetype)initWithContentRect:(CGRect)contentRect {
	self = [super init];

	_contentRect = contentRect;
	
	return self;
}

- (void)loadView {
	TUIView *view = [[TUIView alloc]initWithFrame:_contentRect];
	view.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	[view setBackgroundColor:[NSColor colorWithCalibratedRed:0.121 green:0.135 blue:0.154 alpha:1.000]];

	self.accountListView = [[DMAccountListView alloc]initWithFrame:view.bounds];
	[self.accountListView setAutoresizingMask:TUIViewAutoresizingFlexibleSize];
	[self.accountListView setActionDelegate:self];
	[view addSubview:self.accountListView];
		
	@weakify(self);
	void (^reloadBlock)(NSNotification *note) =  ^void(NSNotification *note) {
		@strongify(self);
		[self.accountListView reloadData];
		if (self.selectedAccount == nil && PSTAccountControllerManager.defaultManager.accounts.count != 0) {
			self.selectedAccount = [PSTAccountControllerManager defaultManager].accounts[0];
			[self.accountListView setSelection:PSTFolderTypeInbox path:@"INBOX"];
			[self.selectedAccount selectInbox];
		}
	};
	
	[NSNotificationCenter.defaultCenter addObserverForName:PSTAccountControllerManagerAccountListChangedNotification object:nil queue:nil usingBlock:reloadBlock];
	[NSNotificationCenter.defaultCenter addObserverForName:PSTMailUnifiedAccountCountUpdated object:nil queue:nil usingBlock:^(NSNotification *note) {
		@strongify(self);
		[self.accountListView updateCount];
	}];
	
	self.view = view;
	reloadBlock(nil);
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Overrides

- (void)setSelectedAccount:(PSTAccountController *)selectedAccount {
	_selectedAccount = selectedAccount;
	[self.accountListView setSelectedAccount:selectedAccount];
}

- (void)setSelectionForCurrentAccount:(PSTFolderType)selection {
	[self _setSelectionForCurrentAccount:selection path:nil];
}

- (IBAction)selectPreviousAccount:(id)sender {
	NSUInteger index = [PSTAccountControllerManager.defaultManager.accounts indexOfObjectIdenticalTo:self.selectedAccount];
	PSTAccountController *selectedAccount = [PSTAccountControllerManager.defaultManager.accounts objectAtIndex:(index + 1)];
	[self _setSelectedAccount:selectedAccount selection:PSTFolderTypeInbox path:nil];
}

- (IBAction)selectNextAccount:(id)sender {
	NSUInteger index = [PSTAccountControllerManager.defaultManager.accounts indexOfObjectIdenticalTo:self.selectedAccount];
	PSTAccountController *selectedAccount = [PSTAccountControllerManager.defaultManager.accounts objectAtIndex:(index - 1)];
	[self _setSelectedAccount:selectedAccount selection:PSTFolderTypeInbox path:nil];
}

- (PSTFolderType)selectedMailbox {
	if (self.account == nil) {
		return PSTFolderTypeNone;
	}
	return self.selected;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	NSUInteger index = [PSTAccountControllerManager.defaultManager.accounts indexOfObjectIdenticalTo:self.selectedAccount];
	if (menuItem.action == @selector(selectNextAccount:)) {
		return (index != 0);
	} else if (menuItem.action == @selector(selectPreviousAccount:)) {
		return (index < (PSTAccountControllerManager.defaultManager.accounts.count - 1));
	}
	return NO;
}

#pragma mark - Delegate Methods

- (void)listViewWantsRefresh:(DMAccountListView *)listView {
	[listView.selectedAccount refreshSync];
}

- (void)listView:(DMAccountListView *)listView accountSelected:(PSTAccountController *)newAccount selection:(PSTFolderType)selection path:(NSString *)path {
	[self willChangeValueForKey:@"selectedMailbox"];
	self.selected = selection;
	[self didChangeValueForKey:@"selectedMailbox"];
	[CATransaction begin];
	[CATransaction setValue:@1.0f forKey:kCATransactionAnimationDuration];
	[CATransaction setValue:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] forKey:kCATransactionAnimationTimingFunction];
	[self _setSelectedAccount:newAccount selection:selection path:path];
	[self.accountListView setSelectedAccount:newAccount];
	[self.accountListView setSelection:selection path:path];
	[CATransaction commit];
}

- (void)_setSelectedAccount:(PSTAccountController *)newAccount selection:(PSTFolderType)selection path:(NSString *)path {
	self.selectedAccount = newAccount;
	[self.delegate accountListControllerWillChange:self];
	if (self.account != newAccount) {
		if (newAccount.accounts.count >= 2) {
			if (self.account.accounts.count >= 2) {
				NSMutableSet *accountEmailsSet = [[NSMutableSet alloc]init];
				for (PSTMailAccount *account in self.account.accounts) {
					[accountEmailsSet addObject:account.email];
				}
				NSMutableSet *newAccountEmailsSet = [[NSMutableSet alloc]init];
				for (PSTMailAccount *account in newAccount.accounts) {
					[newAccountEmailsSet addObject:account.email];
				}
				NSSet *unifiedEmailsSet = [newAccountEmailsSet setByAddingObjectsFromSet:accountEmailsSet];
				if (unifiedEmailsSet.count != newAccount.accounts.count) {
					
				}
			}
		}
		self.account = newAccount;
	}
	[self _setSelectionForCurrentAccount:selection path:path];
}

- (void)_setSelectionForCurrentAccount:(PSTFolderType)selection path:(NSString *)path {
	[self.account setSelectedFolder:selection];
	if (selection == PSTFolderTypeLabel) {
		[self.account setSelectedLabel:path];
	} else {
		[self.account setSelectedLabel:nil];
	}
	[PSTAccountManager.defaultManager synchronize];
	[self.accountListView setSelection:selection path:path];
}


@end

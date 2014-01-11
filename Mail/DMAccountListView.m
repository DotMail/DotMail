//
//  DMAccountListView.m
//  Mail
//
//  Created by Robert Widmann on 10/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAccountListView.h"
#import "DMAccountView.h"
#import "DMAccountContainerView.h"

@interface DMAccountListView () <DMAccountContainerViewActionDelegate>
@property (nonatomic, strong) NSMutableArray *accountLayers;
@end

@implementation DMAccountListView {
	BOOL _creatingAccountsView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	_accountLayers = @[].mutableCopy;

	return self;
}

- (void)reloadData {
	[self _reloadAccount:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ((__bridge void *)([DMAccountListView class]) == context) {
		if ([keyPath isEqualToString:@"labels"]) {
			if ([(PSTAccountController*)object accounts].count == 1) {
				[self _reloadAccount:(PSTAccountController*)object];
			}
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)setSelectedAccount:(PSTAccountController *)selectedAccount {
	_selectedAccount = selectedAccount;
	for (DMAccountContainerView *container in self.accountLayers) {
		if (container.account == selectedAccount) {
			[container setSelected:YES];
			[container setSelection:PSTFolderTypeInbox path:nil];
		} else {
			[container setSelected:NO];
		}
		
	}
	if (_creatingAccountsView == NO) {
		[self layoutSubviews];
	}
}

- (void)_reloadAccount:(PSTAccountController *)accountToReload {
	NSMutableDictionary *dictionary = @{}.mutableCopy;
	if (accountToReload == nil) {
		self.selectedAccount = nil;
	} else {
		//Loop through the account views in our subviews list and try to organize them
		//into the dictionary, at which point we can also identify the truly-unified account view,
		//which is useful for layout later.
		for (DMAccountContainerView *accountView in self.accountLayers) {
			if (accountView.account != accountToReload) {
				NSString *key = nil;
				if (accountView.account.hasMultipleAccounts) {
					key = @"unified";
				} else {
					key = accountView.account.email;
				}
				[dictionary setObject:accountView forKey:key];
			}
		}
	}
	//Because the dictionary now contains all of the account views and their associated emails,
	//we no longer need the account layers in the array, so before we unload, we unregister for
	//their events so we don't get some weird KVO after-effects.
	for (DMAccountContainerView *accountView in self.accountLayers) {
		[accountView.account removeObserver:self forKeyPath:@"labels"];
		[accountView removeFromSuperview];
	}
	[self.accountLayers removeAllObjects];
	for (PSTAccountController *unifiedAccount in PSTAccountControllerManager.defaultManager.accounts) {
		if (self.selectedAccount.accounts.count != 1) {
			goto checkSelectedAccount;
		}
		if (unifiedAccount.accounts.count == 1) {
			if (self.selectedAccount.mainAccount == accountToReload.mainAccount) {
				accountToReload = unifiedAccount;
			}
		} else {
		checkSelectedAccount:
			if (self.selectedAccount.accounts.count >= 2) {
				if (unifiedAccount.accounts.count >= 2) {
					accountToReload = unifiedAccount;
				}
			}
		}
		//'labels' really comes from the PSTMailAccount class, but the unified account forwards it to us.
		[unifiedAccount addObserver:self forKeyPath:@"labels" options:0 context:(__bridge void *)([self class])];
	}
	_creatingAccountsView = YES;
	for (PSTAccountController *unifiedAccount in PSTAccountControllerManager.defaultManager.accounts) {
		NSString *key = nil;
		if (unifiedAccount.hasMultipleAccounts) {
			key = @"multiple";
		} else {
			key = unifiedAccount.email;
		}
		DMAccountContainerView *accountView = [dictionary objectForKey:key];
		if (accountView != nil) {
			[self.accountLayers addObject:accountView];
			if (self.selectedAccount == nil) {
				[accountView setSelected:YES];
				[self setSelectedAccount:unifiedAccount];
				[self setSelection:unifiedAccount.selectedFolder path:unifiedAccount.selectedLabel];
			} else if (accountView.account == unifiedAccount){
				[accountView setSelected:YES];
				[self setSelectedAccount:unifiedAccount];
				[self setSelection:unifiedAccount.selectedFolder path:unifiedAccount.selectedLabel];
			}
			[self addSubview:accountView];
		} else {
			DMAccountContainerView *newContainer = [[DMAccountContainerView alloc]initWithFrame:self.bounds];
			[newContainer setAccount:unifiedAccount];
			[newContainer setActionDelegate:self];
			[self.accountLayers addObject:newContainer];
			if (self.selectedAccount == nil) {
				[accountView setSelected:YES];
				[self setSelectedAccount:unifiedAccount];
				[self setSelection:unifiedAccount.selectedFolder path:unifiedAccount.selectedLabel];
			} else if (accountView.account == unifiedAccount){
				[accountView setSelected:YES];
				[self setSelection:unifiedAccount.selectedFolder path:unifiedAccount.selectedLabel];
			}
			[self addSubview:newContainer];
		}
	}
	_creatingAccountsView = NO;
	[self layoutSubviews];
	[self.actionDelegate listView:self accountSelected:self.selectedAccount selection:self.selectedAccount.selectedFolder path:self.selectedAccount.selectedLabel];
}

- (void)layoutSubviews {
	NSUInteger idx = 0;
	for (DMAccountContainerView *containerView in self.accountLayers) {
		if (containerView.account == self.selectedAccount) {
			[containerView setSelected:YES];
			[containerView setFrame:CGRectInset(self.bounds, 0, 30*idx)];
		} else {
			[containerView setSelected:NO];
			containerView.frame = (CGRect){ .origin.y = 30*idx, .size = { CGRectGetWidth(self.bounds), 30 } };
		}
		[containerView setIndex:idx];
		idx++;
		[containerView layoutSubviews];
	}
}

- (void)setSelection:(PSTFolderType)selection path:(NSString*)path {
	for (DMAccountContainerView *containerView in self.accountLayers) {
		if (containerView.account == self.selectedAccount) {
			if (selection == PSTFolderTypeLabel) {
				[containerView setSelection:PSTFolderTypeLabel path:path];
			} else {
				[containerView setSelection:selection path:nil];
			}
		}
	}
	if (!_creatingAccountsView) {
		[self layoutSubviews];
	}
}

- (void)updateCount {
	for (DMAccountContainerView *containerView in self.accountLayers) {
		[containerView updateCount];
	}
}

#pragma mark - Delegate Methods

- (void)containerView:(DMAccountContainerView *)containerView selection:(PSTFolderType)selection path:(NSString *)path {
	[self.actionDelegate listView:self accountSelected:containerView.account selection:selection path:path];
}

- (void)containerViewWantsRefresh:(DMAccountContainerView *)containerView {
	[self.actionDelegate listViewWantsRefresh:self];
}

@end

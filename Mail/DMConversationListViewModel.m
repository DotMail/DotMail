//
//  DMConversationListViewModel.m
//  DotMail
//
//  Created by Robert Widmann on 10/10/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMConversationListViewModel.h"
#import "DMMessageCell.h"

static CGFloat const DMInboxCellHeight = 113.f;
static NSInteger const kDMNumberOfSectionsInTableView = 1;

@implementation DMConversationListViewModel

- (void)setAccount:(PSTAccountController *)account {
	if (account == nil) self.count = 0;
	if ([_account isEqual:account]) return;
	
	[NSNotificationCenter.defaultCenter removeObserver:self name:PSTMailUnifiedAccountCountUpdated object:_account];
	_account = account;
	
	@weakify(self);
	[[RACSignal if:RACObserve(account,loading) then:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		return nil;
	}] else:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);
		[self _countUpdated];
		return nil;
	}]] subscribeCompleted:^{}];
}

- (void)_countUpdated {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_countUpdatedAfterDelay) object:nil];
	[self performSelector:@selector(_countUpdatedAfterDelay) withObject:nil afterDelay:0];
}

- (void)_countUpdatedAfterDelay {
	self.count = self.account.currentConversations.count;
}

- (NSArray *)currentConversations {
	return self.account.currentConversations;
}

- (BOOL)hasConversations {
	return (self.currentConversations.count != 0);
}

#pragma mark - NSTableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 110.f;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
	if (self.hasConversations) {
		_previousSelection = tableView.selectedRowIndexes;
		PSTConversation *selectedConversation = self.currentConversations[row];
		[selectedConversation load];
		NSMutableArray *array = [[NSMutableArray alloc] init];
		if (self.account.accounts.count >= 2) {
			[array addObject:[NSString stringWithFormat:@"%@-%lu", selectedConversation.storage.email, selectedConversation.conversationID]];
		} else {
			[array addObject:@(selectedConversation.conversationID)];
		}
		self.selectedConversation = selectedConversation;
	}
	return YES;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	DMMessageCell *tableCellView = (DMMessageCell*)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	return tableCellView;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(DMMessageCell *)rowView forRow:(NSInteger)row {
	if (row >= 0 && self.currentConversations.count <= (NSUInteger)row) return;
	[rowView setConversation:[self.currentConversations objectAtIndex:row]];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	DMMessageCell *cell = [[DMMessageCell alloc]initWithFrame:NSZeroRect];
	return cell;
}


- (CGFloat)tableView:(TUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return DMInboxCellHeight;
}

#pragma mark -  NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return self.account.currentConversations.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return self.account.currentConversations[row];
}

@end

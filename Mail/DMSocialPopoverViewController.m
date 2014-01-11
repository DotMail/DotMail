//
//  DMSocialViewController.m
//  DotMail
//
//  Created by Robert Widmann on 3/19/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSocialPopoverViewController.h"


#import "DMSocialNotificationCell.h"

static CGFloat const cellHeight = 116.f;

@interface DMSocialPopoverViewController ()

@property (nonatomic, strong) TUITableView *tableView;
@property (nonatomic, strong) NSArray *currentConversations;

@end

@implementation DMSocialPopoverViewController

#pragma mark - Lifecycle;

- (instancetype)initWithSocialMode:(DMSocialPopoverMode)mode {
	self = [super init];
	
	_socialMode = mode;
	_currentConversations = @[].mutableCopy;

	return self;
}

- (void)loadView {
	[self setView:[[TUINSView alloc]initWithFrame:CGRectMake(0, 0, 290, 350)]];

	self.socialCount = 0;

	TUIView *tui_view = [[TUIView alloc]initWithFrame:CGRectZero];
	[tui_view setBackgroundColor:[NSColor whiteColor]];
	[(TUINSView *)self.view setRootView:tui_view];
	
	CGRect tableFrame = CGRectMake(0, 0, 290, 350);
	self.tableView = [[TUITableView alloc]initWithFrame:tableFrame style:TUITableViewStyleGrouped];
	[self.tableView setAlwaysBounceVertical:YES];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setClipsToBounds:YES];
	[tui_view addSubview:self.tableView];
}

#pragma mark - Table Delegate Methods

- (CGFloat)tableView:(TUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return cellHeight;
}

- (NSInteger)tableView:(TUITableView *)table numberOfRowsInSection:(NSInteger)section {
	return self.currentConversations.count;
}

- (NSInteger)numberOfSectionsInTableView:(TUITableView *)tableView {
	return 1;
}

- (TUITableViewCell *)tableView:(TUITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DMSocialNotificationCell *cell = reusableTableCellOfClass(tableView, DMSocialNotificationCell);
	
	cell.socialMode = self.socialMode;
	cell.notification = self.currentConversations[indexPath.row];
	
	return cell;
}

#pragma mark - Overrides

- (void)setAccount:(PSTMailAccount *)account {
	_account = account;
	switch (self.socialMode) {
		case DMSocialPopoverModeFacebook: {
			[account.facebookMessagesSignal subscribeNext:^(NSArray *facebookMessages){
				self.currentConversations = facebookMessages;
				self.socialCount = facebookMessages.count;
				[self.tableView reloadData];
			}];
		}
			break;
		case DMSocialPopoverModeTwitter: {
			[account.twitterMessagesSignal subscribeNext:^(NSArray *twitterMessages){
				self.currentConversations = twitterMessages;
				self.socialCount = twitterMessages.count;
				[self.tableView reloadData];
			}];
		}
			break;
			
		default:
			break;
	}
}

@end


//
//  DMConversationListViewModel.h
//  DotMail
//
//  Created by Robert Widmann on 10/10/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@class PSTAccountController;

@interface DMConversationListViewModel : NSObject <NSTableViewDelegate, NSTableViewDataSource>

/**
 * The account associated with this DMConversationListController.
 * @note Upon being set, the old account is deallocated, and the new one is RAC'd for it's
 * conversations.
 */
@property (nonatomic, weak) PSTAccountController *account;

/**
 * An array of conversations associated with the current account's currently selected mailbox type.
 * @return An array of PSTConversation objects.
 */
@property (nonatomic, strong, readonly) NSMutableArray *currentConversations;

/**
 * The conversation that is currently selected in the main table view.
 * @return A PSTConversation or nil if nothing is selected.
 */
@property (nonatomic, weak) PSTConversation *selectedConversation;

@property (nonatomic) NSUInteger count;
@property (nonatomic, strong) NSIndexSet *previousSelection;;

@end

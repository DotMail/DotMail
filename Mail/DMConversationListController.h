//
//  CFIConversationListDepotDelegate.h
//  DotMail
//
//  Created by Robert Widmann on 7/28/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PSTAccountController, PSTConversation, PSTMailAccount, DMSearchField;

@protocol PSTConversationDelegate;

/**
 * DMConversationListController manages the display of the list of conversations from it's provided
 * account and the management of it's tableview.  It provides a number of functions that wrap around
 * the tableview that is associated with it, and as such, those are preferred over directly accessing
 * the table and calling those methods.  Doing otherwise may result in undefined behavior or weird UI
 * quirks.
 */

@interface DMConversationListController : NSViewController <NSTextFieldDelegate>{
	//    TUIRefreshControl *refreshHeader_;
	BOOL _reloading;
}

- (instancetype)initWithContentRect:(NSRect)rect;

/**
 * The conversations list controller's delegate.
 */
@property (nonatomic, weak) id <PSTConversationDelegate> delegate;

/**
 * The account associated with this DMConversationListController.
 * @note Upon being set, the old account is deallocated, and the new one is RAC'd for it's
 * conversations.
 */
@property (nonatomic, weak) PSTAccountController *account;

/**
 * The selected mailbox type associated with this conversation list controller.
 */
@property (nonatomic, assign) NSUInteger selectedMailbox;

/**
 * The main tableview for this conversation list controller.
 */
@property (nonatomic, strong) NSTableView *mailboxTableView;

@property (nonatomic, strong) TUIActivityIndicatorView *progressView;

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

@property (nonatomic, strong) DMSearchField *searchField;

/**
 * Reloads the tableview and calls a few extra UI related methods.  This method is preferred over
 * explicitly calling -reloadData on the main table view.
 */
- (void)reloadData;

/**
 * Sets the scroll position of the tableview to the top and calls a few extra UI related methods.
 * This method is preferred over explicitly calling -reloadData on the main table view.
 */
- (void)scrollToTop;

/**
 * Sets it's account's currently selected mailbox to PSTFolderTypeInbox, and triggers a reload
 * internally.
 */
- (void)selectInbox;

- (void)selectMailbox:(PSTFolderType)mailbox;

- (void)setup;

- (CALayer *)currentRenderingLayerDisabled:(BOOL)disabled;

@end

@protocol PSTConversationDelegate <NSObject>
- (void) conversationListControllerDidChangeSelection:(DMConversationListController *)controller;

@end
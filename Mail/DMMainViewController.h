//
//  DMMainViewController.h
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//


#import <Quartz/Quartz.h>

@class DMMainViewModel, DMConversationListController;

@interface DMMainViewController : NSViewController <NSTextFieldDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
	NSRect _frame;
}

- (instancetype)initWithContentRect:(NSRect)rect;
- (void)reinstateToolbar;
- (void)editDraftMessage:(PSTConversation *)conversation;

- (void)unload;

- (void)selectMailbox:(PSTFolderType)mailbox;

- (void)selectPreviousAccount:(id)sender;
- (void)selectNextAccount:(id)sender;

- (void)print:(id)sender;

@property (nonatomic, strong, readonly) DMMainViewModel *viewModel;
@property (nonatomic, strong) DMConversationListController *conversationListController;

@end

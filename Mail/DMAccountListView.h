//
//  DMAccountListView.h
//  Mail
//
//  Created by Robert Widmann on 10/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import <Puissant/PSTConstants.h>

@class PSTAccountController, DMAccountContainerView;

@protocol DMAccountListViewActionDelegate;



@interface DMAccountListView : TUIView

- (void)updateCount;
- (void)reloadData;

- (void)setSelection:(PSTFolderType)selection path:(NSString *)path;

@property (nonatomic, assign) id<DMAccountListViewActionDelegate> actionDelegate;
@property (nonatomic, strong) PSTAccountController *selectedAccount;

@end

@protocol DMAccountListViewActionDelegate <NSObject>
- (void)listView:(DMAccountListView *)listView accountSelected:(PSTAccountController *)selectedAccount selection:(PSTFolderType)selectedAccount path:(NSString *)path;
- (void)listViewWantsRefresh:(DMAccountListView *)listView;
@end
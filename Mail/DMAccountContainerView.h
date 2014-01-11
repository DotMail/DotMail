//
//  DMAccountContainerView.h
//  DotMail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@class DMAccountView, DMFolderView, DMLabelSeparatorView;

@protocol DMAccountContainerViewActionDelegate;

@interface DMAccountContainerView : TUIView

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, assign) PSTFolderType selection;
@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) id<DMAccountContainerViewActionDelegate> actionDelegate;
@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic, strong) DMAccountView *accountView;
@property (nonatomic, strong) TUIScrollView *foldersContainerView;
@property (nonatomic, strong) DMLabelSeparatorView *labelSeparatorView;

- (void)setSelection:(PSTFolderType)selection path:(NSString *)path;
- (void)updateCount;

@end

@protocol DMAccountContainerViewActionDelegate <NSObject>

- (void)containerView:(DMAccountContainerView *)containerView selection:(PSTFolderType)selection path:(NSString *)path;
- (void)containerViewWantsRefresh:(DMAccountContainerView *)containerView;
@end
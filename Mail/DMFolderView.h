//
//  DMFolderView.h
//  DotMail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import <Puissant/PSTConstants.h>

@class PSTAccountController;

@protocol DMFolderViewActionDelegate;

@interface DMFolderView : TUIView

- (void)updateCount;

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, assign) id<DMFolderViewActionDelegate> actionDelegate;
@property (nonatomic, strong) TUILabel *label;
@property (nonatomic, strong) TUILabel *counterView;
@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) PSTFolderType selection;
@property (nonatomic, assign) PSTFolderType previousSelection;
@property (nonatomic, strong) NSColor *labelColor;

@end

@protocol DMFolderViewActionDelegate <NSObject>

- (void)folderViewWantsRefresh:(DMFolderView *)accountView;
- (void)folderViewDidBecomeSelected:(DMFolderView *)accountView;

@end

@interface DMLabelSeparatorView : DMFolderView


@end
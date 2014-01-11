//
//  DMAccountView.h
//  DotMail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//



@class PSTAccountController;

@protocol DMAccountViewActionDelegate;

@interface DMAccountView : TUIView

@property (nonatomic, assign) id <DMAccountViewActionDelegate> actionDelegate;
@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

- (void)updateCount;

@end

@protocol DMAccountViewActionDelegate <NSObject>

- (void)accountViewWantsRefresh:(DMAccountView *)accountView;
- (void)accountViewDidBecomeSelected:(DMAccountView *)accountView;

@end
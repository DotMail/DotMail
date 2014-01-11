//
//  DMMessageCell.m
//  JAListView
//
//  Created by Josh Abernathy on 9/29/10.
//  Copyright 2010 Maybe Apps. All rights reserved.
//

#import <Puissant/PSTConstants.h>

@class DMActionStepButton, PSTConversation, PSTMailAccount;

@protocol DMActionStepButtonDelegate <NSObject>

- (void)highPriorityClicked;
- (void)mediumPriorityClicked;
- (void)lowPriorityClicked;
- (void)resetPriorityClicked;

@end

@interface DMMessageCell : NSTableRowView <TUIViewDelegate, DMActionStepButtonDelegate>

@property (nonatomic, assign, getter = isRead) BOOL read;
@property (nonatomic, assign) PSTActionStepValue actionStepValue;
@property (nonatomic, strong) PSTConversation *conversation;
@property (nonatomic, strong) PSTMailAccount *account;

- (void)toggleUnread;
- (void)highPriorityClicked;
- (void)mediumPriorityClicked;
- (void)lowPriorityClicked;
- (void)resetPriorityClicked;

@end

@interface DMActionStepButton : NSView

@property (nonatomic, assign) id<DMActionStepButtonDelegate> delegate;

@property (nonatomic, strong) CALayer *checkmarkActionStep;
@property (nonatomic, strong) CALayer *actionStepOne;
@property (nonatomic, strong) CALayer *actionStepTwo;
@property (nonatomic, strong) CALayer *actionStepThree;

- (void)relayoutForNextStepMode:(PSTActionStepValue)actionStep;

@end

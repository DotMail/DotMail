//
//  DMComposeTopView.h
//  DotMail
//
//  Created by Robert Widmann on 4/25/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//


#import <JNWCollectionView/JNWCollectionViewReusableView.h>

@class PSTConversation, PSTMailAccount;

@protocol PSTConversationHeaderViewDelegate;

@interface PSTConversationHeaderView : JNWCollectionViewReusableView

@property (nonatomic, strong) PSTConversation *conversation;
@property (nonatomic, weak) id<PSTConversationHeaderViewDelegate> delegate;

@end

@protocol PSTConversationHeaderViewDelegate <NSObject>

- (void)toggleQuickReply:(BOOL)isQuickReplying;

@end
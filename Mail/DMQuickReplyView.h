//
//  DMQuickReplyView.h
//  DotMail
//
//  Created by Robert Widmann on 4/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@protocol DMQuickReplyViewDelegate;

@interface DMQuickReplyView : NSView


@property (nonatomic, weak) id<DMQuickReplyViewDelegate> delegate;

- (void)focusTextView:(BOOL)isQuickReplying;

@end

@protocol DMQuickReplyViewDelegate <NSObject>

- (void) cancelQuickReply;

@end
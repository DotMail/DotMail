//
//  DMConversationWindowController.h
//  DotMail
//
//  Created by Robert Widmann on 9/21/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@class PSTConversation;

@interface DMConversationWindowController : NSWindowController

- (id)initWithConversation:(PSTConversation *)conversation;
- (void)setOnCloseBlock:(void(^)(id token))block;

@end

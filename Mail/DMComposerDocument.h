//
//  DMComposerDocument.h
//  DotMail
//
//  Created by Robert Widmann on 6/3/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//


#import "DMComposeWindowController.h"

@class DMComposeViewModel, PSTConversation;

@interface DMComposerDocument : NSDocument

- (instancetype)initInReplyToConversation:(PSTConversation *)conversation;
- (instancetype)initInReplyAllToConversation:(PSTConversation *)conversation;
- (instancetype)initToEditDraftConversation:(PSTConversation *)conversation;

- (IBAction)showAttachFilesWindow:(id)sender;
- (IBAction)saveMessage:(id)sender;

@property (nonatomic) NSPoint cascadePoint;

@property (nonatomic, readonly) PSTConversation *conversation;

@property (nonatomic, copy) void(^onClose)(DMComposerDocument *document);

@end

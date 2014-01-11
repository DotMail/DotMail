//
//  DMMainViewModel.h
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMAssistantViewController.h"

@class PSTAccountController;

@interface DMMainViewModel : NSObject <DMAssistantViewControllerDelegate>

- (void)composeMessage:(id)sender;
- (void)composeReply:(id)sender;
- (void)composeReplyAll:(id)sender;
- (void)composeMessageWithTo:(NSArray*)to cc:(NSArray*)cc bcc:(NSArray*)bcc subject:(NSString*)subject htmlBody:(NSString*)htmlBody;
- (void)composeWithFilenames:(NSArray*)filenames;

- (void)editDraftMessage:(PSTConversation *)message;

@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic, assign) BOOL showLoginWindow;

@end

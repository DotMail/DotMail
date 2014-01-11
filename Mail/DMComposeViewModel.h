//
//  DMComposeViewModel.h
//  DotMail
//
//  Created by Robert Widmann on 7/1/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "DMTokenizingEmailField.h"

@class RACSignal, PSTConversation;

@interface DMComposeViewModel : NSObject <MTTokenFieldDelegate>

@property (nonatomic, strong) NSArray *fontSizesArray;
@property (nonatomic, strong) NSArray *toFieldAddresses;
@property (nonatomic, strong) NSArray *ccFieldAddresses;
@property (nonatomic, strong) NSArray *bccFieldAddresses;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, copy) NSAttributedString *attributedBodyText;
@property (nonatomic, copy) NSAttributedString *initialBodyText;
@property (nonatomic, strong, readonly) NSMutableArray *files;
@property (nonatomic, copy, readonly) NSString * messageID;

- (void)buttonChooseFontColor;

- (void)addFilenames:(NSArray *)files;

- (RACSignal *)saveMessage;
- (RACSignal *)sendMessage;
- (NSData *)emlDataForCurrentMessage;
- (RACSignal *)sendValidationSignal;
- (RACSignal *)colorWellMenuSignal;

- (void)validateReplyConversation:(PSTConversation *)replyConversation replyAll:(BOOL)all;
- (void)validateDraftMessage:(MCOMessageParser *)draftMessage;
- (void)validateEditableDraftMessage:(PSTConversation *)draftMessage;

@end

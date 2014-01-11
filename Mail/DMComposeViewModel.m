//
//  DMComposeViewModel.m
//  DotMail
//
//  Created by Robert Widmann on 7/1/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMComposeViewModel.h"
#import "DMAppDelegate.h"
#import "NSAttributedString+HTMLFromRange.h"
#import "DMAttachmentImageBrowserItem.h"
#import <Puissant/Puissant.h>

@interface DMComposeViewModel ()

@property (nonatomic, strong) RACSubject *colorWellSubject;

@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSArray * /* NSString */ references;
@property (nonatomic, copy) NSArray * /* NSString */ inReplyTo;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableArray *contentIDsForFiles;
@property (nonatomic, strong) NSMutableArray *fromEmails;
@property (nonatomic, copy) NSString *signatureUUID;
@property (nonatomic, assign) MCOMessageFlag currentMessageFlags;
@end

@implementation DMComposeViewModel

- (instancetype)init {
	self = [super init];
	
	self.toFieldAddresses = @[];
	self.ccFieldAddresses = @[];
	self.bccFieldAddresses = @[];
	self.fontSizesArray = @[ @"9", @"10", @"11", @"12", @"13", @"14", @"18", @"24", @"36", @"48", @"64", @"72", @"96", @"144", @"288" ];
	self.files = [[NSMutableArray alloc]init];
	self.contentIDsForFiles = [[NSMutableArray alloc]init];
	self.fromEmails = [[NSMutableArray alloc]init];
	self.signatureUUID = [[NSString dmUUIDString]stringByReplacingOccurrencesOfString:@"-" withString:@""];
	if ([self.signatureUUID componentsSeparatedByString:@"@"].count == 0) {
		self.messageID = [self.signatureUUID stringByAppendingFormat:@"@%@", [[self.signatureUUID componentsSeparatedByString:@"@"] lastObject]];
	} else {
		self.messageID = [self.signatureUUID stringByAppendingString:@"@localhost"];
	}
	self.colorWellSubject = [RACSubject subject];
	
	return self;
}

- (void)addFilenames:(NSArray *)files {
	// 26214400 bytes = 25 MegaBytes
	if (PSTAccumulateDirectorySize(files) > 26214400) {
		//
	} else {
		[self.files addObjectsFromArray:files];
		PSTPropogateValueForKey(files, {});
	}
}

- (void)validateReplyConversation:(PSTConversation *)replyConversation replyAll:(BOOL)all {
	PSTCachedMessage *replyToMessage = replyConversation.messages[0];
	if (!replyToMessage) return;
	self.toFieldAddresses = @[ replyToMessage.sender ];
	self.subject = [NSString stringWithFormat:@"Re: %@", replyToMessage.subject];
	if (all) self.ccFieldAddresses = replyToMessage.recipients;
	self.inReplyTo = replyToMessage.inReplyTo;
	self.references = replyToMessage.references;
	self.messageID = replyToMessage.messageID;
}

- (void)validateEditableDraftMessage:(PSTConversation *)draftConversation {
	PSTCachedMessage *draftMessage = draftConversation.messages[0];
	if (!draftMessage) return;
	self.toFieldAddresses = draftMessage.recipients;
	self.subject = draftMessage.subject;
//	self.ccFieldAddresses = draftMessage.recipients;
	self.inReplyTo = draftMessage.inReplyTo;
	self.references = draftMessage.references;
	self.messageID = draftMessage.messageID;
	self.initialBodyText = [[NSAttributedString alloc]initWithHTML:[draftConversation.htmlBodyValue dataUsingEncoding:NSUTF8StringEncoding] options:nil documentAttributes:nil];
}

- (void)validateDraftMessage:(MCOMessageParser *)draftMessage {
	if (!draftMessage) return;
	self.toFieldAddresses = draftMessage.header.to;
	self.subject = draftMessage.header.subject;
	self.ccFieldAddresses = draftMessage.header.cc;
	self.inReplyTo = draftMessage.header.inReplyTo;
	self.references = draftMessage.header.references;
	self.messageID = draftMessage.header.messageID;
	self.bodyText = DMParseMessagePart(draftMessage.mainPart);
}

static NSString *DMParseMessagePart(MCOAbstractPart *part) {
	MCOAttachment *part2 = (MCOAttachment *)PSTPreferredIMAPPart([part allAttachments]);
	return [part2 decodedString];
}

- (NSArray *)tokenField:(MTTokenField*)tokenField completionsForSubstring:(NSString *)substring {
	return [PSTAddressBookManager.sharedManager search:substring];
}

- (PSTLocalMessage *)_renderMessageForSending:(BOOL)forSending {
	PSTLocalMessage *msg = [[PSTLocalMessage alloc]init];
	[msg.header setUserAgent:[NSString stringWithFormat:@"dotmail %@ (build %@)", [(DMAppDelegate*)[NSApp delegate]shortVersionNumber], [(DMAppDelegate*)[NSApp delegate]bundleVersionNumber]]];
	if (self.inReplyTo) {
		[msg.header setInReplyTo:self.inReplyTo];
	}
	if (self.references) {
		[msg.header setReferences:self.references];
	}
	if (self.messageID) {
		[msg.header setMessageID:self.messageID];
	}
	[msg.header setFrom:[[self currentAccount] addressValueWithName:YES]];
	[msg.header setTo:self.toFieldAddresses];
	[msg.header setSubject:self.subject];
	if (self.ccFieldAddresses.count != 0) {
		[msg.header setCc:self.ccFieldAddresses];
	}
	if (self.bccFieldAddresses.count != 0) {
		[msg.header setBcc:self.bccFieldAddresses];
	}

	[msg setHTMLBody:[self.attributedBodyText HTMLFromRange:NSMakeRange(0, self.attributedBodyText.length)]];
	[msg setTextBody:self.bodyText];
	[msg setFlags:self.currentMessageFlags];
	for (NSString *filePath in self.files) {
		[msg addAttachment:[MCOAttachment attachmentWithContentsOfFile:filePath]];
	}
	
	return msg;
}

- (void)setToFieldAddresses:(NSArray *)toFieldAddresses {
	NSMutableArray *result = @[].mutableCopy;
	for (id address in toFieldAddresses) {
		if ([address isKindOfClass:NSString.class]) {
			[result addObject:[MCOAddress addressWithNonEncodedRFC822String:address]];
		} else {
			[result addObject:address];
		}
	}
	_toFieldAddresses = result;
}

- (PSTMailAccount *)currentAccount {
	return [PSTAccountManager.defaultManager accountForEmail:self.email];
}

- (void)buttonChooseFontColor {
	[self.colorWellSubject sendNext:nil];
}

- (RACSignal *)sendMessage {
	return [[self currentAccount]sendMessage:[self _renderMessageForSending:YES]];
}

- (RACSignal *)saveMessage {
	return [[self currentAccount]saveMessage:[self _renderMessageForSending:NO]];
}

- (NSData *)emlDataForCurrentMessage {
	return [self _renderMessageForSending:NO].data;
}

- (RACSignal *)sendValidationSignal {
	return [RACObserve(self,toFieldAddresses) flattenMap:^id(NSArray *value) {
		return [RACSignal return:@(value.count != 0)];
	}];
}

- (RACSignal *)colorWellMenuSignal {
	return self.colorWellSubject;
}

#pragma mark - IKImageBrowserDataSource

- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) aBrowser {
	return self.files.count;
}

- (id) imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index {
	DMAttachmentImageBrowserItem *item = [[DMAttachmentImageBrowserItem alloc]init];
	item.filepath = self.files[index];
	return item;
}

- (NSUInteger) imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard:(NSPasteboard *)pasteboard {
	return 0;
}

@end

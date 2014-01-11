//
//  DMSearchOperation.m
//  Puissant
//
//  Created by Robert Widmann on 7/5/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMSearchOperation.h"
#import "DMDatabase.h"
#import "DMConversation.h"
#import "DMConversationCache.h"

@implementation DMSearchOperation

- (id)init {
	self = [super init];
	
	self.suggestedSubjects = [[NSMutableSet alloc]init];
	self.suggestedPeopleByMailbox = [[NSMutableSet alloc]init];
	self.suggestedPeopleByDisplayName = [[NSMutableSet alloc]init];
	
	return self;
}

- (void)mainRequest {
	if (self.isCancelled) return;
	[self.database beginTransaction];
	[self.database optimizeIndex];
	[self.database commit];
	if (self.isCancelled) return;
	self.conversations = [self.database searchConversationsWithTerms:self.searchTerms kind:self.kind folder:self.folder otherFolder:self.otherFolder mainFolders:self.mainFolders mode:self.mode limit:self.limit returningEverything:NO];
	if (self.isCancelled) return;
	if (!self.needsSuggestions) return;
	[self performSelectorOnMainThread:@selector(_showResults) withObject:Nil waitUntilDone:YES];
	NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc]init];
	for (DMConversation *conversation in self.conversations) {
		[indexSet addIndex:conversation.conversationID];
	}
	NSArray *searchStrings = [self.searchStringToComplete.string componentsSeparatedByString:@" "];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		DMConversationCache *cache = [self.database rawConversationCacheForConversationID:idx];
		[cache computeSendersRecipient];
		for (MCOAddress *address in cache.senders) {
			
		}
		for (MCOAddress *address in cache.recipients) {
			
		}
		
		if (cache.subject.lowercaseString) {
			if ([self.database matchSearchStrings:searchStrings withString:cache.subject.lowercaseString]) {
				[self.suggestedSubjects addObject:cache.subject];
			}
		}
	}];
}

- (void)addAddressSuggestion:(MCOAddress *)address peopleByMailbox:(NSMutableSet *)peopleByMailbox peopleByName:(NSMutableSet *)peopleByName searchStrings:(NSArray *)strings peopleUniquer:(NSMutableSet *)peopleUniquer mailboxUniquer:(NSMutableSet *)mailboxUniquer {
	if (![self.database matchSearchStrings:strings withString:address.displayName]) {
		if (![self.database matchSearchStrings:strings withString:address.mailbox]) {
			return;
		}
		[peopleByMailbox addObject:address];
	}
	[peopleByName addObject:[MCOAddress addressWithDisplayName:address.displayName.lowercaseString mailbox:address.mailbox.lowercaseString]];
	[mailboxUniquer addObject:address.mailbox.lowercaseString];
}

- (void)_showResults {
	if (self.isCancelled) {
		return;
	}
	[self.delegate DMStorageOperation_updated:self];
}

@end

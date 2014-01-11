//
//  DMMarkMessagesAsDeletedOperation.m
//  Puissant
//
//  Created by Robert Widmann on 7/7/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMMarkMessagesAsDeletedOperation.h"
#import "DMDatabase.h"
#import "DMCachedMessage.h"

@implementation DMMarkMessagesAsDeletedOperation

- (void)mainRequest {
	if (self.messages.count) {
		[self.database beginTransaction];
		for (DMSerializableMessage *message in self.messages) {
			[self.database markMessageAsDeleted:message];
		}
		[self.database commit];
	}
}

@end

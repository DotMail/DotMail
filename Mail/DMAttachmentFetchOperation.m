//
//  DMAttachmentFetchOperation.m
//  Puissant
//
//  Created by Robert Widmann on 3/22/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMAttachmentFetchOperation.h"
#import "DMDatabase.h"

@implementation DMAttachmentFetchOperation

- (void)mainRequest {
	switch (self.mode) {
		case DMAttachmentFetchModeAll:
			self.attachments = [self.database attachmentsNotInTrashFolder:self.trashFolder orAllMailFolder:self.allMailfolder];
			break;
		case DMAttachmentFetchModeForFolder:
			self.attachments = [self.database attachmentsInFolder:self.selectedFolder];
			break;
		default:
			break;
	}
}

@end

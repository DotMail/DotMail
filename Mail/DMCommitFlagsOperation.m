//
//  DMCommitFlagsOperation.m
//  Puissant
//
//  Created by Robert Widmann on 4/2/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMCommitFlagsOperation.h"
#import "DMDatabase.h"
#import <MailCore/MCOIMAPFolder.h>

@implementation DMCommitFlagsOperation

- (void)mainRequest {
	for (MCOIMAPMessage *message in self.modifiedMessages) {
		[self.database commitMessageFlags:message forFolder:self.folder.path];
		[self.database setMessageFlags:(MCOAbstractMessage*)message forFolder:self.folder.path];
	}
}

@end

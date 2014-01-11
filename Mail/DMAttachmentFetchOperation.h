//
//  DMAttachmentFetchOperation.h
//  Puissant
//
//  Created by Robert Widmann on 3/22/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMStorageOperation.h"

@class MCOIMAPFolder;

typedef NS_ENUM(NSUInteger, DMAttachmentFetchMode) {
	DMAttachmentFetchModeAll,
	DMAttachmentFetchModeForFolder,
	DMAttachmentFetchModeSearch
};


@interface DMAttachmentFetchOperation : DMStorageOperation

@property (nonatomic, strong) MCOIMAPFolder *allMailfolder;
@property (nonatomic, strong) MCOIMAPFolder *trashFolder;
@property (nonatomic, strong) MCOIMAPFolder *selectedFolder;


@property (nonatomic, strong) NSArray *attachments;
@property (nonatomic, assign) DMAttachmentFetchMode mode;


@end

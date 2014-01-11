//
//  DMCommitFlagsOperation.h
//  Puissant
//
//  Created by Robert Widmann on 4/2/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMStorageOperation.h"

@class MCOIMAPFolder;

@interface DMCommitFlagsOperation : DMStorageOperation

@property (nonatomic, strong) NSArray *modifiedMessages;
@property (nonatomic, strong) MCOIMAPFolder *folder;

@end

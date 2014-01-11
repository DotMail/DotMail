//
//  DMMarkMessagesAsDeletedOperation.h
//  Puissant
//
//  Created by Robert Widmann on 7/7/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMStorageOperation.h"

@interface DMMarkMessagesAsDeletedOperation : DMStorageOperation

@property (nonatomic, strong) NSArray *pathsToCommit;
@property (nonatomic, strong) NSArray *messages;


@end

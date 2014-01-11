//
//  DMSearchOperation.h
//  Puissant
//
//  Created by Robert Widmann on 7/5/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "DMStorageOperation.h"

@interface DMSearchOperation : DMStorageOperation

@property (nonatomic, copy) NSArray *searchTerms;
@property (nonatomic) NSInteger kind;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *otherFolder;
@property (nonatomic) NSInteger mode;
@property (nonatomic) NSInteger limit;
@property (nonatomic, strong) NSDictionary *mainFolders;
@property (nonatomic) BOOL needsSuggestions;
@property (nonatomic) BOOL returnedEverything;

@property (nonatomic, copy) NSAttributedString *searchStringToComplete;
@property (nonatomic, strong) NSArray *conversations;

@property (nonatomic, strong) NSMutableSet *suggestedSubjects;
@property (nonatomic, strong) NSMutableSet *suggestedPeopleByMailbox;
@property (nonatomic, strong) NSMutableSet *suggestedPeopleByDisplayName;

@end

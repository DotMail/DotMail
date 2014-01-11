//
//  DMTokenizingEmailField.h
//  DotMail
//
//  Created by Robert Widmann on 2/2/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//


#import "MTTokenField.h"

@interface DMTokenizingEmailField : MTTokenField

@property (nonatomic, strong) NSArray *addresses;

@end

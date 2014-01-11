//
//  DMAccountCell.h
//  DotMail
//
//  Created by Robert Widmann on 7/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@class PSTMailAccount;

extern NSString * const DMAccountRequestDeletionNotification;

@interface DMAccountCell : NSTableRowView

@property (nonatomic, weak) PSTMailAccount *account;

@end

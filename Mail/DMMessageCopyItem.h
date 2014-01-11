//
//  DMMessageCopyItem.h
//  Puissant
//
//  Created by Robert Widmann on 11/10/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEPIMAPMessage;

@interface DMMessageCopyItem : NSObject

@property (nonatomic, copy) NSString *sourcePath;
@property (nonatomic, copy) NSString *destinationPath;
@property (nonatomic, assign) NSUInteger messageUID;
@property (nonatomic, assign) NSUInteger messageCopyID;
@property (nonatomic, strong) LEPIMAPMessage *message;
@property (nonatomic, strong) id deleteSource;

@end

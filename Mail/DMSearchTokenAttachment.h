//
//  DMSearchTokenAttachment.h
//  DotMail
//
//  Created by Robert Widmann on 11/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMSearchTokenAttachment : NSTextAttachment

@property (nonatomic) int kind;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) NSControlSize controlSize;
@property (nonatomic, strong) id term;

@end

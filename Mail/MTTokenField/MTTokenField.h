//
//  MTTokenField.h
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "_MTTokenTextView.h"
#import "MTTokenFieldDelegate.h"

@interface MTTokenField : NSTextField <NSTextViewDelegate>
{
    NSArray * tokenArray_;
    NSCharacterSet * tokenizingCharacterSet_;
}
@property (retain) NSArray * tokenArray;
@property (retain) NSCharacterSet * tokenizingCharacterSet;

@end

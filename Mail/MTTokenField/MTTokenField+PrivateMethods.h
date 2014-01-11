//
//  MTTokenField+PrivateMethods.h
//  MailTags
//
//  Created by smorr on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTTokenField.h"

@interface MTTokenField (PrivateMethods)
-(BOOL)shouldAddToken:(NSString*)token atTokenIndex:(NSUInteger)index;
-(void)textView:(_MTTokenTextView*)textView didChangeTokens:(NSArray*)tokens;
-(void)_setTokenArray:(NSArray*)tokenArray;
@end

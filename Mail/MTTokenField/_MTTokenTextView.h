//
//  MTTokenTextView.h
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface _MTTokenTextView : NSTextView
-(void)insertTextWithoutCompletion:(id)aString;
-(NSString*)completionStem;
-(NSArray *)getCompletionsForStem:(NSString*)stem;
-(void)setTokenArray:(NSArray*)tokenArray;
-(NSArray*)tokenArray;
-(void) insertTokenForText:(NSString*)tokenText replacementRange:(NSRange)replacementRange;
-(void)insertText:(id)aString replacementRange:(NSRange)replacementRange andBeginCompletion:(BOOL)beginCompletionFlag;

@end

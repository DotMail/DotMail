//
//  MTTokenField+PrivateMethods.m
//  MailTags
//
//  Created by smorr on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTTokenField+PrivateMethods.h"
#import "_MTTokenTextAttachment.h"

@implementation MTTokenField (PrivateMethods)

-(void)_setTokenArray:(NSArray*)tokenArray{
    if (tokenArray != tokenArray_){
        id oldArray = tokenArray_;
        tokenArray_= [tokenArray retain];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
        
        for (id atoken in tokenArray){
            
            _MTTokenTextAttachment * ta = [[_MTTokenTextAttachment alloc] initWithTitle:atoken ];
            
            NSMutableAttributedString*  tokenString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:ta]];
            [tokenString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, [tokenString length])];
            
            [tokenString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, [tokenString length])];
            [ta release];
            
            
        
            [attributedString appendAttributedString:tokenString];
            [tokenString release];
            [self setNeedsDisplay:YES];
        }
        [self setAttributedStringValue:attributedString];
        [attributedString release];
        [oldArray release];
		[self willChangeValueForKey:@"tokenArray"];
		[self didChangeValueForKey:@"tokenArray"];
    }
}
-(BOOL)shouldAddToken:(NSString*)token atTokenIndex:(NSUInteger)index{
    if ([[self delegate] respondsToSelector:@selector(tokenField:shouldAddToken:atIndex:)]){
        return  [(id <MTTokenFieldDelegate>)[self delegate] tokenField:self shouldAddToken:token atIndex:index];
    }
    return YES;
    
}
-(void)textView:(_MTTokenTextView*)textView didChangeTokens:(NSArray*)tokens{
    if ([[self delegate] respondsToSelector:@selector(tokenField:willChangeTokens:)]){
        [(id <MTTokenFieldDelegate>)[self delegate] tokenField:self willChangeTokens:tokens];
    }
    [self _setTokenArray:tokens];
    if ([[self delegate] respondsToSelector:@selector(tokenField:didChangeTokens:)]){
        [(id <MTTokenFieldDelegate>)[self delegate] tokenField:self didChangeTokens:tokens];
    }
}
@end

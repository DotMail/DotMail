//
//  MTTokenTextView.m
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "_MTTokenTextView.h"
#import "MTTokenField+PrivateMethods.h"
#import "_MTTokenCompletionWindowController.h"
#import "_MTTokenTextAttachment.h"

@interface _MTTokenTextView(private)
-(MTTokenField*)delegate;
@end

@implementation _MTTokenTextView


-(NSAttributedString*)tokenForString:(NSString*)aString{	
	_MTTokenTextAttachment * ta = [[_MTTokenTextAttachment alloc] initWithTitle:aString ];
	
    NSMutableAttributedString*  as = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:ta]];
    [as addAttribute:NSAttachmentAttributeName value:ta range:NSMakeRange(0, [as length])];
	[as addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, [as length])];
	[ta release];
	
	return [as autorelease];;
}


-(id)init{
    self = [super init];
    if (self){
        [[self textStorage] setFont:[NSFont systemFontOfSize:14]];
    }
    return self;
}
-(NSArray *)getCompletionsForStem:(NSString*)stem{
    MTTokenField * controlView = (MTTokenField *)[self delegate];
    if ([controlView respondsToSelector:@selector(delegate)]){
        id <MTTokenFieldDelegate> controlViewDelegate = (id <MTTokenFieldDelegate>)[controlView delegate];
        if ([controlViewDelegate respondsToSelector:@selector(tokenField:completionsForSubstring:)]){
            NSArray * result = [controlViewDelegate tokenField:controlView completionsForSubstring:stem];
            return result;
        }
    }
    return [NSArray array];
}
-(NSRange)forwardCompletionRange{
    NSRange effectiveRange =[self selectedRange];
    NSRange lastRange=effectiveRange;
    if (effectiveRange.location<[[self textStorage]length]){
        if ([[self textStorage] attribute:NSAttachmentAttributeName atIndex:effectiveRange.location effectiveRange:&lastRange]){
            lastRange.length =0;
        }
        
        while (effectiveRange.location<[[self textStorage]length]){
            NSRange fullrange;
            if([[self textStorage] attribute:NSAttachmentAttributeName atIndex:effectiveRange.location effectiveRange:&fullrange]){
                break;
            }
            else{
            }
            if(fullrange.location+fullrange.length<[[self textStorage]length]){
                lastRange = fullrange;
                effectiveRange.location=fullrange.location+fullrange.length;
                effectiveRange.length = 0;
            }
            else{
                break;
            }
        }
        if (lastRange.location == NSNotFound){
            lastRange.location=0;
        }
    }
    return lastRange;
}

-(NSUInteger)countOfTokensInRange:(NSRange)aRange{
    if (aRange.location ==0) return 0;
    NSUInteger count = 0;
    
    NSRange curRange = NSMakeRange(aRange.location+aRange.length-1,0);
    
    while (curRange.location!=NSNotFound && curRange.location>=aRange.location ){
        if (curRange.location < [[self textStorage] length]){
            id attribute= [[self textStorage] attribute:NSAttachmentAttributeName atIndex:curRange.location effectiveRange:&curRange];
            if (attribute) count++;
        }
        curRange = NSMakeRange(curRange.location>0?curRange.location-1:NSNotFound, 0);
    }
    return count;

    
}
-(NSRange)completionRange{
    NSRange effectiveRange =[self selectedRange];
    // scan backwards looking for the first attachment (ie token)
    while (effectiveRange.location !=NSNotFound && effectiveRange.location>0){
        NSDictionary *attr = [[self textStorage] attributesAtIndex:effectiveRange.location-1 effectiveRange:&effectiveRange];
        if ([attr objectForKey:NSAttachmentAttributeName]){
            // found an attachment - 
            effectiveRange.location+=effectiveRange.length;
            break;
        }
    }
    if (effectiveRange.location == NSNotFound){
        effectiveRange.location=0;
    }
    effectiveRange.length = [self selectedRange].location-effectiveRange.location;
    return effectiveRange;
 }

-(NSString*)completionStem{
    NSUInteger strLen =[[[self textStorage] string] length];
    NSRange completionRange = [self completionRange];
    if (completionRange.location+completionRange.length-1>strLen){
        return @"";
    }
    NSString * stem =[[[self textStorage] string] substringWithRange:completionRange];
    return stem;
}

-(void)insertTextWithoutCompletion:(id)aString{
    [super insertText:aString replacementRange:NSMakeRange([[[self textStorage] string] length],0)];
}


-(void)insertText:(id)aString replacementRange:(NSRange)replacementRange andBeginCompletion:(BOOL)beginCompletionFlag{
    if ([[_MTTokenCompletionWindowController sharedController] isDisplayingCompletions] || beginCompletionFlag ==NO){
        [super insertText:aString replacementRange:replacementRange];
        return;
    }
    else{
        NSUInteger insertionIndex = [self selectedRange].location;
        if (insertionIndex !=NSNotFound){
            NSString * rawString = [aString respondsToSelector:@selector(string)]?[aString string]:aString;
            
            if ([[self textStorage] length]==insertionIndex){
                NSRange stemRange = [self completionRange];
                NSString * stem =[[self completionStem]  stringByAppendingString:rawString];
                [[_MTTokenCompletionWindowController sharedController] setTokenizingCharacterSet:[(MTTokenField*)[self delegate] tokenizingCharacterSet]];
                [[_MTTokenCompletionWindowController sharedController] displayCompletionsForStem: stem forTextView:self forRange:stemRange];
                return;
            }
            else if (insertionIndex<[[self textStorage] length]){
                    NSRange stemRange = [self completionRange];
                    NSString * stem =[[self completionStem]  stringByAppendingString:rawString];
                    [[_MTTokenCompletionWindowController sharedController] setTokenizingCharacterSet:[(MTTokenField*)[self delegate] tokenizingCharacterSet]];
                    [[_MTTokenCompletionWindowController sharedController] displayCompletionsForStem:stem forTextView:self forRange:stemRange];
                    return;
            }
        }
        [super insertText:aString replacementRange:replacementRange];
    }
    
}
-(void) insertTokenForText:(NSString*)tokenText replacementRange:(NSRange)replacementRange{
    if ([(MTTokenField*)[self delegate] shouldAddToken: tokenText atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,replacementRange.location)] ]){
        NSAttributedString *insertionText = [self tokenForString:tokenText];
        
        [self insertText:insertionText replacementRange:replacementRange andBeginCompletion:NO];
        [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
    }
}
-(void)insertText:(id)aString replacementRange:(NSRange)replacementRange {
    if ([[_MTTokenCompletionWindowController sharedController] isDisplayingCompletions]){
        [super insertText:aString replacementRange:replacementRange];
        return;
    }
    else{
        [self insertText:aString replacementRange:replacementRange andBeginCompletion:YES];
    }
    
}
-(void)insertText:(id)aString{
    if ([[_MTTokenCompletionWindowController sharedController] isDisplayingCompletions]){
        [super insertText:aString];
        return;
    }
    NSUInteger insertionIndex = [self selectedRange].location;
    if (insertionIndex !=NSNotFound){
        if ([[self textStorage] length]==insertionIndex){
            NSRange stemRange = [self completionRange];
            
            if ([aString length]==1 && [[(MTTokenField*)[self delegate] tokenizingCharacterSet] characterIsMember:[aString characterAtIndex:0]]){
                if(stemRange.length >0){
                    if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,insertionIndex)] ]){
                        NSAttributedString *insertionText = [self tokenForString:[self completionStem]];
                        [[self textStorage] replaceCharactersInRange:stemRange withAttributedString:insertionText];
                    }
                }
              }
            else{
                NSString * stem =[[self completionStem]  stringByAppendingString:aString];
                [[_MTTokenCompletionWindowController sharedController] setTokenizingCharacterSet:[(MTTokenField*)[self delegate] tokenizingCharacterSet]];
                [[_MTTokenCompletionWindowController sharedController] displayCompletionsForStem: stem forTextView:self forRange:stemRange];
            }
            return;
        }
        else if (insertionIndex<[[self textStorage] length]){
             NSRange stemRange = [self completionRange];
            if ([aString length]==1 && [[(MTTokenField*)[self delegate] tokenizingCharacterSet] characterIsMember:[aString characterAtIndex:0]]){
                if(stemRange.length >0){
                    if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,insertionIndex)] ]){
                        NSAttributedString *insertionText = [self tokenForString:[self completionStem]];
                        [[self textStorage] replaceCharactersInRange:stemRange withAttributedString:insertionText];
                    }
                }
            }
            else{
                if ([[self textStorage] attribute:NSAttachmentAttributeName atIndex:insertionIndex effectiveRange:nil]){
                    NSRange stemRange = [self completionRange];
                    NSString * stem =[[self completionStem]  stringByAppendingString:aString];
                    [[_MTTokenCompletionWindowController sharedController] setTokenizingCharacterSet:[(MTTokenField*)[self delegate] tokenizingCharacterSet]];
                    [[_MTTokenCompletionWindowController sharedController] displayCompletionsForStem:stem forTextView:self forRange:stemRange];
                }
                else{
                    // just insert the text without completing -- don't call super insertText as that will start a completion by default.
                    [super insertText:aString replacementRange:[self selectedRange] ];
                }
            }
             return;
            
        }
    }
    [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
    [super insertText:aString];
}


-(NSArray*)tokenArray{
    NSMutableArray * tokenArray = [NSMutableArray array];
    
    if ([[self textStorage] length]){
        NSRange curRange = NSMakeRange([[self textStorage] length]-1,0);
        while (curRange.location!=NSNotFound ){
            id attribute= [[self textStorage] attribute:NSAttachmentAttributeName atIndex:curRange.location effectiveRange:&curRange];
            if (attribute) [tokenArray insertObject: [attribute title] atIndex:0];
            curRange = NSMakeRange(curRange.location>0?curRange.location-1:NSNotFound, 0);
        }
    }
    return tokenArray;
    
}
-(void)setTokenArray:(NSArray*)tokenArray{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
    
    for (id atoken in tokenArray){
        NSAttributedString *insertionText = [self tokenForString:atoken];
        [attributedString appendAttributedString:insertionText];
    }
    [[self textStorage] setAttributedString:attributedString];
    [attributedString release];
    
}


-(void)tokenizeRemainingText{
    if ([[self textStorage] length]){
        NSRange curRange = NSMakeRange([[self textStorage] length]-1,0);
        while (curRange.location!=NSNotFound ){
            if(![[self textStorage] attribute:NSAttachmentAttributeName atIndex:curRange.location effectiveRange:&curRange]){
                if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,curRange.location)] ]){
                    NSString *string = [[[self textStorage] string] substringWithRange:curRange];
                    NSAttributedString *insertionText = [self tokenForString:string];
                    
                    [[self textStorage] replaceCharactersInRange:curRange withAttributedString:insertionText];
                }
               
            }
            curRange = NSMakeRange(curRange.location>0?curRange.location-1:NSNotFound, 0);
            
        }
    }
    [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
    
}
-(void)commitTokens{
    [self tokenizeRemainingText];
}

-(BOOL)resignFirstResponder{
    [self tokenizeRemainingText];
    return [super resignFirstResponder];
}


-(void)doCommandBySelector:(SEL)aSelector{
    if (aSelector == @selector(deleteBackward:)){
        NSArray * currentTokens = [self tokenArray];
        [super doCommandBySelector:aSelector];
        if (![currentTokens isEqualToArray:[self tokenArray]]){
           [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];

        }
        return;
    }
    if (aSelector == @selector(moveRight:) ){
        if ([[self completionStem] length]){
            NSRange selRange = [self selectedRange];
            if (selRange.location+selRange.length<[[self textStorage] length]){
                selRange.location+=selRange.length;
                if([[self textStorage] attribute:NSAttachmentAttributeName atIndex:selRange.location effectiveRange:0]){
                    if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,selRange.location)] ]){

                        NSAttributedString *insertionText = [self tokenForString:[self completionStem]];
                        [[self textStorage] replaceCharactersInRange:[self completionRange] withAttributedString:insertionText];
                        [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
                    }
                }
            }
        }
        
    }
    if (aSelector   == @selector(moveLeft:)){
        if ([self selectedRange].location>0){
            if ([[self textStorage] attribute:NSAttachmentAttributeName atIndex:[self selectedRange].location-1 effectiveRange:nil]){
                NSRange completionRange = [self forwardCompletionRange];
                if (completionRange.length>0){
                    NSString *string = [[[self textStorage] string] substringWithRange:completionRange];
                    if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,completionRange.location)] ]){

                        NSAttributedString *insertionText = [self tokenForString:string];
                        [[self textStorage] replaceCharactersInRange:[self completionRange] withAttributedString:insertionText];
                        [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
                     }
                    
                }
            }
        }
    }
    if ( aSelector  == @selector(insertTab:)) {
        id kv = [(MTTokenField*)[self delegate] nextValidKeyView];
        [[(NSView*)[self delegate] window] makeFirstResponder:kv ];
        return;
    }
    if ( aSelector  == @selector(insertBacktab:)) {
        id kv = [(MTTokenField*)[self delegate] previousValidKeyView];
        [[(NSView*)[self delegate] window] makeFirstResponder:kv ];
        return;
    }
    if ( aSelector  == @selector(insertNewline:)) {
        if ([[self completionStem] length]){
            NSRange completionRange = [self completionRange];
            if ([(MTTokenField*)[self delegate] shouldAddToken: [self completionStem ] atTokenIndex:[self countOfTokensInRange:NSMakeRange(0,completionRange.location)] ]){

                NSAttributedString *insertionText = [self tokenForString:[self completionStem]];
                [[self textStorage] replaceCharactersInRange:completionRange withAttributedString:insertionText];
                [(MTTokenField*)[self delegate] textView:self didChangeTokens: [self tokenArray]];
            }
        }
            
        return;
    }
    [super doCommandBySelector:aSelector];
}

@end

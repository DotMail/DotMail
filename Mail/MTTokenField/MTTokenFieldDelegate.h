//
//  MTTokenFieldDelegate.h
//  MailTags
//
//  Created by smorr on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTTokenField;

@protocol MTTokenFieldDelegate <NSObject,NSTextFieldDelegate>
@optional

-(NSArray *)tokenField:(MTTokenField *)tokenField completionsForSubstring:(NSString *)substring;

-(void)tokenField:(MTTokenField *) tokenField didChangeTokens:(NSArray*)tokens;

-(void)tokenField:(MTTokenField *) tokenField willChangeTokens:(NSArray*)tokens;

-(BOOL)tokenField:(MTTokenField *) tokenField shouldAddToken:(NSString *)token atIndex:(NSUInteger)index;


@end

//
//  MTTokenCompletionWindowController.h
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "_MTTokenTextView.h"
#import "_MTTokenCompletionTableView.h"

@interface _MTTokenCompletionWindowController : NSWindowController <NSTableViewDelegate,NSTableViewDataSource,NSWindowDelegate>
{
    NSWindow * completionWindow;
    __unsafe_unretained _MTTokenTextView * textView;
    id _eventMonitor;
    NSMutableString* completionStem_;
    NSUInteger completionIndex_;
    NSArray * completionsArray_;
    _MTTokenCompletionTableView * tableView_;
    NSCharacterSet* tokenizingCharacterSet_;
    
 }
@property (retain)NSArray * completionsArray;
@property (assign)_MTTokenTextView* textView;
@property (retain)NSMutableString *completionStem;
@property (assign)NSUInteger completionIndex;
@property (retain)_MTTokenCompletionTableView* tableView;
@property (retain)NSCharacterSet* tokenizingCharacterSet;
+ (id)sharedController;
-(void)displayCompletionsForStem:(NSString*) stem forTextView:(NSTextView*)aTextView forRange:(NSRange)stemRange;
-(void)tearDownWindow;
-(BOOL)isDisplayingCompletions;

@end

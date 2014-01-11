//
//  MTTokenCompletionTableView.m
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "_MTTokenCompletionTableView.h"

@implementation _MTTokenCompletionTableView

-(void) resetWindowFrame{
    CGFloat totalHeight = MIN([self numberOfRows],10)*([self rowHeight]+[self intercellSpacing].height);
    NSRect f= [[self window] frame];
    CGFloat top =NSMaxY(f);
    CGFloat bottom = top-totalHeight;
    f = NSMakeRect(NSMinX(f), bottom, NSWidth(f), totalHeight);
    [[self window] setFrame:f display:YES];
}

-(void)reloadData{
    
    [super reloadData];
    [self resetWindowFrame];
}
@end

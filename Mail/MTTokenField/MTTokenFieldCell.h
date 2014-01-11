//
//  MTTokenFieldCell.h
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MTTokenFieldCell : NSTextFieldCell <NSTextViewDelegate>
{
    NSCharacterSet * tokenizingCharacterSet_;
	BOOL mIsEditingOrSelecting;
   
}
@property (retain) NSCharacterSet * tokenizingCharacterSet;

@end

//
//  MTTokenField.m
//  TokenField
//
//  Created by smorr on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTokenField.h"
#import "MTTokenFieldCell.h"
#import "_MTTokenTextAttachment.h"
#import "_MTTokenTextView.h"
#import "MTTokenField+PrivateMethods.h"

@implementation MTTokenField
@dynamic tokenArray;
@synthesize tokenizingCharacterSet= tokenizingCharacterSet_;


-(void)dealloc{
    [tokenArray_ release];
    [tokenizingCharacterSet_ release];
    [super dealloc];
}


-(NSArray*)tokenArray{
    return [[tokenArray_ retain] autorelease];
}

-(void)setTokenArray:(NSArray*)tokenArray{
    if (tokenArray != tokenArray_){
        [self _setTokenArray: tokenArray];
        
        id fieldEditor = [[self cell] fieldEditorForView:self] ;
            if ([fieldEditor delegate] == self)
                [(_MTTokenTextView*)[[self cell] fieldEditorForView:self] setTokenArray:tokenArray];

    }
    
}

-(void)setObjectValue:(NSArray*)tokenArray{
    [self setTokenArray:tokenArray];
}
-(NSArray*)objectValue{
    return [self tokenArray];;
    
}

+(Class)cellClass{
    return [MTTokenFieldCell class];   
}

-(void)awakeFromNib{
    [self setFont:[NSFont fontWithName:@"HelveticaNeue" size:14]];

}

-(BOOL)textShouldBeginEditing:(NSText *)textObj{
   return YES;
}


- (BOOL)textShouldEndEditing:(NSText *)textObj{
    return YES;
}

@end

//
//  NSStringHTMLEntities.m
//  HTMLTranslator
//
//  Created by Uli Kusterer on Thu Aug 12 2004.
//  Copyright (c) 2004 Uli Kusterer.
//
//	This software is provided 'as-is', without any express or implied
//	warranty. In no event will the authors be held liable for any damages
//	arising from the use of this software.
//
//	Permission is granted to anyone to use this software for any purpose,
//	including commercial applications, and to alter it and redistribute it
//	freely, subject to the following restrictions:
//
//	   1. The origin of this software must not be misrepresented; you must not
//	   claim that you wrote the original software. If you use this software
//	   in a product, an acknowledgment in the product documentation would be
//	   appreciated but is not required.
//
//	   2. Altered source versions must be plainly marked as such, and must not be
//	   misrepresented as being the original software.
//
//	   3. This notice may not be removed or altered from any source
//	   distribution.
//

#import "NSString+HTMLEntities.h"


@implementation NSString (UKHTMLEntities)

-(NSString*) stringByInsertingHTMLEntities
{
    return [self stringByInsertingHTMLEntitiesAndLineBreaks: YES];
}

-(NSString*) stringByInsertingHTMLEntitiesAndLineBreaks: (BOOL)br
{
	NSUInteger				count = [self length];
	NSMutableString*		actualText = [NSMutableString stringWithCapacity: count];
	unsigned				x = 0;
	static NSDictionary*	entitiesTable = nil;
	
	if( !entitiesTable )
	{
		NSString*		dictPath = [[NSBundle mainBundle] pathForResource: @"HTMLEntities" ofType: @"plist"];
		entitiesTable = [[NSDictionary dictionaryWithContentsOfFile: dictPath] retain];
	}
	
	for( x = 0; x < count; x++ )
	{
		unichar			theCh = [self characterAtIndex: x];
		NSString*		theChStr = [NSString stringWithCharacters: &theCh length: 1];
		
		if( theCh < 128 && theCh != '&' && theCh != '<'    // Valid ASCII range, and none of the specially escaped ones? Just take it along:
		   && theCh != '>' && theCh != '"' )
        {
            if( br && (theCh == '\r' || theCh == '\n') )
                [actualText appendString: @"<br>\n"];
            else
                [actualText appendString: theChStr];
        }
		else
		{
			NSString*		finalChStr = [entitiesTable objectForKey: theChStr];
			if( !finalChStr )
				[actualText appendString: [NSString stringWithFormat: @"&#%d;", theCh]];
			else
				[actualText appendString: finalChStr];
		}
	}
	
	return actualText;
}

@end
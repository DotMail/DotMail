//
//  NSAttributedString+HTMLFromRange.m
//  PosterChild
//
//  Created by Uli Kusterer on 22.03.05.
//  Copyright 2005 M. Uli Kusterer.
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

#import "NSAttributedString+HTMLFromRange.h"
#import "NSString+HTMLEntities.h"


@implementation NSAttributedString (UKHTMLFromRange)

NSString* FontSizeToHTMLSize( NSFont* fnt )
{
    long intSize = roundtol([fnt pointSize]);
    
    if( intSize <= 9 )
        return @"-2";
    if( intSize <= 12 )
        return @"-1";
    if( intSize <= 14 )
        return @"4";
    if( intSize <= 16 )
        return @"+1";
    if( intSize > 16 )
        return @"+2";
    else
        return @"4";
}

NSString *ColorToHTMLColor( NSColor* tcol )
{
    NSColor *rgbColor = [tcol colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
    CGFloat r, g, b, a;
    
    [rgbColor getRed: &r green: &g blue: &b alpha: &a];
    
    return [NSString stringWithFormat:@"#%2.2X%2.2X%2.2X", (int)(255 * r), (int)(255 * g), (int)(255 * b)];
}

-(NSString*)    HTMLFromRange: (NSRange)range
{
    NSUInteger location = 0;
    NSRange effRange;
    NSMutableString * str = [NSMutableString string];
    NSMutableString *endStr = [NSMutableString string];
    NSDictionary *attrs = nil;
    NSDictionary *oldAttrs = nil;
    
    NSUInteger finalLen = range.location +range.length;
    
    // TODO: Use oldAttrs, add NSForegroundColorAttributeName and
    
    attrs = [self attributesAtIndex: location effectiveRange: &effRange];
    location = effRange.location +effRange.length;
    
    // Oblique changed?
    NSNumber* obliq = [attrs objectForKey: NSObliquenessAttributeName];
    if( obliq && obliq != [oldAttrs objectForKey: NSObliquenessAttributeName]
	   && [obliq floatValue] > 0 )
    {
        [str appendString: @"<sup>"];
        [endStr insertString: @"</sup>" atIndex: 0];
    }
    // Font/color changed?
    NSFont* fnt = [attrs objectForKey: NSFontAttributeName];
    NSColor* tcol = [attrs objectForKey: NSForegroundColorAttributeName];
    if( fnt || tcol )
    {
        [str appendString: @"<font"];
        if( fnt )
        {
            [str appendFormat: @" face=\"%@\"", [fnt familyName]];
            [str appendFormat: @" size=\"%@\"", FontSizeToHTMLSize(fnt)];
        }
        if( tcol )
        {
            [str appendFormat: @" color=\"%@\"", ColorToHTMLColor(tcol)];
        }
        [str appendString: @">"];
        [endStr insertString: @"</font>" atIndex: 0];
		
        NSFontTraitMask trt = [[NSFontManager sharedFontManager] traitsOfFont: fnt];
        if( (trt & NSItalicFontMask) == NSItalicFontMask )
        {
            if( !obliq || [obliq floatValue] == 0 ) // Don't apply twice.
            {
                [str appendString: @"<i>"];
                [endStr insertString: @"</i>" atIndex: 0];
            }
        }
        if( (trt & NSBoldFontMask) == NSBoldFontMask
		   || [[NSFontManager sharedFontManager] weightOfFont: fnt] >= 9 )
        {
            [str appendString: @"<b>"];
            [endStr insertString: @"</b>" atIndex: 0];
        }
        if( (trt & NSFixedPitchFontMask) == NSFixedPitchFontMask )
        {
            [str appendString: @"<tt>"];
            [endStr insertString: @"</tt>" atIndex: 0];
        }
    }
    // Superscript changed?
    NSNumber* supers = [attrs objectForKey: NSSuperscriptAttributeName];
    if( supers && supers != [oldAttrs objectForKey: NSSuperscriptAttributeName] )
    {
        [str appendString: @"<sup>"];
        [endStr insertString: @"</sup>" atIndex: 0];
    }
    
    // Actual text and closing tags:
    [str appendString: [[[self string] substringWithRange:effRange] stringByInsertingHTMLEntitiesAndLineBreaks: YES]];
    [str appendString: endStr];
    
    while( location < finalLen )
    {
        [endStr setString: @""];
        attrs = [self attributesAtIndex: location effectiveRange: &effRange];
        location = effRange.location +effRange.length;
        
        // Font/color changed?
        NSFont* fnt = [attrs objectForKey: NSFontAttributeName];
        NSColor* tcol = [attrs objectForKey: NSForegroundColorAttributeName];
        if( fnt || tcol )
        {
            [str appendString: @"<font"];
            if( fnt )
            {
                [str appendFormat: @" face=\"%@\"", [fnt familyName]];
                [str appendFormat: @" size=\"%@\"", FontSizeToHTMLSize(fnt)];
            }
            if( tcol )
            {
                [str appendFormat: @" color=\"%@\"", ColorToHTMLColor(tcol)];
            }
            [str appendString: @">"];
            [endStr insertString: @"</font>" atIndex: 0];
			
            NSFontTraitMask trt = [[NSFontManager sharedFontManager] traitsOfFont: fnt];
            if( (trt & NSItalicFontMask) == NSItalicFontMask )
            {
                if( !obliq || [obliq floatValue] == 0 ) // Don't apply twice.
                {
                    [str appendString: @"<i>"];
                    [endStr insertString: @"</i>" atIndex: 0];
                }
            }
            if( (trt & NSBoldFontMask) == NSBoldFontMask
			   || [[NSFontManager sharedFontManager] weightOfFont: fnt] >= 9 )
            {
                [str appendString: @"<b>"];
                [endStr insertString: @"</b>" atIndex: 0];
            }
            if( (trt & NSFixedPitchFontMask) == NSFixedPitchFontMask )
            {
                [str appendString: @"<tt>"];
                [endStr insertString: @"</tt>" atIndex: 0];
            }
        }
        // Superscript changed?
        NSNumber* supers = [attrs objectForKey: NSSuperscriptAttributeName];
        if( supers && supers != [oldAttrs objectForKey: NSSuperscriptAttributeName] )
        {
            [str appendString: @"<sup>"];
            [endStr insertString: @"</sup>" atIndex: 0];
        }
        
        // Actual text and closing tags:
        [str appendString: [[[self string] substringWithRange:effRange] stringByInsertingHTMLEntitiesAndLineBreaks: YES]];
        [str appendString: endStr];
    }
    
    return str;
}

@end
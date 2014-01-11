//
//  _MTTokenTextAttachment.m
//  TokenField
//
//  Created by smorr on 11-12-01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "_MTTokenTextAttachment.h"

@implementation _MTTokenTextAttachment
@synthesize representedObject,title;
-(id)initWithTitle:(NSString*)aTitle {
    self = [self init];
    if (self){
        title = [aTitle copy];        
        _MTTokenTextAttachmentCell* tac = [[_MTTokenTextAttachmentCell alloc] init];
        tac.tokenTitle = title;
        [self setAttachmentCell: tac];
        [tac release];
    }
    return self;
}
-(id)description{
    return [NSString stringWithFormat:@"<%@ %p Title: %@ | cell: %@>",[self class]  ,self, self.title,[self attachmentCell]];
}
-(id)copyWithZone:(id)zone{
    return nil; 
}
-(id)mutableCopy{
    return nil;   
}
-(void)dealloc{
    self.representedObject    = nil;
    self.title = nil;
    [super dealloc];
}
@end


@implementation _MTTokenTextAttachmentCell
@synthesize tokenTitle;
@synthesize selected;


-(void)dealloc{
    self.tokenTitle = nil;
    [alternateImage release];
    alternateImage = nil;
    
    [super dealloc];
    
}

-(NSPoint)cellBaselineOffset{
	NSPoint superPoint =[super cellBaselineOffset];
	superPoint.y-=3.0;
	return superPoint;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [self retain];
}
-(id)copyWithZone:(NSZone *)zone{
    return [self retain];
}
-(NSImage *) image{
    static NSDictionary * _fontAttibutes = nil;
    if (!_fontAttibutes) _fontAttibutes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont systemFontOfSize:14],NSFontAttributeName, nil];
	
	NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:self.tokenTitle attributes:_fontAttibutes];
    if (!attributedString)  return nil;
    NSSize imgSize =NSMakeSize([attributedString size].width+36, [attributedString size].height+0);
    if (imgSize.width==0 || imgSize.height==0) {
		[attributedString release];
        return nil;
	}
    
	NSImage * image = [[[NSImage alloc] initWithSize:imgSize] autorelease];
	[image lockFocus];
	
    NSRect pathRect = NSMakeRect(2, 1, [attributedString size].width+31, [attributedString size].height-2);
	CGFloat radius = 6;
    NSBezierPath * path = [NSBezierPath bezierPath];
	
    CGFloat minimumX	= NSMinX(pathRect) - 0.5; // subtract half values to mitigate anti-aliasing
    CGFloat maximumX	= NSMaxX(pathRect) - 0.25;
    CGFloat minimumY	= NSMinY(pathRect) - 0.5;
    CGFloat maximumY	= NSMaxY(pathRect) - 0.5;
	CGFloat midY		= NSMidY(pathRect);
    CGFloat midX		= NSMidX(pathRect);
    
	// bottom right curve and bottom edge 
    [path moveToPoint: NSMakePoint(midX, minimumY)];
    [path appendBezierPathWithArcFromPoint: NSMakePoint(maximumX, minimumY) toPoint: NSMakePoint(maximumX, midY) radius: radius-.5];
    
	// top right curve and right edge 
    [path appendBezierPathWithArcFromPoint: NSMakePoint(maximumX, maximumY) toPoint: NSMakePoint(midX, maximumY) radius: radius-.5];
    
	// top left curve and top edge
    [path appendBezierPathWithArcFromPoint: NSMakePoint(minimumX, maximumY) toPoint: NSMakePoint(minimumX, midY) radius: radius];
    
	// bottom left curve and left edge 
    [path appendBezierPathWithArcFromPoint: NSMakePoint(minimumX, minimumY) toPoint: NSMakePoint(midX, minimumY) radius: radius];
    [path closePath];

    
    
    [path setLineWidth:1.0];
	if (self.selected)
		[[NSColor colorWithCalibratedRed:0.671 green:0.706 blue:0.773 alpha:1.000] set];
	else {
		[[NSColor colorWithCalibratedRed:0.851 green:0.906 blue:0.973 alpha:1.000] set];	
	}
    
	[path fill];
	[[NSColor colorWithCalibratedRed:.588 green:0.749 blue:0.929 alpha:1.000] set];
	[path stroke];
	[[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.0]set];
    
    [attributedString drawInRect:NSMakeRect(17, 0, [attributedString size].width+10, [attributedString size].height)];
	[attributedString release];
	[image unlockFocus];
	
	return image;
}


@end
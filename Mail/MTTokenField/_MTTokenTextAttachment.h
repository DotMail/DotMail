//
//  _MTTokenTextAttachment.h
//  TokenField
//
//  Created by smorr on 11-12-01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface _MTTokenTextAttachment : NSTextAttachment
{
    id representedObject;
    NSString * title;
}

@property (retain) id representedObject;
@property (copy) NSString * title;

-(id)initWithTitle:(NSString*)aTitle;

@end


@interface _MTTokenTextAttachmentCell :NSTextAttachmentCell{
	NSImage * alternateImage;
	NSString * tokenTitle;
	BOOL selected;
}
@property (retain) NSString *tokenTitle;
@property (assign) BOOL selected;
@end
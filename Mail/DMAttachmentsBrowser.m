//
//  DMAttachmentsBrowser.m
//  DotMail
//
//  Created by Robert Widmann on 6/4/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAttachmentsBrowser.h"
#import "DMAttachmentCell.h"
#import "DMAppDelegate.h"

@implementation DMAttachmentsBrowser

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* key = [theEvent charactersIgnoringModifiers];
    if([key isEqual:@" "]) {
        [[NSApp delegate] togglePreviewPanel:self];
    } else {
		[super keyDown:theEvent];
		switch (theEvent.keyCode) {
			case 123:
			case 124:
			case 125:
			case 126:
				if ([[QLPreviewPanel sharedPreviewPanel]isVisible]) [[QLPreviewPanel sharedPreviewPanel]reloadData];
				break;
				
			default:
				break;
		}
    }
}




@end

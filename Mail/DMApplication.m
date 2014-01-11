//
//  DMApplication.m
//  DotMail
//
//  Created by Robert Widmann on 7/3/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMApplication.h"
#import "DMAppDelegate.h"
#include <objc/runtime.h>

static char CTP_SHEET_HANDLER_KEY;

@implementation DMApplication

- (void)dm_beginSheet:(NSWindow *)sheet modalForWindow:(NSWindow *)modalWindow completion:(DMSheetHandler)handler {
	NSParameterAssert(handler != NULL);
	[self setHandler:handler];
	[self beginSheet:sheet modalForWindow:modalWindow modalDelegate:self didEndSelector:@selector(dm_sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)dm_sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	self.handler(returnCode);
	[sheet orderOut:nil];
}

- (DMSheetHandler)handler {
	return objc_getAssociatedObject(self, &CTP_SHEET_HANDLER_KEY);
}

- (void)setHandler:(DMSheetHandler)handler {
	objc_setAssociatedObject(self, &CTP_SHEET_HANDLER_KEY, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)dm_presentError:(NSError *)error modalForWindow:(NSWindow *)window {
//	[[NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]]beginSheetModalForWindow:window completionHandler:NULL];
}

@end

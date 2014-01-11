//
//  DMSearchTokenTextView.m
//  DotMail
//
//  Created by Robert Widmann on 11/12/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSearchTokenTextView.h"

static CFArrayRef DMSearchPasteboardTypes = NULL;
static OSSpinLock DMSearchPasteboardLock = OS_SPINLOCK_INIT;

@implementation DMSearchTokenTextView

+ (void)initialize {
	if (self.class == DMSearchTokenTextView.class) {
		CFTypeRef types[2] = { CFSTR("DMSearchTokenPasteboardType"), (__bridge CFStringRef)NSPasteboardTypeString };
		DMSearchPasteboardTypes = CFArrayCreate(NULL, types, 1, &kCFTypeArrayCallBacks);
	}
}

+ (NSArray *)dmPasteboardTypes {
	NSArray *values = nil;
	OSSpinLockLock(&DMSearchPasteboardLock);
	values = (__bridge NSArray *)DMSearchPasteboardTypes;
	OSSpinLockUnlock(&DMSearchPasteboardLock);
	return values;
}

@end

//
//  DMConversationViewController+DMJavaScript.m
//  DotMail
//
//  Created by Robert Widmann on 11/2/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMConversationViewController+DMJavaScript.h"
#import <libkern/OSAtomic.h>

static CFMutableSetRef DMWebScriptSelectorCache;
static OSSpinLock _cacheLock = OS_SPINLOCK_INIT;

@implementation DMConversationViewController (DMJavaScript)


+ (void)load {
	if (self.class == DMConversationViewController.class) {
		OSSpinLockLock(&_cacheLock);
		DMWebScriptSelectorCache = CFSetCreateMutable(NULL, 1, NULL);
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsSortOrderFromOlderToNewer));
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsIsMessageHeadersAlwaysVisible));
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsLoadMessageIfNeeded:));
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsSetSelectedAttachmentWithMessageID:partID:));
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsLog:));
		CFSetSetValue(DMWebScriptSelectorCache, @selector(jsMessageIDs));
		OSSpinLockUnlock(&_cacheLock);
	}
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector {
	BOOL excluded = NO;
//	OSSpinLockLock(&_cacheLock);
//	excluded = !CFSetContainsValue(DMWebScriptSelectorCache, aSelector);
//	OSSpinLockUnlock(&_cacheLock);
	return excluded;
}

- (CFBooleanRef)jsSortOrderFromOlderToNewer {
	return kCFBooleanTrue;
}

- (void)jsIsMessageHeadersAlwaysVisible {
//	return (void *)kCFBooleanFalse;
}

- (void)jsLoadMessageIfNeeded:(NSString *)object {
//	return (void *)kCFBooleanTrue;
}

- (void)jsSetSelectedAttachmentWithMessageID:(NSString *)messageID partID:(NSString *)partID {
	CFBooleanRef result = kCFBooleanTrue;
	if (_selectedCurrentMessageID || messageID) {
		result = kCFBooleanFalse;
		if ([_selectedCurrentMessageID isEqualToString:messageID]) {
			result = kCFBooleanTrue;
		}
	}
	if (_selectedCurrentPartID || partID) {
		if (![_selectedCurrentPartID isEqualToString:partID]) {
			result = kCFBooleanFalse;
		}
	}
	if (!result) {
		_selectedCurrentMessageID = messageID.copy;
		_selectedCurrentPartID = partID.copy;
		if (_selectedCurrentMessageID != nil) {
			[self.webView setSelectedDOMRange:nil affinity:NSSelectionAffinityUpstream];
		}
	}
	return;
}

- (void)jsShowMenu:(id)arg locationX:(NSNumber *)x locationY:(NSNumber *)y {
	
}

- (CFBooleanRef)jsIsWindowMode {
	return kCFBooleanFalse;
}

- (CFBooleanRef)jsQuickReplyDisabled {
	return kCFBooleanFalse;
}

- (void)jsLog:(NSString *)str {
	NSLog(@"%@", str);
}

- (NSArray *)jsMessageIDs {
	return self.displayMessageIDs;
}

@end

//
//  DMSecureTextField.m
//  DotMail
//
//  Created by Robert Widmann on 12/27/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMSecureTextField.h"
#import <TwUI/CoreText+Additions.h>

@implementation DMSecureTextField

- (Class)textEditorClass {
	return [DMSecureTextEditor class];
}

@end

@implementation DMSecureTextEditor

- (instancetype)init {
	if (self = [super init]) {
		[self setSecure:YES];
	}
	return self;
}

- (BOOL)isSecure {
	return YES;
}

//Dirty, nasty, god-awful, evil, downright (... did I say dirty yet?) HACK!
- (CGRect)firstRectForCharacterRange:(CFRange)range {
	CFIndex rectCount = 1;
	CGRect rects[rectCount];
	AB_CTFrameGetRectsForRange([self ctFrame], range, rects, &rectCount);
	if(rectCount > 0) {
		return rects[0];
	}
	return CGRectMake(12, CGRectGetMidY(self.frame), 0, 0);
}


@end

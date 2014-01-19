//
//  DMAssistantViewController.m
//  DotMail
//
//  Created by Robert Widmann on 11/9/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAssistantViewController.h"

@implementation DMAssistantViewController

- (instancetype)init {
	if (self = [super init]) {
		_info = [NSMutableDictionary dictionary];
	}
	return self;
}

- (NSString *)title {
	return @"";
}

- (void)resetUI {}

- (void)setInfoValue:(id)value forKey:(id)key {
	if (value == nil) {
		[self removeInfoValueForKey:key];
	} else {
		[self.info setObject:value forKey:key];
	}
}

- (void)removeInfoValueForKey:(id)key {
	[self.info removeObjectForKey:key];
}

- (void)setInfo:(NSMutableDictionary *)info {
	[self.info removeAllObjects];
	[self.info addEntriesFromDictionary:info];
}

- (CGSize)contentSize {
	return CGSizeZero;
}

@end

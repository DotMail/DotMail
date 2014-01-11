//
//  DMPersistentStateManager.m
//  DotMail
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMPersistentStateManager.h"
#import "NSColor+DMUIColors.h"

static NSMutableArray *colors = nil;

@interface DMPersistentStateManager ()
@property (nonatomic, strong) NSMutableDictionary *blockMap;
@end

@implementation DMPersistentStateManager

+ (instancetype)sharedManager {
	static DMPersistentStateManager *obj;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		obj = [[DMPersistentStateManager alloc]init];
	});
	return obj;
}

- (instancetype)init {
	self = [super init];
	
	_blockMap = @{}.mutableCopy;
	
	return self;
}

- (void)registerObserverForUserDefaultsKey:(NSString *)keyPath withBlock:(void (^)())block {
	[NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	self.blockMap[keyPath] = [block copy];
}

- (void)removeObserverForUserDefaultsKey:(NSString *)keyPath {
	[NSUserDefaults.standardUserDefaults removeObserver:self forKeyPath:keyPath];
	[self.blockMap removeObjectForKey:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	void (^callBackBlock)() = self.blockMap[keyPath];
	if (callBackBlock != NULL) {
		callBackBlock();
	}
}

- (id)objectForKeyedSubscript:(id)key {
	NSAssert([key conformsToProtocol:@protocol(NSCopying)], @"Key passed to %@ that does not conform to NSCopying", NSStringFromClass(self));
	return [NSUserDefaults.standardUserDefaults objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
	NSAssert([key conformsToProtocol:@protocol(NSCopying)], @"Key passed to %@ that does not conform to NSCopying", NSStringFromClass(self));
	[NSUserDefaults.standardUserDefaults setObject:obj forKey:key];
}

- (void)dealloc {
	[self.blockMap enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id obj, BOOL *stop) {
		[NSUserDefaults.standardUserDefaults removeObserver:self forKeyPath:keyPath];
	}];
	[self.blockMap removeAllObjects];
}

+ (NSMutableArray *)labelColorsList {
	if (colors == nil) {
		NSString *labelsColorPath = [[NSBundle mainBundle] pathForResource:@"label-colors" ofType:@"plist"];
		NSArray *hexValues = [NSArray arrayWithContentsOfFile:labelsColorPath];
		colors = [NSMutableArray array];
		for (NSString *hexValue in hexValues) {
			[colors addObject:[NSColor colorFromHexadecimalValue:hexValue]];
		}
	}
	return colors;
}

@end

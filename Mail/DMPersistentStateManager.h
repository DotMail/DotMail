//
//  DMPersistentStateManager.h
//  DotMail
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPersistentStateManager : NSObject

+ (instancetype)sharedManager;
- (void)registerObserverForUserDefaultsKey:(NSString *)keyPath withBlock:(void (^)())block;
- (void)removeObserverForUserDefaultsKey:(NSString *)key;

@end

@interface DMPersistentStateManager (DMLabelColors)

+ (NSMutableArray *)labelColorsList;

@end

@interface DMPersistentStateManager (DMSubscripting)

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
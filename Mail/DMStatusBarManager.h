//
//  DMStatusBarManager.h
//  DotMail
//
//  Created by Robert Widmann on 12/22/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMStatusBarManager : NSObject

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;

+ (instancetype)defaultManager;

@end

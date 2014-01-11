//
//  DMToolbarButton.h
//  DotMail
//
//  Created by Robert Widmann on 6/28/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@interface DMToolbarButton : NSButton

- (instancetype)initWithImage:(NSImage *)image;
- (RACSignal *)rac_selectionSignal;

@end

@interface DMBadgedToolbarButton : DMToolbarButton

- (void)setBadgeCount:(NSUInteger)count;

@end

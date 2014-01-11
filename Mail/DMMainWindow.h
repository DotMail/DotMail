//
//  DMMainWindow.h
//  DotMail
//
//  Created by Robert Widmann on 9/2/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import "INAppStoreWindow.h"

@class DMMainViewController;

@interface DMMainWindow : INAppStoreWindow

@property (nonatomic, strong) DMMainViewController *viewController;

- (void)addButtonToTitleBar:(NSView *)viewToAdd atXPosition:(CGFloat)x;
- (void)addUpdatesViewToTitleBar:(NSView *)viewToAdd;
- (void)presentError:(NSError *)error contextInfo:(void *)contextInfo;

@end

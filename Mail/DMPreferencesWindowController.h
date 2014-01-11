//
//  DMPreferencesWindowController.h
//  DotMail
//
//  Created by Robert Widmann on 7/9/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@class DMPreferencesViewController, DMPreferencesWindow;

@interface DMPreferencesWindowController : NSWindowController

+ (instancetype)standardPreferencesWindowController;
- (void)insertPreferencePane:(DMPreferencesViewController *)preferencePane;

- (DMPreferencesWindow *)window;

@end

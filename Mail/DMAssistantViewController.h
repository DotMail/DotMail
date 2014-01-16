//
//  DMAssistantViewController.h
//  DotMail
//
//  Created by Robert Widmann on 11/9/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import <Puissant/PSTConstants.h>
#import "DMAccountSetupWindowController.h"

@protocol DMAssistantViewControllerDelegate;

@interface DMAssistantViewController : NSViewController

- (CGSize)contentSize;
- (NSString *)title;
- (void)resetUI;

@property (nonatomic, strong) NSMutableDictionary *info;
- (void)setInfoValue:(id)value forKey:(id)key;

@end

@protocol DMAssistantViewControllerDelegate <NSObject>

@required
- (void)assistantViewControllerDidFinish:(DMAssistantViewController *)assistant;

@end
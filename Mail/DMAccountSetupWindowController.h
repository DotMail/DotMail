//
//  DMAccountSetupWindowController.h
//  DotMail
//
//  Created by Robert Widmann on 9/8/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@class DMBasicAssistantViewController, DMIMAPAssistantViewController, DMSMTPAssistantViewController;

typedef NS_ENUM(NSUInteger, DMAssistantPane) {
	DMAssistantPaneWelcome = 0,
	DMAssistantPaneBasicAssistant,
	DMAssistantPaneCustomIMAPAssistant,
	DMAssistantPaneDone
};

@interface DMAccountSetupWindowController : NSWindowController

+ (instancetype)standardAccountSetupWindowController;
+ (instancetype)modalAccountSetupWindowController;

- (void)switchView:(id)sender;

@property (nonatomic, strong) DMBasicAssistantViewController *basicLoginViewController;
@property (nonatomic, strong) DMIMAPAssistantViewController *imapViewController;
@property (nonatomic, strong) DMSMTPAssistantViewController *smtpViewController;

- (void)beginSheetModalForWindow:(NSWindow*)window;
- (void)finishCreatingAccount:(id)sender;

@end
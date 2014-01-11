//
//  CFIComposeWindow.h
//  DotMail
//
//  Created by Robert Widmann on 7/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import "MKColorWell.h"
#import <WebKit/WebKit.h>
#import "INAppStoreWindow.h"
#import "DMTokenizingEmailField.h"
#import <Quartz/Quartz.h>

typedef NS_ENUM(NSUInteger, DMComposerMode) {
	DMComposerModeDraft = 0,
	DMComposerModeReply,
	DMComposerModeReplyAll,
	DMComposerModeForward,
	
	/*NOT Supported Yet*/
	DMComposerModeForURL,
	DMComposerModeForScript,
	DMComposerModeForDebug

};

@class MCOAddress, MCOAbstractMessage, DMComposeViewController;

@protocol DMComposerDelegate;

@interface DMComposeWindowController : NSWindowController <NSWindowDelegate>

- (instancetype)init;
- (instancetype)initWithMode:(DMComposerMode)mode;
- (instancetype)initWithFilename:(NSString *)filename;

@property (nonatomic, strong) DMComposeViewController *composeViewController;

@property (nonatomic, assign) id<DMComposerDelegate> delegate;
@property (nonatomic, assign) DMComposerMode mode;

@property (nonatomic, retain) MCOAddress * sender;
@property (nonatomic, retain) MCOAddress * from;

@property IBOutlet NSTextField *subjectField;

- (IBAction)addLink:(id)sender;

@end

@protocol DMComposerDelegate <NSObject>

- (CGWindowLevelKey)windowLevelForCurrentState;

@end


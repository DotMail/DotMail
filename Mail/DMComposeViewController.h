//
//  DMComposeViewController.h
//  DotMail
//
//  Created by Robert Widmann on 7/1/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@class DMComposeViewModel, PSTConversation;

@interface DMComposeViewController : NSViewController <NSTextFieldDelegate> {
	NSRect _frame;
	__weak NSWindow *_bindingWindow;
}

- (instancetype)initWithContentRect:(NSRect)frame inWindow:(NSWindow *)window;

@property (nonatomic, strong, readonly) DMComposeViewModel *viewModel;

@end

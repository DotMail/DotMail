//
//  DMMainLoginViewController.m
//  DotMail
//
//  Created by Robert Widmann on 10/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMBasicAssistantViewController.h"
#import "NSColor+DMUIColors.h"
#import "DMLayeredImageView.h"
#import "DMColoredView.h"
#import "DMLabel.h"
#import "DMCenteredTextFieldCell.h"
#import "DMFlatButton.h"
#import <MailCore/mailcore.h>

static CGSize const DMWelcomeViewControllerSize = (CGSize){ 320, 400 };

@interface DMBasicAssistantViewController () <TUITextFieldDelegate>

@property (nonatomic, strong) PSTAccountChecker *checker;

- (void) createAccount:(id)sender;

@property (nonatomic, assign) BOOL mxCheckMode;

@end

@implementation DMBasicAssistantViewController {
	BOOL isModal;
}

- (instancetype)init {
	self = [super init];
	
	return self;
}

- (instancetype)initInModalSheet {
	self = [super init];
	isModal = YES;
	return self;
}

- (void) loadView {
	DMColoredView *view = [[DMColoredView alloc]initWithFrame:(NSRect){ {0, 0}, { 320, 400 } }];
	view.backgroundColor = NSColor.whiteColor;

	DMLayeredImageView *iconImageView = [[DMLayeredImageView alloc]initWithFrame:(NSRect){ { 110, 280 } , { 100, 100 } }];
	iconImageView.imageAlignment = NSImageAlignCenter;
	iconImageView.image = [NSImage imageNamed:NSImageNameUserAccounts];
	iconImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
	[view addSubview:iconImageView];
	
	DMLabel *titleLabel = [[DMLabel alloc]initWithFrame:(NSRect){ { 20, 240 }, { 280, 36 } }];
	titleLabel.text = @"Login";
	titleLabel.textAlignment = NSCenterTextAlignment;
	titleLabel.font = [NSFont fontWithName:@"Helvetica-Bold" size:26];
	titleLabel.textColor = [NSColor colorWithCalibratedWhite:0.607 alpha:1.000];
	[view addSubview:titleLabel];
	
	CALayer *backgroundNameLayer = CALayer.layer;
	backgroundNameLayer.frame = (CGRect){ { 20, 178 }, .size.width = 280, .size.height = 40 };
	backgroundNameLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.908 green:0.936 blue:0.946 alpha:1.000].CGColor;
	backgroundNameLayer.cornerRadius = 4.0f;
	[view.layer addSublayer:backgroundNameLayer];

	self.nameTextField = [[NSTextField alloc] initWithFrame:(CGRect){ { 24, 176 }, .size.width = 276, .size.height = 32 } ];
	//	[nameTextField setDelegate:self];
	[self.nameTextField.cell setUsesSingleLineMode:YES];
	self.nameTextField.focusRingType = NSFocusRingTypeNone;
	[self.nameTextField.cell setPlaceholderString:@"name (optional)"];
	self.nameTextField.backgroundColor = [NSColor clearColor];
	self.nameTextField.bordered = NO;
	[view addSubview:self.nameTextField];
	
	CALayer *backgroundEmailLayer = CALayer.layer;
	backgroundEmailLayer.frame = (CGRect){ { 20, 128 }, .size.width = 280, .size.height = 40 };
	backgroundEmailLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.908 green:0.936 blue:0.946 alpha:1.000].CGColor;
	backgroundEmailLayer.cornerRadius = 4.0f;
	[view.layer addSublayer:backgroundEmailLayer];
	
	self.emailTextField = [[NSTextField alloc] initWithFrame:(CGRect){ { 24, 126 }, .size.width = 276, .size.height = 32 } ];
//	[emailTextField setDelegate:self];
	[self.emailTextField.cell setUsesSingleLineMode:YES];
	self.emailTextField.focusRingType = NSFocusRingTypeNone;
	self.emailTextField.backgroundColor = [NSColor clearColor];
	[self.emailTextField.cell setPlaceholderString:@"email address"];
	self.emailTextField.bordered = NO;
	[view addSubview:self.emailTextField];

	CALayer *backgroundPasswordLayer = CALayer.layer;
	backgroundPasswordLayer.frame = (CGRect){ { 20, 80 }, .size.width = 280, .size.height = 40 };
	backgroundPasswordLayer.backgroundColor = [NSColor colorWithCalibratedRed:0.908 green:0.936 blue:0.946 alpha:1.000].CGColor;
	backgroundPasswordLayer.cornerRadius = 4.0f;
	[view.layer addSublayer:backgroundPasswordLayer];
	
	self.passwordTextField = [[NSSecureTextField alloc] initWithFrame:(CGRect){ { 24, 78 }, .size.width = 276, .size.height = 32 } ];
	//	[passwordTextField setDelegate:self];
	[self.passwordTextField.cell setUsesSingleLineMode:YES];
	self.passwordTextField.focusRingType = NSFocusRingTypeNone;
	self.passwordTextField.backgroundColor = [NSColor clearColor];
	[self.passwordTextField.cell setPlaceholderString:@"password"];
	self.passwordTextField.bordered = NO;
	[view addSubview:self.passwordTextField];

//	self.warningLabel = [[TUILabel alloc] initWithFrame:(CGRect) {.origin.x = CGRectGetMidX(view.bounds) - (500 / 2), .origin.y = isModal ? 25 : 30, .size.width = 500, .size.height = 120 }];
//	[self.warningLabel setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[self.warningLabel setBackgroundColor:[NSColor clearColor]];
//	[self.warningLabel setAlignment:TUITextAlignmentCenter];
//	[self.warningLabel setTextColor:[NSColor blackColor]];
//	[self.warningLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13]];
//	[self.warningLabel setUserInteractionEnabled:NO];
//	[rootView addSubview:self.warningLabel];
//	
	self.emailWarning = CALayer.layer;
	self.emailWarning.frame = (CGRect) {.origin.x = CGRectGetMaxX(self.emailTextField.frame) - 24, .origin.y = NSMinY(self.emailTextField.frame) + 14, .size.width = 20, .size.height = 20 };
	[self.emailWarning setOpacity:0.0f];
	[self.emailWarning setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
	[self.emailWarning setContents:[NSImage imageNamed:NSImageNameInvalidDataFreestandingTemplate]];
	[view.layer addSublayer:self.emailWarning];
	
	self.passwordWarning = CALayer.layer;
	self.passwordWarning.frame = (CGRect) {.origin.x = CGRectGetMaxX(self.passwordTextField.frame) - 24, .origin.y = NSMinY(self.passwordTextField.frame) + 14, .size.width = 20, .size.height = 20 };
	[self.passwordWarning setOpacity:0.0f];
	[self.passwordWarning setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
	[self.passwordWarning setContents:[NSImage imageNamed:NSImageNameInvalidDataFreestandingTemplate]];
	[view.layer addSublayer:self.passwordWarning];

	self.createAccountButton = [[DMFlatButton alloc]initWithFrame:(NSRect){ { 20, 28 }, { 280, 40 } }];
	self.createAccountButton.keyEquivalent = @"\r";
	self.createAccountButton.buttonType = NSMomentaryPushInButton;
	self.createAccountButton.bordered = NO;
	self.createAccountButton.tag = 0;
	self.createAccountButton.target = self;
	self.createAccountButton.action = @selector(createAccount:);
	self.createAccountButton.verticalPadding = 6;
	self.createAccountButton.title = @"Login";
	self.createAccountButton.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:20];
	self.createAccountButton.backgroundColor = [NSColor colorWithCalibratedRed:0.105 green:0.562 blue:0.517 alpha:1.000];
	[view addSubview:self.createAccountButton];
	
//	self.cancelAccountButton = [[TUIButton alloc] initWithFrame:(CGRect) { .origin.x = CGRectGetMidX(view.bounds) - 135, .origin.y = isModal ? 20 : 140, .size.width = isModal ? 120 : 170, .size.height = 40 }];
//	[self.cancelAccountButton setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[self.cancelAccountButton setTitle:@"Cancel" forState:TUIControlStateNormal];
//	[self.cancelAccountButton.titleLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13]];
//	[self.cancelAccountButton.titleLabel setAlignment:TUITextAlignmentCenter];
//	[self.cancelAccountButton.titleLabel setTextColor:[NSColor whiteColor]];
//	[self.cancelAccountButton setTitleColor:[NSColor whiteColor] forState:TUIControlStateNormal];
//	self.cancelAccountButton.drawRect = ^(TUIView *button, CGRect rect) {
//		if ([(TUIButton *) button state] == TUIControlStateHighlighted) {
//			[button setBackgroundColor:[NSColor colorWithCalibratedWhite:0.217 alpha:1.000]];
//		}
//		else {
//			[button setBackgroundColor:[NSColor colorWithCalibratedWhite:0.400 alpha:1.000]];
//		}
//		[button drawRect:rect];
//	};
//	[self.cancelAccountButton addTarget:self action:@selector(cancel) forControlEvents:TUIControlEventMouseUpInside];
//	[rootView addSubview:self.cancelAccountButton];
//
//	if (isModal) {
//		self.cancelAccountButton = [[TUIButton alloc] initWithFrame:(CGRect) { .origin.x = CGRectGetMidX(view.bounds) - 135, .origin.y = isModal ? 20 : 140, .size.width = isModal ? 120 : 170, .size.height = 40 }];
//		[self.cancelAccountButton setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//		[self.cancelAccountButton setTitle:@"Cancel" forState:TUIControlStateNormal];
//		[self.cancelAccountButton.titleLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13]];
//		[self.cancelAccountButton.titleLabel setAlignment:TUITextAlignmentCenter];
//		[self.cancelAccountButton.titleLabel setTextColor:[NSColor whiteColor]];
//		[self.cancelAccountButton setTitleColor:[NSColor whiteColor] forState:TUIControlStateNormal];
//		self.cancelAccountButton.drawRect = ^(TUIView *button, CGRect rect) {
//			if ([(TUIButton *) button state] == TUIControlStateHighlighted) {
//				[button setBackgroundColor:[NSColor colorWithCalibratedWhite:0.217 alpha:1.000]];
//			}
//			else {
//				[button setBackgroundColor:[NSColor colorWithCalibratedWhite:0.400 alpha:1.000]];
//			}
//			[button drawRect:rect];
//		};
//		[self.cancelAccountButton addTarget:self action:@selector(cancel) forControlEvents:TUIControlEventMouseUpInside];
//		[rootView addSubview:self.cancelAccountButton];
//	}
//	
//	self.setupTitleLabel = [[TUILabel alloc] initWithFrame:(CGRect) {.origin.x = CGRectGetMidX(view.bounds) - (450 / 2), .origin.y = 390, .size.width = 450, .size.height = 80 }];
//	[self.setupTitleLabel setText:@"Welcome"];
//	[self.setupTitleLabel setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[self.setupTitleLabel setBackgroundColor:[NSColor clearColor]];
//	[self.setupTitleLabel setAlignment:TUITextAlignmentCenter];
//	[self.setupTitleLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:60]];
//	[self.setupTitleLabel setTextColor:[NSColor colorWithCalibratedRed:0.121 green:0.136 blue:0.135 alpha:1.000]];
//	[self.setupTitleLabel setUserInteractionEnabled:NO];
//	[rootView addSubview:self.setupTitleLabel];
//	
//	self.setupSubtitleLabel = [[TUILabel alloc] initWithFrame:(CGRect) {.origin.x = CGRectGetMidX(view.bounds) - (500 / 2), .origin.y = 370, .size.width = 500, .size.height = 36 }];
//	[self.setupSubtitleLabel setText:@"You'll be guided through the steps to set up your IMAP account."];
//	[self.setupSubtitleLabel setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[self.setupSubtitleLabel setBackgroundColor:[NSColor clearColor]];
//	[self.setupSubtitleLabel setAlignment:TUITextAlignmentCenter];
//	[self.setupSubtitleLabel setFont:[NSFont fontWithName:@"HelveticaNeue" size:16]];
//	[self.setupSubtitleLabel setTextColor:[NSColor colorWithCalibratedWhite:0.577 alpha:1.000]];
//	[self.setupSubtitleLabel setUserInteractionEnabled:NO];
//	[rootView addSubview:self.setupSubtitleLabel];
//	
//	self.logoImageView = [[TUIImageView alloc] initWithImage:[NSImage imageNamed:@"DotMail_Logo.png"]];
//	[self.logoImageView setBackgroundColor:NSColor.clearColor];
//	[self.logoImageView setFrame:(CGRect) {.origin.x = CGRectGetMidX(view.bounds) - (78 / 2), .origin.y = 480, .size.width = 78, .size.height = 78 }
//	 ];
//	[self.logoImageView setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[rootView addSubview:self.logoImageView];
//	
//	//
//	//	self.customAccountButton = [[TUIButton alloc] initWithFrame:CGRectMake(0, 0, NSWidth(view.frame) / 2, 64)];
//	//	[self.customAccountButton.titleLabel setTextColor:[NSColor blackColor]];
//	//	[self.customAccountButton.titleLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:20]];
//	//	[self.customAccountButton.titleLabel setAlignment:TUITextAlignmentCenter];
//	//	[self.customAccountButton setTitle:@"Custom..." forState:TUIControlStateNormal];
//	//	[self.customAccountButton setTitleColor:[NSColor blackColor] forState:TUIControlStateNormal];
//	//	[self.customAccountButton setTitleColor:[NSColor blackColor] forState:TUIControlStateNormal];
//	//
//	//	self.customAccountButton.drawRect = ^(TUIView *button, CGRect rect) {
//	//		if ([(TUIButton *) button state] == TUIControlStateHighlighted) {
//	//			[button setBackgroundColor:[NSColor lightGrayColor]];
//	//		} else {
//	//			[button setBackgroundColor:[NSColor whiteColor]];
//	//		}
//	//		[button drawRect:rect];
//	//	};
//	//	[self.customAccountButton addTarget:self action:@selector(createCustomAccount:) forControlEvents:TUIControlEventMouseUpInside];
//	//	[rootView addSubview:self.customAccountButton];
//	//
//	self.progressIndicator = [[TUIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(view.bounds) - (16 / 2), 60, 16, 16)];
//	[self.progressIndicator setAutoresizingMask:(TUIViewAutoresizingFlexibleRightMargin | TUIViewAutoresizingFlexibleLeftMargin)];
//	[rootView addSubview:self.progressIndicator];
//
	
	
	self.nameTextField.nextKeyView = self.emailTextField;
	self.emailTextField.nextKeyView = self.passwordTextField;
	self.passwordTextField.nextKeyView = self.nameTextField;
	
	self.view = view;
}

- (void)flagsChanged:(NSEvent *)theEvent {
	if (theEvent.modifierFlags & NSAlternateKeyMask) {
		self.createAccountButton.backgroundColor = [NSColor colorWithCalibratedRed:0.492 green:0.651 blue:0.849 alpha:1.000];
		self.createAccountButton.title = @"Advanced";
	} else {
		self.createAccountButton.backgroundColor = [NSColor colorWithCalibratedRed:0.105 green:0.562 blue:0.517 alpha:1.000];
		self.createAccountButton.title = @"Login";
	}
}

- (CGSize)contentSize {
	return DMWelcomeViewControllerSize;
}

- (void)reset {
	self.nameTextField.stringValue = @"";
	self.passwordTextField.stringValue = @"";
	self.emailTextField.stringValue = @"";
}

- (void) _disableForValidation {
	[self.progressIndicator startAnimating];
	
	[self.emailTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	[self.nameTextField resignFirstResponder];
	
	[self.emailTextField setEditable:NO];
	[self.passwordTextField setEditable:NO];
	[self.nameTextField setEditable:NO];
	
	[self.emailTextField setTextColor:[NSColor disabledControlTextColor]];
	[self.passwordTextField setTextColor:[NSColor disabledControlTextColor]];
	[self.nameTextField setTextColor:[NSColor disabledControlTextColor]];
}

- (void) _moveToCustomForm:(id)sender {
	[self _customConfigNextAssistant];
}

- (void) _customConfigNextAssistant {
	[self setInfoValue:self.nameTextField.stringValue forKey:@"PSTName"];
	[self setInfoValue:self.emailTextField.stringValue forKey:@"PSTEmail"];
	[self setInfoValue:self.passwordTextField.stringValue forKey:@"PSTPassword"];
	[self setInfoValue:self.passwordTextField.stringValue forKey:@"imapPassword"];
	[self setInfoValue:@NO forKey:@"imapInsecure"];
	[self setInfoValue:self.passwordTextField.stringValue forKey:@"smtpPassword"];
	[self setInfoValue:@(YES) forKey:@"smtpAuthenticationEnabled"];
	[self setInfoValue:@(NO) forKey:@"smtpInsecure"];
//	[self.delegate assistantViewController:self advanceToStep:DMAssistantStepCustomImap];
}

- (void)createAccount:(id)sender {
	if ([NSApp currentEvent].modifierFlags & NSAlternateKeyMask) {
		[self createCustomAccount:sender];
	} else if ([self _validate]) {
		MCOMailProvider *provider = [[MCOMailProvidersManager sharedManager] providerForEmail:self.emailTextField.stringValue];
		if (provider) {
			[self _checkAccountWithProvider:provider];
		} else {
			[[DMAccountSetupWindowController standardAccountSetupWindowController] switchView:@(DMAssistantPaneCustomIMAPAssistant)];
		}
	}
}

- (void)createCustomAccount:(id)sender {
	NSArray *components = [self.emailTextField.stringValue componentsSeparatedByString:@"@"];
	if (components.count == 0) {
		[self _validate];
	} else {
		[[DMAccountSetupWindowController standardAccountSetupWindowController] switchView:@(DMAssistantPaneCustomIMAPAssistant)];
	}
}

- (void)cancel {
	self.info = nil;
//	[self.delegate assistantViewController:self advanceToStep:DMAssistantStepDone];
}

- (void) _customConfigPrefillProvider:(MCOMailProvider *)provider {
	if (provider.imapServices.count == 0) {
		if (provider.popServices.count == 0) {
			[self _customConfigNextAssistant];
			return;
		}
	}
	MCONetService *imapService = [provider.imapServices objectAtIndex:0];
	MCONetService *smtpService = [provider.smtpServices objectAtIndex:0];
	[self setInfoValue:[imapService hostnameWithEmail:self.emailTextField.stringValue] forKey:@"imapHostname"];
	[self setInfoValue:[smtpService hostnameWithEmail:self.emailTextField.stringValue] forKey:@"smtpHostname"];
	[self setInfoValue:self.emailTextField.stringValue forKey:@"imapLogin"];
	[self setInfoValue:self.emailTextField.stringValue forKey:@"smtpLogin"];
	[self _customConfigNextAssistant];
	return;
}

- (void) _checkAccountWithProvider:(MCOMailProvider *)provider {
	self.checker = [[PSTAccountChecker alloc] init];
	[self.checker setProvider:provider];
	[self.checker setEmail:self.emailTextField.stringValue];
	[self.checker setPassword:self.passwordTextField.stringValue];
	@weakify(self);
	[[self.checker check] subscribeError:^(NSError *error) {
		@strongify(self);
		[self shakeWindowHorizontally:self.view.window duration:0.5 vigour:0.003f times:6 completion: ^{
			[TUIView animateWithDuration:0.25 animations: ^{
				[self.warningLabel setAlpha:1.0f];
				[self.emailWarning setOpacity:1.0f];
				[self.passwordWarning setOpacity:1.0f];
			}];
			[self.warningLabel setText:errorTextForLEPErrorCode(error.code)];
			[self reEnable];
		}];
	} completed:^{
		@strongify(self);
		[self finishCreatingAccountWithProvider:self.checker.provider];
		[self reEnable];
	}];
}

- (BOOL) _validate {
	NSMutableString *warningString = [NSMutableString string];
	float emailWarningAlpha, passwordWarningAlpha;
	NSInteger errorFrameEnum = 0;
	emailWarningAlpha = 0.0f;
	passwordWarningAlpha = 0.0f;
	
	if (self.emailTextField.stringValue.length && self.passwordTextField.stringValue.length && [self _validateEmail:self.emailTextField.stringValue]) {
		[self _disableForValidation];
		[self.warningLabel setText:@""];
		[TUIView animateWithDuration:0.25 animations: ^{
			[self.passwordWarning setOpacity:0.0f];
			[self.emailWarning setOpacity:0.0f];
		}];
		return YES;
	}
	else {
		if (![self.emailTextField stringValue].length) {
			emailWarningAlpha = 1.0f;
			[warningString appendString:@"Your email has not been entered.  Please enter your email address."];
			errorFrameEnum++;
		}
		if (![self _validateEmail:[self.emailTextField stringValue]] && [self.emailTextField stringValue].length) {
			emailWarningAlpha = 1.0f;
			if (warningString.length) {
				[warningString appendString:@"\n"];
			}
			[warningString appendString:@"The email you entered is not correct.  Please check that you typed it correctly."];
			errorFrameEnum++;
		}
		if (![self.passwordTextField stringValue].length) {
			passwordWarningAlpha = 1.0f;
			if (warningString.length) {
				[warningString appendString:@"\n"];
			}
			[warningString appendString:@"A login has not been entered.  Please enter a login."];
			errorFrameEnum++;
		}
		[self shakeWindowHorizontally:self.view.window duration:0.5 vigour:0.003f times:6 completion: ^{
			[self.warningLabel setText:warningString];
			
			if (isModal) {
				NSRect windowFrame = self.view.window.frame;
				windowFrame.size.height += 60;
				[self.view.window setFrame:windowFrame display:YES animate:YES];
			}
			
			[TUIView animateWithDuration:0.25 animations: ^{
				[self.passwordWarning setOpacity:passwordWarningAlpha];
				[self.emailWarning setOpacity:emailWarningAlpha];
			}];
			[self reEnable];
		}];
		return NO;
	}
	return NO;
}

- (void) reEnable {
	[self.progressIndicator stopAnimating];
	
	[self.emailTextField setEditable:YES];
	[self.passwordTextField setEditable:YES];
	[self.nameTextField setEditable:YES];
	
	[self.emailTextField becomeFirstResponder];

	[self.emailTextField setTextColor:[NSColor blackColor]];
	[self.passwordTextField setTextColor:[NSColor blackColor]];
	[self.nameTextField setTextColor:[NSColor blackColor]];
}

- (BOOL)_validateEmail:(NSString *)candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

- (void) shakeWindowHorizontally:(NSWindow *)inWindow duration:(float)inDuration vigour:(float)inVigour times:(int)inTimes completion:(void (^)(void))completion {
	CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
	NSRect inFrame = [inWindow frame];
	
	CGMutablePathRef shakePath = CGPathCreateMutable();
	CGPathMoveToPoint( shakePath, NULL, NSMinX(inFrame), NSMinY(inFrame) );
	int index;
	for (index = 0; index < inTimes; ++index) {
		CGPathAddLineToPoint( shakePath, NULL, NSMinX(inFrame) - inFrame.size.width * inVigour, NSMinY(inFrame) );
		CGPathAddLineToPoint( shakePath, NULL, NSMinX(inFrame) + inFrame.size.width * inVigour, NSMinY(inFrame) );
	}
	CGPathCloseSubpath(shakePath);
	shakeAnimation.path = shakePath;
	shakeAnimation.duration = inDuration;
	
	[inWindow setAnimations:[NSDictionary dictionaryWithObject:shakeAnimation forKey:@"frameOrigin"]];
	[[inWindow animator] setFrameOrigin:inFrame.origin];
	CGPathRelease(shakePath);
	
	dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (int64_t)(inDuration * NSEC_PER_SEC) );
	dispatch_after(popTime, dispatch_get_main_queue(), completion);
}

- (void) finishCreatingAccountWithProvider:(MCOMailProvider *)provider {
	[self setInfoValue:self.nameTextField.stringValue forKey:@"PSTName"];
	[self setInfoValue:self.emailTextField.stringValue forKey:@"PSTEmail"];
	[self setInfoValue:self.passwordTextField.stringValue forKey:@"PSTPassword"];
	[self setInfoValue:provider.identifier forKey:@"PSTProvider"];

	if ([provider.smtpServices count] != 0) {
		[self setInfoValue:[[provider.smtpServices objectAtIndex:0] info] forKey:@"PSTSMTPService"];
	}
	if ([provider.imapServices count] != 0) {
		[self setInfoValue:[[provider.imapServices objectAtIndex:0] info] forKey:@"PSTIMAPService"];
	}
	if ([provider.popServices count] != 0) {
		[self setInfoValue:[[provider.popServices objectAtIndex:0] info] forKey:@"PSTPOPService"];
	}
	[[DMAccountSetupWindowController standardAccountSetupWindowController] finishCreatingAccount:self];
}

static NSString *errorTextForLEPErrorCode(NSUInteger err) {
	switch (err) {
		case MCOErrorConnection:
			return @"A connection to the internet could not be established.";
			break;
			
		default:
			return @"A connection to the server could not be established.\n Check that the email or password you entered is correct and retry.";
			break;
	}
	return @"";
}

#pragma mark - TUITextFieldDelegate

//- (BOOL) textFieldShouldReturn:(TUITextField *)textField {
//	[self.createAccountButton setHighlighted:YES];
//	[self.createAccountButton sendActionsForControlEvents:TUIControlEventMouseUpInside];
//	[self performSelector:@selector(_deHighlight) withObject:nil afterDelay:0.1];
//	return YES;
//}
//
//- (void) _deHighlight {
//	[self.createAccountButton setHighlighted:NO];
//}

@end
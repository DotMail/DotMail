//
//  DMMainLoginViewController.h
//  DotMail
//
//  Created by Robert Widmann on 10/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//



#import "DMAssistantViewController.h"

@class DMFlatButton;

@interface DMBasicAssistantViewController : DMAssistantViewController <NSTextFieldDelegate>

- (instancetype)initInModalSheet;
- (void)reset;

@property (nonatomic, strong) TUILabel *setupTitleLabel;
@property (nonatomic, strong) TUILabel *setupSubtitleLabel;
@property (nonatomic, strong) TUIImageView *logoImageView;

@property (nonatomic, strong) NSTextField *nameTextField;
@property (nonatomic, strong) NSTextField *emailTextField;
@property (nonatomic, strong) NSSecureTextField *passwordTextField;
@property (nonatomic, strong) TUILabel *warningLabel;
@property (nonatomic, strong) DMFlatButton *createAccountButton;
@property (nonatomic, strong) DMFlatButton *cancelAccountButton;
@property (nonatomic, strong) TUIButton *customAccountButton;
@property (nonatomic, strong) TUIActivityIndicatorView *progressIndicator;
@property (nonatomic, strong) CALayer *emailWarning;
@property (nonatomic, strong) CALayer *passwordWarning;

@end

//
//  DMCustomLoginViewController.h
//  DotMail
//
//  Created by Robert Widmann on 10/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import "DMAssistantViewController.h"


@class DMToolbar;

@interface DMIMAPAssistantViewController : DMAssistantViewController <NSTokenFieldDelegate>

@property (nonatomic, strong) DMToolbar *toolbarView;
//@property (nonatomic, strong) NSTokenField *serverTypeTokenField;
@property (nonatomic, strong) TUILabel *serverNameLabel;
@property (nonatomic, strong) TUILabel *loginLabel;
@property (nonatomic, strong) TUILabel *passwordLabel;
@property (nonatomic, strong) TUILabel *portLabel;
@property (nonatomic, strong) TUILabel *warningLabel;

@property (nonatomic, strong) TUITextField *serverNameField;
@property (nonatomic, strong) TUITextField *loginField;
@property (nonatomic, strong) TUITextField *passwordField;
@property (nonatomic, strong) TUITextField *portField;
@property (nonatomic, strong) TUITextField *warningField;

@property (nonatomic, strong) TUIImageView *serverNameWarning;
@property (nonatomic, strong) TUIImageView *loginWarning;
@property (nonatomic, strong) TUIImageView *passwordWarning;
@property (nonatomic, strong) TUIImageView *portWarning;

@property (nonatomic, strong) TUIButton *validateButton;

@end

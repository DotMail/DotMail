//
//  DMAccountListController.h
//  DotMail
//
//  Created by Robert Widmann on 10/11/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@protocol DMAccountListControllerDelegate;

/**
 * A View Controller that manages the display of a series of account views.
 */

@interface DMAccountListViewController : TUIViewController

/**
 * 
 * The default initializer for this class.
 */
- (instancetype)initWithContentRect:(CGRect)contentRect;
- (PSTFolderType)selectedMailbox;

@property (nonatomic, assign) id<DMAccountListControllerDelegate> delegate;
@property (nonatomic, strong) PSTAccountController *selectedAccount;

- (void)setSelectionForCurrentAccount:(PSTFolderType)selection;
- (IBAction)selectPreviousAccount:(id)sender;
- (IBAction)selectNextAccount:(id)sender;

@end

@protocol DMAccountListControllerDelegate <NSObject>

- (void)accountListControllerWillChange:(DMAccountListViewController*)listController;

@end

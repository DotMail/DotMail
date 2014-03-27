//
//  CFIAppDelegate.h
//  DotMail
//
//  Created by Robert Widmann on 7/10/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@class DMMainWindowController, PSTAccountController, DMAboutWindowController, DMAccountSetupWindowController;

/**
 * DMAppDelegate is DotMail's Application delegate class.  It is responsible for relaying the 
 * messages it cannot handle to the various classes it owns, and because it owns many potentially
 * important, non-singleton classes, it is called upon using -[NSApp delegate];
 * This syntax should be consistently used across the project.  In addition, messages taking a 
 * sender argument that are called from this class must use NSApp.
 */

@interface DMAppDelegate : NSObject <NSApplicationDelegate>

/**
 * The Main Window of DotMail.  Will not be displayed if no accounts are detected
 */
@property (nonatomic, strong) DMMainWindowController *mainWindowController;

/**
 * A replacement custom About Panel Window Controller.
 */
@property (nonatomic, strong) DMAboutWindowController *aboutWindowController;

@property (nonatomic, strong) DMAccountSetupWindowController *accountSetupWindowController;

/*!
 * Called by the About window to display the current bundle version
 * @return an NSString formatted exactly like the plist value.  Ex: 'CF001F3'
 * @note Pattern displayed by About window: Version %{value1}@ (%{value2}@)
 */
@property (nonatomic, strong, readonly) NSString *bundleVersionNumber;

/*!
 * Called by the About window to display the current running version short string
 * @return an NSString number formatted as an int.  Ex: '0.1.1'
 * @note Pattern displayed by About window: Version %{value1}@ (%{value2}@)
 */
@property (nonatomic, strong, readonly) NSString *shortVersionNumber;

@property (nonatomic, strong, readonly) NSString *versionColloquialName;

@property IBOutlet NSMenuItem *_dmPreferencesButton;
@property IBOutlet NSMenuItem *_dmUpdatesMenuItem;

@property IBOutlet NSMenuItem *_dmComposeMessageMenuItem;
@property IBOutlet NSMenuItem *_dmReplyMenuItem;
@property IBOutlet NSMenuItem *_dmReplyAllMenuItem;


@property IBOutlet NSMenuItem *_dmAboutTwitterMenuItem;
@property IBOutlet NSMenuItem *_dmAboutDesignerMenuItem;
@property IBOutlet NSMenuItem *_dmAboutDeveloperMenuItem;

@property IBOutlet NSMenuItem *boldButton;
@property IBOutlet NSMenuItem *italicsButton;

@end

@interface DMAppDelegate (DMMenuActions)

- (IBAction)refreshAllMail:(id)sender;

- (IBAction)replyMessage:(id)sender;
- (IBAction)replyAllMessage:(id)sender;

/**
 * Lazy loads, then shows the Preference Panel.
 */
- (IBAction)showPreferences:(id)sender;

/**
 * Lazy loads, then shows the About Panel.
 */
- (IBAction)showAboutPanel:(id)sender;

/**
 * Presents a new and blank composer window.  Called from either
 * the menu bar or from the DockTile.
 */
- (IBAction)composeMessage:(id)sender;

/**
 * Opens the DotMail twitter page in the current default browser.
 */
- (IBAction)dotMailTwitter:(id)sender;

/**
 * Opens Tobias van Schneider's web page in the current default browser.
 */
- (IBAction)aboutVanSchneider:(id)sender;

/**
 * Opens CodaFi's website in the current default browser.
 */
- (IBAction)aboutCodaFi:(id)sender;

/**
 * Tells the conversation WebView to open the print dialog.
 */
- (IBAction)print:(id)sender;

- (IBAction)selectPreviousAccount:(id)sender;
- (IBAction)selectNextAccount:(id)sender;

- (IBAction)selectInbox:(id)sender;
- (IBAction)selectNextSteps:(id)sender;
- (IBAction)selectFavourites:(id)sender;
- (IBAction)selectDrafts:(id)sender;
- (IBAction)selectSent:(id)sender;
- (IBAction)selectTrash:(id)sender;
- (IBAction)selectLabels:(id)sender;

@end

@interface DMAppDelegate (DMQuickLookSupport)

- (void)togglePreviewPanel:(id)previewPanel;

@end

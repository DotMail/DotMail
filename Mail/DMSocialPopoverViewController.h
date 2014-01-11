//
//  DMSocialViewController.h
//  DotMail
//
//  Created by Robert Widmann on 3/19/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DMSocialPopoverMode) {
	DMSocialPopoverModeTwitter,
	DMSocialPopoverModeDribbble,
	DMSocialPopoverModeFacebook
};

@class PSTMailAccount;

/**
 * A popover that is specialized so as to display only those messages that have been deemed "Social
 * Notifications" by Puissant.  They are displayed as though they were actual emails, though they 
 * cannot be assigned an action step value.
 */

@interface DMSocialPopoverViewController : NSViewController <TUITableViewDataSource, TUITableViewDelegate>

/**
 * Creates and returns a new instance of this class, ready to bind to an account.
 * The default initializer for this class.
 */
- (instancetype)initWithSocialMode:(DMSocialPopoverMode)mode;

/**
 * The current "Social Mode" of this popover.
 */
@property (nonatomic, assign, readonly) DMSocialPopoverMode socialMode;

/**
 * The account associated with this social popover.  Upon being set, the account will be bound to so
 * as to allow the popover to automatically update when the proper signals fire.  Which signals will
 * be subscribed to are determined by the controller's "social mode" property.
 * This property is required for this class to behave properly.
 */
@property (nonatomic, weak) PSTMailAccount *account;

@property (nonatomic, assign) NSUInteger socialCount;

@end

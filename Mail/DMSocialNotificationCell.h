//
//  DMSocialNotificationCell.h
//  DotMail
//
//  Created by Robert Widmann on 4/20/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMSocialPopoverViewController.h"

@class PSTConversation;

/**
 * A cell that displays an email that has been deemed a "Social Notification" from a service
 * recognized by Puissant.
 */

@interface DMSocialNotificationCell : TUITableViewCell

/**
 * The "Social Mode" of the popover that owns this cell.  Useful in determining the title the cell
 * should give its contents.
 */
@property (nonatomic, assign) DMSocialPopoverMode socialMode;

/**
 * The notification associated with this cell and its contents.  Upon being set, the notification is
 * bound to and the cell will update its cache as it sees fit and respond to changes in the
 * underlying conversation cache automatically.
 */
@property (nonatomic, strong) PSTConversation *notification;

@end

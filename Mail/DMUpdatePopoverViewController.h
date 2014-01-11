//
//  DMUpdateViewController.h
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

/**
 * A DMUpdatePopoverViewController manages the presentation of the items contained in an SUAppcast in
 * order to facilitate an easier update process for users of the non-App Store version of DotMail.
 */

@interface DMUpdatePopoverViewController : NSViewController <TUITableViewDataSource, TUITableViewDelegate>


/**
 * Initializes an instance of DMUpdatePopoverViewController with the provided AppCast.  This is the
 * default initializer for the class.  If you do not call this, then you are required to provide an
 * AppCast through the setter.
 */
- (instancetype)initWithReleaseNotes:(NSString *)releaseNotes;

/**
 * The AppCast associated with the DMUpdatePopoverViewController instance.  This should never be nil.
 */
@property (nonatomic, copy) NSString *releaseNotes;

@end
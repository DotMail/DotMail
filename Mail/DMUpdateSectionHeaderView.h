//
//  DMUpdateSectionHeaderView.h
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

/**
 * The header for the release notes of the update.  It displays release notes and the version of the
 * forthcoming update to the user.
 */

@interface DMUpdateSectionHeaderView : TUITableViewSectionHeader

/**
 * The version of the current update.
 */
@property (nonatomic, copy) NSString *version;

@end

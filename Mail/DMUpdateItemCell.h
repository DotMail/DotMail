//
//  DMUpdateItemCell.h
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

/**
 * Displays a sub-section of the release notes to the user.
 */

@interface DMUpdateItemCell : TUITableViewCell

/**
 * The chunk of release notes to display.
 */
@property (nonatomic, copy) NSString *updateItemDescription;

@end

//
//  DMAttachmentImageBrowserItem.h
//  DotMail
//
//  Created by Robert Widmann on 7/22/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMAttachmentImageBrowserItem : NSObject /* <IKImageBrowserItem> */
@property (nonatomic, copy) NSString *filepath;
@end

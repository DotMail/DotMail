//
//  DMAttachmentImageBrowserItem.m
//  DotMail
//
//  Created by Robert Widmann on 7/22/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAttachmentImageBrowserItem.h"
#import <Quartz/Quartz.h>

@implementation DMAttachmentImageBrowserItem

- (NSString *)  imageUID {

	return self.filepath;
}

- (NSString *) imageRepresentationType {
	return IKImageBrowserQuickLookPathRepresentationType;
}

- (id) imageRepresentation {
	return self.filepath;
}

- (NSString *) imageTitle {
	return self.filepath.lastPathComponent;
}

@end

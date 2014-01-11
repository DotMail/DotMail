//
//  DMAttachmentsViewController.h
//  DotMail
//
//  Created by Robert Widmann on 3/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//


#import "DMAttachmentsBrowser.h"
#import <JNWCollectionView/JNWCollectionView.h>
#import <JNWCollectionView/JNWCollectionViewGridLayout.h>

@class PSTAccountController;

@interface DMAttachmentsViewController : NSViewController <JNWCollectionViewDataSource, JNWCollectionViewGridLayoutDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
	QLPreviewPanel* previewPanel;
}

@property (nonatomic, strong) PSTAccountController *account;
@property (nonatomic) DMAttachmentsBrowser *attachmentsBrowser;

- (instancetype)initWithContentRect:(NSRect)frame;
- (void)unload;

@end

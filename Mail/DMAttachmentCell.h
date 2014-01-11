//
//  CFIAttachmentItem.h
//  DotMail
//
//  Created by Robert Widmann on 8/5/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//


#import "NSImage+QuickLook.h"
#import <Quartz/Quartz.h>
#import <JNWCollectionView/JNWCollectionView.h>

@class PSTAttachmentCache, PSTLevelDBMapTable;

@interface DMAttachmentCell : JNWCollectionViewCell

@property (nonatomic, strong) PSTAttachmentCache *attachmentCache;
@property (nonatomic, strong) NSImageView *attachmentPreviewImageView;
@property (nonatomic, weak) PSTLevelDBMapTable *mapTable;

@end

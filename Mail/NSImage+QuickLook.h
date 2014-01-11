//
//  NSImage+QuickLook.h
//  QuickLookTest
//
//  Created by Matt Gemmell on 29/10/2007.
//

#import <Cocoa/Cocoa.h>

@class PSTIndexedMapTable;

extern void DMImageWithPreviewOfFileAtPath(NSString *path, NSSize size, BOOL asIcon, void(^promise)(NSImage *));

extern void DMCacheImageWithPreviewOfFileAtPath(NSString *path, NSSize size, BOOL asIcon, PSTLevelDBMapTable *table);

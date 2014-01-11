//
//  NSImage+QuickLook.m
//  QuickLookTest
//
//  Created by Matt Gemmell on 29/10/2007.
//

#import "NSImage+QuickLook.h"
#import <QuickLook/QuickLook.h> // Remember to import the QuickLook framework into your project!
#import <Puissant/PSTLevelDBMapTable.h>

static dispatch_queue_t DMPreviewImageDispatchQueue = NULL;
static CFMutableDictionaryRef DMPreviewImageCache = NULL;

void DMImageWithPreviewOfFileAtPath(NSString *path, NSSize size, BOOL asIcon, void(^promise)(NSImage *)) {
	if (DMPreviewImageDispatchQueue == NULL) {
		DMPreviewImageDispatchQueue = dispatch_queue_create("com.codafi.PreviewImages", DISPATCH_QUEUE_SERIAL);
		DMPreviewImageCache = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	}
	dispatch_async(DMPreviewImageDispatchQueue, ^{
		if (!path) {
			dispatch_async(dispatch_get_main_queue(), ^{
				promise(nil);
			});
			return;
		}
		NSImage *thumbnail = CFDictionaryGetValue(DMPreviewImageCache, path);
		if (thumbnail) {
			dispatch_async(dispatch_get_main_queue(), ^{
				promise(thumbnail);
			});
			return;
		}
		NSURL *fileURL = [NSURL fileURLWithPath:path];
		if (!path || !fileURL) {
			dispatch_async(dispatch_get_main_queue(), ^{
				promise(nil);
			});
			return;
		}
		
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:asIcon]
														 forKey:(NSString *)kQLThumbnailOptionIconModeKey];
		CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault,
												(CFURLRef)fileURL,
												CGSizeMake(size.width, size.height),
												(CFDictionaryRef)dict);
		
		if (ref != NULL) {
			// Take advantage of NSBitmapImageRep's -initWithCGImage: initializer, new in Leopard,
			// which is a lot more efficient than copying pixel data into a brand new NSImage.
			// Thanks to Troy Stephens @ Apple for pointing this new method out to me.
			NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
			NSImage *newImage = nil;
			if (bitmapImageRep) {
				newImage = [[NSImage alloc] initWithSize:[bitmapImageRep size]];
				[newImage addRepresentation:bitmapImageRep];
				[bitmapImageRep release];
				
				if (newImage) {
					CFRelease(ref);
					dispatch_async(dispatch_get_main_queue(), ^{
						CFDictionarySetValue(DMPreviewImageCache, path, newImage);
						promise(newImage);
					});
					return;
				}
			}
			CFRelease(ref);
		} else {
			// If we couldn't get a Quick Look preview, fall back on the file's Finder icon.
			NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
			if (icon) {
				[icon setSize:size];
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				CFDictionarySetValue(DMPreviewImageCache, path, icon);
				promise(icon);
			});
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			promise(nil);
		});
	});
}

void DMCacheImageWithPreviewOfFileAtPath(NSString *path, NSSize size, BOOL asIcon, PSTLevelDBMapTable *table) {
	if (DMPreviewImageDispatchQueue == NULL) {
		DMPreviewImageDispatchQueue = dispatch_queue_create("com.codafi.PreviewImages", DISPATCH_QUEUE_CONCURRENT);
	}
	dispatch_async(DMPreviewImageDispatchQueue, ^{
		if (!path) {
			return;
		}
		NSURL *fileURL = [NSURL fileURLWithPath:path];
		if (!path || !fileURL) {
			return;
		}
		
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:asIcon]
														 forKey:(NSString *)kQLThumbnailOptionIconModeKey];
		CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault,
												(CFURLRef)fileURL,
												CGSizeMake(size.width, size.height),
												(CFDictionaryRef)dict);
		
		if (ref != NULL) {
			// Take advantage of NSBitmapImageRep's -initWithCGImage: initializer, new in Leopard,
			// which is a lot more efficient than copying pixel data into a brand new NSImage.
			// Thanks to Troy Stephens @ Apple for pointing this new method out to me.
			NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
			NSImage *newImage = nil;
			if (bitmapImageRep) {
				newImage = [[NSImage alloc] initWithSize:[bitmapImageRep size]];
				[newImage addRepresentation:bitmapImageRep];
				[bitmapImageRep release];
				
				if (newImage) {
					CFRelease(ref);
					[table setData:newImage.TIFFRepresentation forKey:path];
					[newImage release];
					return;
				}
			}
			CFRelease(ref);
		} else {
			// If we couldn't get a Quick Look preview, fall back on the file's Finder icon.
			NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
			if (icon) {
				[icon setSize:size];
			}
			[table setData:icon.TIFFRepresentation forKey:path];
		}
	});

}

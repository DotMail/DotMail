//
//  CFIAttachmentItem.m
//  DotMail
//
//  Created by Robert Widmann on 8/5/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAttachmentCell.h"
#import "NSImage+QuickLook.h"

static dispatch_queue_t DMIconQueue;

static CGRect boxRect = (CGRect){ .origin.x = 28, .size.width = 215, .size.height = 280 };
static CGRect titleRect = (CGRect){ .origin.x = 9, .origin.y = 55, .size.width = 187, .size.height = 61 };
static CGRect dateRect = (CGRect){ .origin.x = 12, .origin.y = 31, .size.width = 186, .size.height = 13 };
static CGRect fromRect = (CGRect){ .origin.x = 12, .origin.y = 10, .size.width = 38, .size.height = 13 };
static CGRect senderRect = (CGRect){ .origin.x = 44, .origin.y = 7, .size.width = 154, .size.height = 20 };
static CGRect imageRect = (CGRect){ .origin.x = 13, .origin.y = 121, .size.width = 180, .size.height = 135 };

@interface DMAttachmentCell ()

@property (nonatomic, strong) NSBox *innerView;
@property (nonatomic, strong) NSTextField *attachmentTitleField;
@property (nonatomic, strong) NSTextField *attachmentDateField;
@property (nonatomic, strong) NSTextField *fromField;
@property (nonatomic, strong) NSTextField *senderField;

@end

@implementation DMAttachmentCell

+ (void)load {
	if (self.class == DMAttachmentCell.class) {
		DMIconQueue = dispatch_queue_create("com.codafi.attachments.iconqueue", 0);
	}
}

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	_innerView = [[NSBox alloc] initWithFrame:NSZeroRect];
	[_innerView setAutoresizingMask:kPSTAutoresizingMaskAll];
	[_innerView setBoxType:NSBoxCustom];
	[_innerView setBorderType:NSLineBorder];
	[_innerView setBorderWidth:3.0f];
	[_innerView setBorderColor:[NSColor colorWithCalibratedRed:0.941 green:0.951 blue:0.946 alpha:1.000]];
	[_innerView setFillColor:NSColor.whiteColor];
	[self addSubview:_innerView];
	
	_attachmentTitleField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_attachmentTitleField setAlignment:NSCenterTextAlignment];
	[_attachmentTitleField setBordered:NO];
	[_attachmentTitleField setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
	[_attachmentTitleField setBezeled:NO];
	[_attachmentTitleField setFocusRingType:NSFocusRingTypeNone];
	[_attachmentTitleField.cell setLineBreakMode:NSLineBreakByCharWrapping];
	[_attachmentTitleField.cell setTruncatesLastVisibleLine:YES];
	[_attachmentTitleField setEditable:NO];
	[_innerView addSubview:_attachmentTitleField];

	_attachmentDateField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_attachmentDateField setBordered:NO];
	[_attachmentDateField setFont:[NSFont fontWithName:@"HelveticaNeue" size:10.f]];
	[_attachmentDateField setTextColor:[NSColor colorWithCalibratedRed:0.752 green:0.784 blue:0.797 alpha:1.000]];
	[_attachmentDateField setBezeled:NO];
	[_attachmentDateField setFocusRingType:NSFocusRingTypeNone];
	[_attachmentDateField setEditable:NO];
	[_innerView addSubview:_attachmentDateField];
	
	_fromField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_fromField setBordered:NO];
	[_fromField setFont:[NSFont fontWithName:@"HelveticaNeue" size:10.f]];
	[_fromField setTextColor:[NSColor colorWithCalibratedRed:0.752 green:0.784 blue:0.797 alpha:1.000]];
	[_fromField setBezeled:NO];
	[_fromField setFocusRingType:NSFocusRingTypeNone];
	[_fromField.cell setLineBreakMode:(NSLineBreakByCharWrapping | NSLineBreakByTruncatingMiddle)];
	[_fromField.cell setTruncatesLastVisibleLine:YES];
	[_fromField setEditable:NO];
	[_fromField setStringValue:@"FROM:"];
	[_innerView addSubview:_fromField];
	
	_senderField = [[NSTextField alloc]initWithFrame:NSZeroRect];
	[_senderField setBordered:NO];
	[_senderField setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:12.f]];
	[_senderField setTextColor:[NSColor colorWithCalibratedRed:0.349 green:0.356 blue:0.360 alpha:1.000]];
	[_senderField setBezeled:NO];
	[_senderField setFocusRingType:NSFocusRingTypeNone];
	[_senderField setEditable:NO];
	[_innerView addSubview:_senderField];
	
	_attachmentPreviewImageView = [[NSImageView alloc]initWithFrame:NSZeroRect];
	[_innerView addSubview:_attachmentPreviewImageView];

	return self;
}

- (void)prepareForReuse {
	[self.mapTable removeObserverForUID:self.attachmentCache.filepath];
	[super prepareForReuse];
}

- (void)setAttachmentCache:(PSTAttachmentCache *)cache {
	if (!cache.header.receivedDate) {
		return;
	}
	
	MCOAddress *address = cache.header.from;
	if (!address) {
		address = cache.header.sender;
	}
	if (address.displayName) {
		[_senderField setStringValue:address.displayName ?: @""];
	} else {
		[_senderField setStringValue:address.mailbox ?: @""];
	}
	[_attachmentTitleField setStringValue:cache.filename ?: @""];
	[_attachmentDateField setStringValue:[cache.header.receivedDate dmAttachmentFormatString] ?: @""];
	if (cache.filename.length) {
//		dispatch_async(DMIconQueue, ^{
//			if ([self.mapTable hasDataForKey:cache.filepath]) {
//				self.attachmentPreviewImageView.image = [[NSImage alloc] initWithData:self.mapTable[cache.filepath]];
//			} else {
//				[_attachmentPreviewImageView setImage:[NSImage imageNamed:@"ArchiveAttachmentPlaceholder.png"]];
//				[self.mapTable addObserverForUID:cache.filepath withBlock:^(NSData *data) {
//					dispatch_async(dispatch_get_main_queue(), ^{
//						self.attachmentPreviewImageView.image = [[NSImage alloc] initWithData:data];
//					});
//				}];
//				DMCacheImageWithPreviewOfFileAtPath(cache.filepath, self.attachmentPreviewImageView.frame.size, YES, self.mapTable);
//			}
//		});
	}

	_attachmentCache = cache;
}

- (void)layout {
	[super layout];
	
	if (!CGRectEqualToRect(boxRect, self.innerView.frame)) {
		self.innerView.frame = boxRect;
	}
	if (!CGRectEqualToRect(titleRect, self.attachmentTitleField.frame)) {
		self.attachmentTitleField.frame = titleRect;
	}
	if (!CGRectEqualToRect(dateRect, self.attachmentTitleField.frame)) {
		self.attachmentDateField.frame = dateRect;
	}
	if (!CGRectEqualToRect(fromRect, self.fromField.frame)) {
		self.fromField.frame = fromRect;
	}
	if (!CGRectEqualToRect(senderRect, self.senderField.frame)) {
		self.senderField.frame = senderRect;
	}
	if (!CGRectEqualToRect(imageRect, self.attachmentPreviewImageView.frame)) {
		self.attachmentPreviewImageView.frame = imageRect;
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[_innerView setBorderColor:[NSColor colorWithCalibratedRed:0.361 green:0.549 blue:0.801 alpha:1.000]];
	} else {
		[_innerView setBorderColor:[NSColor colorWithCalibratedRed:0.941 green:0.951 blue:0.946 alpha:1.000]];
	}
}


@end

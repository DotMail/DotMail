//
//  DMAttachmentsViewController.m
//  DotMail
//
//  Created by Robert Widmann on 3/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAttachmentsViewController.h"
#import "DMAttachmentCell.h"
#import "DMShadowView.h"
#import "DMComposeView.h"
#import <Puissant/Puissant.h>

@interface DMAttachmentsViewController () <JNWCollectionViewGridLayoutDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) PSTLevelDBCache *cacheFile;
@property (nonatomic, strong) PSTLevelDBMapTable *previewCache;
@end

static NSSize const kMinItemSize = {243, 303};

@implementation DMAttachmentsViewController {
	NSRect _contentRect;
}

#pragma mark - Lifecycle

- (instancetype)initWithContentRect:(NSRect)frame {
	self = [super init];
	
	_contentRect = frame;
	
	return self;
}

- (void)loadView {
	NSView *view = [[NSView alloc]initWithFrame:_contentRect];
	self.attachmentsBrowser = [[DMAttachmentsBrowser alloc]initWithFrame:CGRectInset(CGRectOffset(view.bounds, 0, 15), 0, 15)];
	[self.attachmentsBrowser registerClass:DMAttachmentCell.class forCellWithReuseIdentifier:@"DMAttachmentIdentifier"];
	[self.attachmentsBrowser registerClass:DMAttachmentsSpacerFooterView.class forSupplementaryViewOfKind:JNWCollectionViewGridLayoutFooterKind withReuseIdentifier:@"DMAttachmentIdentifier"];
	JNWCollectionViewGridLayout *gridLayout = [[JNWCollectionViewGridLayout alloc] initWithCollectionView:self.attachmentsBrowser];
	gridLayout.delegate = self;
	self.attachmentsBrowser.collectionViewLayout = gridLayout;
	self.attachmentsBrowser.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
	self.attachmentsBrowser.backgroundColor = [NSColor colorWithCalibratedRed:0.966 green:0.975 blue:0.975 alpha:1.000];
	self.attachmentsBrowser.dataSource = self;
	[view addSubview:self.attachmentsBrowser];
	
	DMShadowView *shadowView = [[DMShadowView alloc]initWithFrame:NSMakeRect(0, 0, self.attachmentsBrowser.frame.size.width, 30)];
	[shadowView setBackgroundColor:self.attachmentsBrowser.backgroundColor];
	shadowView.autoresizingMask = NSViewWidthSizable;
	[view addSubview:shadowView];

	self.cacheFile = [[PSTLevelDBCache alloc] initWithPath:DMCacheDirectory()];
	if ([self.cacheFile open] == NO) {
		PSTLog(@"preview cache corrupted");
		self.previewCache = nil;
		[self.cacheFile close];
		self.cacheFile = nil;
	}
	self.previewCache = [[PSTLevelDBMapTable alloc] initWithCache:self.cacheFile dataPrefix:@"prvw."];
	
	self.view = view;
}

- (void)unload {
	[self.cacheFile close];
}

#pragma mark - Overrides

- (void)setAccount:(PSTAccountController *)account {
	_account = account;
	
	@weakify(self);
	[account.attachmentsSignal subscribeNext:^(id x) {
		@strongify(self);
		self.datasource = x;
		[self.attachmentsBrowser reloadData];
	}];
}

#pragma mark - JNWCollectionViewDataSource

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * const identifier = @"DMAttachmentIdentifier";
	DMAttachmentCell *cell = (DMAttachmentCell *)[collectionView dequeueReusableCellWithIdentifier:identifier];
	[cell setMapTable:self.previewCache];
	[cell setAttachmentCache:self.datasource[indexPath.jnw_item]];

	return cell;
}

- (void)collectionView:(JNWCollectionView *)collectionView mouseDownInItemAtIndexPath:(NSIndexPath *)indexPath {
	[QLPreviewPanel.sharedPreviewPanel setCurrentPreviewItemIndex:indexPath.jnw_item];
	[QLPreviewPanel.sharedPreviewPanel reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView {
	return 1;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datasource.count;
}

- (CGSize)sizeForItemInCollectionView:(JNWCollectionView *)collectionView {
	return CGSizeMake(243.f, 303.f);
}

- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForFooterInSection:(NSInteger)index {
	return 30.f;
}

- (JNWCollectionViewReusableView *)collectionView:(JNWCollectionView *)collectionView viewForSupplementaryViewOfKind:(NSString *)kind inSection:(NSInteger)section {
	return [self.attachmentsBrowser dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifer:@"DMAttachmentIdentifier"];
}

#pragma mark - QLPreviewPanel

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel; {
	return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
	previewPanel = panel;
	panel.delegate = self;
	panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
	previewPanel = nil;
}

#pragma mark - QLPreviewPanelDatasource

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
	return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
	if (!self.attachmentsBrowser.indexPathsForSelectedItems.count) return nil;
	return self.datasource[(NSUInteger)[self.attachmentsBrowser.indexPathsForSelectedItems[0] indexAtPosition:1]];
}

#pragma mark - QLPreviewPanelDelegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
	if (event.type == NSKeyDown) {
		[self.attachmentsBrowser keyDown:event];
		return YES;
	}
	return NO;
}

- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
	return (NSRect){ .origin.x = NSWidth(self.view.frame)/2 - 120, .origin.y = NSHeight(self.view.frame)/2 - 150, .size = { 243, 303 } };
}

- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect {
	DMAttachmentCell *downloadItem = (DMAttachmentCell*)[self.attachmentsBrowser cellForItemAtIndexPath:[NSIndexPath jnw_indexPathForItem:[self.datasource indexOfObject:item] inSection:0]];
	return downloadItem.attachmentPreviewImageView.image;
}

#pragma mark - Private

static NSString *DMCacheDirectory() {
	return [@"~/Library/Application Support/DotMail/AttachmentPreview.ldb" stringByExpandingTildeInPath];
}

@end

//
//  DMAccountContainerView.m
//  Mail
//
//  Created by Robert Widmann on 10/30/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMAccountContainerView.h"
#import "DMAccountView.h"
#import "DMFolderView.h"
#import "NSColor+DMUIColors.h"
#import "DMPersistentStateManager.h"

@interface DMAccountContainerView () <DMAccountViewActionDelegate, DMFolderViewActionDelegate>
@property (nonatomic, strong) NSMutableArray *mainFolderViews;
@property (nonatomic, strong) NSMutableArray *otherFolderViews;
@property (nonatomic, strong) NSMutableArray *folderViews;
@end

@implementation DMAccountContainerView {
	CGRect _originalFrame;
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
		
	_originalFrame = frame;
	_mainFolderViews = [NSMutableArray array];
	_otherFolderViews = [NSMutableArray array];
	_folderViews = [NSMutableArray array];
	
	_foldersContainerView = [[TUIScrollView alloc]initWithFrame:frame];
	_foldersContainerView.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	_foldersContainerView.alwaysBounceVertical = YES;
	_foldersContainerView.scrollIndicatorStyle = TUIScrollViewIndicatorStyleLight;
	_foldersContainerView.horizontalScrollIndicatorVisibility = TUIScrollViewIndicatorVisibleNever;
	[self addSubview:self.foldersContainerView];
	
	_accountView = [[DMAccountView alloc]init];
	_accountView.actionDelegate = self;
	_accountView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[self addSubview:self.accountView];
	
	_labelSeparatorView = [[DMLabelSeparatorView alloc]init];
	_labelSeparatorView.account = _account;
	_labelSeparatorView.autoresizingMask = (TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleWidth);
	[self.labelSeparatorView updateCount];
	[self.foldersContainerView addSubview:self.labelSeparatorView];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(recolor) name:PSTMailAccountLabelColorsUpdatedNotification object:nil];
	
	return self;
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Folder Management

- (void)insertMainFolderOfType:(PSTFolderType)folderSelectionNumber {
	DMFolderView *newFolder = [[DMFolderView alloc]init];
	[newFolder setAutoresizingMask:(TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleWidth)];
	[newFolder setAccount:self.account];
	[newFolder setSelected:NO];
	[newFolder setActionDelegate:self];
	[newFolder setSelection:folderSelectionNumber];
	[newFolder updateCount];
	[self.mainFolderViews addObject:newFolder];
	[self.foldersContainerView addSubview:newFolder];
}

- (void)insertLabelOfType:(PSTFolderType)folderType {
	DMFolderView *newFolder = [[DMFolderView alloc]init];
	[newFolder setAutoresizingMask:(TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleWidth)];
	[newFolder setAccount:self.account];
	[newFolder setSelected:NO];
	[newFolder setLevel:1];
	[newFolder setActionDelegate:self];
	[newFolder setSelection:folderType];
	[newFolder updateCount];
	[self.folderViews addObject:newFolder];
	[self.foldersContainerView addSubview:newFolder];
}

#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.selected) {
		[self.accountView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
		[self _calcScrollviewHeight];
		[self.foldersContainerView setFrame:CGRectMake(0, 30, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30)];
		NSUInteger index = 0;
		NSUInteger height = roundtol(self.foldersContainerView.contentSize.height) - (70 - (30 * self.index));
		NSUInteger labelsHeight = height - 80;
		
		for (DMFolderView *folderView in self.mainFolderViews) {
			[folderView setFrame:CGRectMake(0, height-(index*30), CGRectGetWidth(self.frame), 25)];
			[folderView setAlpha:1.0f];
			index++;
		}
		[self.foldersContainerView bringSubviewToFront:self.labelSeparatorView];
		[self.labelSeparatorView setFrame:CGRectMake(0, height-(index*30), CGRectGetWidth(self.frame), 25)];
		[self.labelSeparatorView setAlpha:1.0f];
		
		for (NSUInteger i = 0; i < self.folderViews.count; i++) {
			DMFolderView *folderView = self.folderViews[i];
			if (folderView.selection != PSTFolderTypeAllMail && folderView.selection != PSTFolderTypeSpam && [self.account.visibleLabels indexOfObjectIdenticalTo:folderView.path] == NSNotFound) {
				folderView.alpha = 0.0f;
				continue;
			}
			folderView.frame = CGRectMake(0, labelsHeight-(index*20), CGRectGetWidth(self.frame), 16);
			NSColor *colorHex = [self.account colorForLabel:folderView.path ?: folderView.title];
			[folderView setLabelColor:colorHex];
			[folderView setAlpha:1.0f];
			index++;
		}
	} else {
		[self.accountView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
		int index = 0;
		
		for (DMFolderView *folderView in self.mainFolderViews) {
			[folderView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 25)];
			[folderView setAlpha:0.0f];
			index++;
		}
		[self.foldersContainerView bringSubviewToFront:self.labelSeparatorView];
		[self.labelSeparatorView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 25)];
		[self.labelSeparatorView setAlpha:0.0f];
		[self.folderViews makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
	}
}

- (void)recolor {
	for (DMFolderView *folderView in self.folderViews) {
		NSColor *colorHex = [self.account colorForLabel:folderView.path ?: folderView.title];
		[folderView setLabelColor:colorHex];
	}
}

- (void)updateCount {
	[self.accountView updateCount];
	for (DMFolderView *folderView in self.mainFolderViews) {
		[folderView updateCount];
	}
	for (DMFolderView *folderView in self.otherFolderViews) {
		[folderView updateCount];
	}
	for (DMFolderView *folderView in self.folderViews) {
		[folderView updateCount];
	}
}

#pragma mark - Overrides

- (void)setAccount:(PSTAccountController *)account {
	_account = account;
	[self.accountView setAccount:account];
	for (DMFolderView *folderView in self.mainFolderViews) {
		[folderView removeFromSuperview];
	}
	[self.mainFolderViews removeAllObjects];
	for (DMFolderView *folderView in self.otherFolderViews) {
		[folderView removeFromSuperview];
	}
	[self.otherFolderViews removeAllObjects];
	for (DMFolderView *folderView in self.folderViews) {
		[folderView removeFromSuperview];
	}
	[self.folderViews removeAllObjects];
	
	[self insertMainFolderOfType:PSTFolderTypeInbox];
	[self insertMainFolderOfType:PSTFolderTypeNextSteps];
	[self insertMainFolderOfType:PSTFolderTypeStarred];
	[self insertMainFolderOfType:PSTFolderTypeDrafts];
	[self insertMainFolderOfType:PSTFolderTypeSent];
	[self insertMainFolderOfType:PSTFolderTypeTrash];
	
	if ([self.account accounts].count == 1) {
		if ([self.account isFolderSelectionAvailable:PSTFolderTypeAllMail]) {
			[self insertLabelOfType:PSTFolderTypeAllMail];
		}
		if ([self.account isFolderSelectionAvailable:PSTFolderTypeSpam]) {
			[self insertLabelOfType:PSTFolderTypeSpam];
		}
	}
	
	for (NSString *label in self.account.allLabels) {
		DMFolderView *newFolder = [[DMFolderView alloc]init];
		[newFolder setAutoresizingMask:(TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleWidth)];
		[newFolder setAccount:self.account];
		[newFolder setSelected:NO];
		[newFolder setPath:label];
		[newFolder setLevel:1];
		[newFolder setActionDelegate:self];
		[newFolder setSelection:PSTFolderTypeLabel];
		[newFolder updateCount];
		[self.folderViews addObject:newFolder];
		[self.foldersContainerView addSubview:newFolder];
	}
}

//Loop through to check if any folder is selected at all.
//If not, default to the inbox folder.
- (void)setSelection:(PSTFolderType)selection path:(NSString *)path {
	_selection = selection;
	_path = path;
	BOOL flag = NO;
	for (DMFolderView *folderView in self.mainFolderViews) {
		BOOL folderSelected = [self _checkFolderSelected:folderView];
		if (folderSelected == YES) {
			flag = YES;
		}
	}
	for (DMFolderView *folderView in self.otherFolderViews) {
		BOOL folderSelected = [self _checkFolderSelected:folderView];
		if (folderSelected == YES) {
			flag = YES;
		}
	}
	for (DMFolderView *folderView in self.folderViews) {
		BOOL folderSelected = [self _checkFolderSelected:folderView];
		if (folderSelected == YES) {
			flag = YES;
		}
	}
	if (flag == NO) {
		if (self.mainFolderViews.count != 0) {
			[self.account selectInbox];
			DMFolderView *folderView = [self.mainFolderViews objectAtIndex:0];
			[folderView setSelected:YES];
		}
	}
}

#pragma mark - Private

PUISSANT_TODO(Why the heck did I write this with gotos?)

- (BOOL)_checkFolderSelected:(DMFolderView*)folderView {
	BOOL result = NO;
	if (self.selection == PSTFolderTypeLabel) {
		if (self.path != nil) {
			goto checkSpam;
		}
		if (folderView.selection != PSTFolderTypeDrafts) {
			goto checkSelection;
		}
	checkSelection:
		if (folderView.selection == PSTFolderTypeLabel) {
		checkSpam:
			if ([self.path isEqualToString:@"SPAM"]) {
				if (self.selection == PSTFolderTypeSpam) {
					[folderView setSelected:YES];
					result = YES;
					return result;
				}
			}
		}
	}
	if (folderView.selection == self.selection) {
		if (folderView.path == nil && self.path == nil) {
			[folderView setSelected:YES];
			result = YES;
			return result;
		}
	} else {
		[folderView setSelected:NO];
		result = NO;
		return result;
	}
	if (![folderView.path isEqualToString:self.path]) {
		[folderView setSelected:NO];
		result = NO;
	} else {
		[folderView setSelected:YES];
		result = YES;
	}
	return result;
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	[self.accountView setSelected:selected];
}

-(void)_calcScrollviewHeight {
	NSUInteger mainFolderViewHeight = ((self.mainFolderViews.count + 1) * 30);
	NSUInteger otherFoldersHeight = (self.folderViews.count * 20);
	NSUInteger padding = 70 - (30 * self.index);
	[self.foldersContainerView setContentSize:CGSizeMake(CGRectGetWidth(self.frame), mainFolderViewHeight + otherFoldersHeight + padding)];
}

#pragma mark - DMAccountViewActionDelegate

- (void)accountViewDidBecomeSelected:(DMAccountView *)accountView {
	[self.actionDelegate containerView:self selection:PSTFolderTypeInbox path:nil];
}

- (void)accountViewWantsRefresh:(DMAccountView *)accountView {
	if (self.account.selectedFolder == (PSTFolderTypeImportant | PSTFolderTypeInbox)) {
		if (self.account.selectedFolder == PSTFolderTypeNone) {
			[self.actionDelegate containerViewWantsRefresh:self];
		} else {
			[self.actionDelegate containerView:self selection:PSTFolderTypeInbox path:nil];
		}
	} else {
		[self.actionDelegate containerView:self selection:PSTFolderTypeInbox path:nil];
	}
}

#pragma mark - DMFolderViewActionDelegate

- (void)folderViewWantsRefresh:(DMFolderView *)folderView {
	[self.actionDelegate containerViewWantsRefresh:self];
}

- (void)folderViewDidBecomeSelected:(DMFolderView *)folderView {
	[self.actionDelegate containerView:self selection:folderView.selection path:folderView.path];
}

@end

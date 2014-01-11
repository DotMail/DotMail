//
//  DMUpdateViewController.m
//  DotMail
//
//  Created by Robert Widmann on 10/26/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMUpdatePopoverViewController.h"
#import "NSColor+DMUIColors.h"
#import "DMUpdateSectionHeaderView.h"
#import "DMUpdateItemCell.h"

static CGFloat const DMUpdateItemCellHeight = 42.0f;

@interface DMUpdatePopoverViewController ()

@property (nonatomic, strong) NSArray *updates;
@property (nonatomic, strong) TUITableView *tableView;
@property (nonatomic, strong) NSString *headerItem;

@end

@implementation DMUpdatePopoverViewController

#pragma mark - Lifecycle

- (instancetype)initWithReleaseNotes:(NSString *)releaseNotes {
	self = [super init];
	
	_releaseNotes = releaseNotes;
	
	return self;
}

- (void)loadView {
	TUINSView *view = [[TUINSView alloc]initWithFrame:CGRectMake(0, 0, 400, 305)];

	TUIView *tui_view = [[TUIView alloc]initWithFrame:view.bounds];
	[tui_view setBackgroundColor:[NSColor whiteColor]];
	[(TUINSView*)view setRootView:tui_view];
	
	TUIView *toolbar = [[TUIView alloc]initWithFrame:CGRectMake(0, NSMaxY(view.bounds)-36, NSWidth(view.bounds), 36)];
	[toolbar setBackgroundColor:[NSColor colorWithCalibratedWhite:0.922 alpha:1.000]];
	[tui_view addSubview:toolbar];
	
	TUIButton *relaunchButton = [[TUIButton alloc]initWithFrame:CGRectMake(NSMaxX(view.bounds) - 96, NSMaxY(view.bounds)-30, 90, 26)];
	[relaunchButton addActionForControlEvents:TUIControlEventMouseUpInside block:^{
		NSString *relaunchPath = [[NSBundle bundleWithIdentifier:@"com.codafi.MoonShine"]pathForResource:@"relaunch" ofType:@""];
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[relaunchPath lastPathComponent]];
		
		[NSFileManager.defaultManager removeItemAtPath:path error:nil];
		NSError *error = nil;
		BOOL success = [NSFileManager.defaultManager copyItemAtPath:relaunchPath toPath:path error:&error];
		if (success == NO) {
			NSRunAlertPanel(@"Could Not Relaunch", @"It seems we weren't able to restart DotMail for you.  The update will be installed next time you quit the app.", nil, nil, nil);
		} else {
			__strong id args[2];
			args[0] = [[NSBundle mainBundle] bundlePath];
			args[1] = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
			[NSTask launchedTaskWithLaunchPath:relaunchPath arguments:[NSArray arrayWithObjects:(__strong id*)args count:2]];
			[NSApp terminate:nil];
		}
	}];
	[relaunchButton setTitle:@"Relaunch" forState:TUIControlStateNormal];
	relaunchButton.titleLabel.alignment = TUITextAlignmentCenter;
	[relaunchButton setTitleColor:[NSColor colorWithCalibratedRed:0.408 green:0.463 blue:0.504 alpha:1.000] forState:TUIControlStateNormal];
	relaunchButton.titleLabel.font = [NSFont fontWithName:@"HelveticaNeue=Bold" size:16.f];
	[relaunchButton setBackgroundColor:[NSColor colorWithCalibratedWhite:0.812 alpha:1.000]];
	[tui_view addSubview:relaunchButton];
	
	TUILabel *explanationLabel = [[TUILabel alloc]initWithFrame:CGRectOffset(toolbar.bounds, 6, 0)];
	[explanationLabel setUserInteractionEnabled:NO];
	[explanationLabel setFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:12]];
	[explanationLabel setTextColor:[NSColor colorWithCalibratedWhite:0.267 alpha:1.000]];
	[explanationLabel setBackgroundColor:NSColor.clearColor];
	[explanationLabel setText:@"Updates are ready to be installed!"];
	[toolbar addSubview:explanationLabel];
	
	CGRect tableFrame = view.bounds;
	tableFrame.size.height -= 36;
	self.tableView = [[TUITableView alloc]initWithFrame:tableFrame style:TUITableViewStyleGrouped];
	[self.tableView setAlwaysBounceVertical:YES];
	[self.tableView setBackgroundColor:NSColor.whiteColor];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setClipsToBounds:YES];
	[tui_view addSubview:self.tableView];
	
	[self setView:view];
}

#pragma mark - Overrides

- (void)setReleaseNotes:(NSString *)releaseNotes {
	_releaseNotes = releaseNotes;
	NSMutableArray *updateItems = [releaseNotes componentsSeparatedByString:@"\n"].mutableCopy;
	_headerItem = [updateItems[0] substringFromIndex:3];
	[updateItems removeObjectAtIndex:0];
	_updates = updateItems.copy;
	[self.tableView reloadData];
}


#pragma mark - TUITableViewDatasource

- (NSInteger)tableView:(TUITableView *)table numberOfRowsInSection:(NSInteger)section {
	return self.updates.count;
}

- (NSInteger)numberOfSectionsInTableView:(TUITableView *)tableView {
	return 1;
}

- (TUIView *)tableView:(TUITableView *)tableView headerViewForSection:(NSInteger)section {
	DMUpdateSectionHeaderView *header = [[DMUpdateSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 24.0f)];
	[header setVersion:self.headerItem];
	return header;
}

- (TUITableViewCell *)tableView:(TUITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DMUpdateItemCell *cell = reusableTableCellOfClass(tableView, DMUpdateItemCell);
		
	[cell setUpdateItemDescription:self.updates[indexPath.row]];
	
	return cell;
}

#pragma mark - TUITableViewDelegate

- (CGFloat)tableView:(TUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return DMUpdateItemCellHeight;
}

@end

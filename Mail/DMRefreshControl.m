/*
 Copyright 2011 Twitter, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "DMRefreshControl.h"
#import <TwUI/TUIView.h>
#import <TwUI/TUITableView.h>
#import <TwUI/TUILabel.h>
#import <TwUI/TUICGAdditions.h>
#import <TwUI/TUIProgressBar.h>



CGFloat const kRefreshViewHeight = 45;

@interface DMRefreshControl ()

@property (nonatomic, strong) TUITableView *tableView;
@property (nonatomic, strong) TUIView *headerView;
@property (nonatomic, strong) TUILabel *topLabel;
@property (nonatomic, strong) TUIProgressBar *progressBar;

@end

@implementation DMRefreshControl

- (instancetype)initInTableView:(TUITableView *)tableView {
	self = [super initWithFrame:tableView.bounds];
	
	_tableView = tableView;
	_headerView = [[TUIView alloc] initWithFrame:CGRectMake(0, kRefreshViewHeight, self.bounds.size.width, kRefreshViewHeight)];
	[_headerView setBackgroundColor:NSColor.whiteColor];
	[self.tableView setPullDownView:_headerView];

	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1/500.0;
	[_headerView.layer setSublayerTransform:transform];
	
	_topLabel = [[TUILabel alloc] initWithFrame:CGRectMake(26, -15, self.bounds.size.width, kRefreshViewHeight)];
	[_topLabel setBackgroundColor:[NSColor clearColor]];
	[_topLabel setText:@"Last Updated: 1/11/13 8:41 PM"];
	[_topLabel setAlignment:TUITextAlignmentCenter];
	[_topLabel setTextColor:[NSColor colorWithCalibratedRed:0.395 green:0.427 blue:0.510 alpha:1]];
	[_topLabel.layer setShadowColor:[[NSColor whiteColor] colorWithAlphaComponent:0.7].CGColor];
	[_topLabel.layer setShadowOffset:CGSizeMake(0, 1)];
	[_headerView addSubview:_topLabel];
	
	_progressBar = [[TUIProgressBar alloc]initWithFrame:(CGRect){ .origin.x = 20, .size.width = 50, .size.height = 14 } style:TUIProgressBarStyleBlue];
	[_headerView addSubview:_progressBar];
	
	_refreshing = NO;
	
	@weakify(self);
	[[RACObserve(self.tableView,contentOffset) skip:1] subscribeNext:^(NSValue *x) {
		@strongify(self);
		if (!_refreshing){
			CGFloat fraction = (x.pointValue.y - NSHeight(self.tableView.frame)) / -kRefreshViewHeight;
			if (fraction < 0) { fraction = 0; }
			else if (fraction > 1) {
				fraction = 1;
			} else {
//				NSLog(@"%f", fraction);
			}
			[self fillHeaderToFraction:fraction];
		}
		[self setNeedsDisplay];
	}];
	
	return self;
}

- (void)fillHeaderToFraction:(CGFloat)fraction {
	[self.progressBar setProgress:fraction];
}

- (void)beginRefreshing {
	[self.progressBar setIndeterminate:YES];
}

- (void)endRefreshing {
	
}

@end
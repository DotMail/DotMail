//
//  DMPullToRefreshScrollView.h
//  DotMail
//
//  Created by Robert Widmann on 9/13/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMLayeredScrollView.h"

@protocol DMPullToRefreshScrollViewDelegate;

@interface DMPullToRefreshScrollView : DMLayeredScrollView

@property (nonatomic, weak) id<DMPullToRefreshScrollViewDelegate> delegate;
@property (assign) id target;
@property (assign) SEL selector;
@property (readonly, getter = isRefreshing) BOOL refreshing;

- (void)startLoading;
- (void)stopLoading;

@end

@protocol DMPullToRefreshScrollViewDelegate <NSObject>

- (void)scrollViewDidTriggerRefresh:(DMPullToRefreshScrollView *)scrollView;

@end
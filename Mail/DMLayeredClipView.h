//
//  DMLayeredClipView.h
//  DotMail
//
//  Created by Robert Widmann on 8/8/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMLayeredClipView : NSClipView

@end

@interface DMPullToRefreshClipView : DMLayeredClipView

- (BOOL)isRefreshing;

@end

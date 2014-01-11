//
//  MKColorWell.h
//  Color Picker
//
//  Created by Mark Dodwell on 5/26/12.
//  Copyright (c) 2012 mkdynamic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MKColorWellDelegate;

@interface MKColorWell : NSColorWell {
    NSPopover *popover;
    NSViewController *popoverViewController;
    NSView *popoverView;
}

@property (nonatomic, assign) BOOL animatePopover;
@property (nonatomic, assign) id<MKColorWellDelegate> delegate;

- (void)setColorAndClose:(NSColor *)aColor;

@end

@protocol MKColorWellDelegate <NSObject>

- (void)colorWell:(MKColorWell *)colorWell didCloseWithColor:(NSColor *)aColor;

@end

//
//  CFIPopUpButton.m
//  DotMail
//
//  Created by Robert Widmann on 7/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMPopUpButton.h"


@implementation DMPopUpButton

- (void)selectItem:(NSMenuItem *)item {
	[self setNeedsDisplay];
	[super selectItem:item];
}

- (RACSignal *)rac_selectionSignal {
	@weakify(self);
	return [RACSignal
			createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		[self setTarget:subscriber];
		[self setAction:@selector(sendNext:)];
		[self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
			[subscriber sendCompleted];
		}]];
		
		return [RACDisposable disposableWithBlock:^{
			@strongify(self);
			[self setTarget:nil];
			[self setAction:NULL];
		}];
	}];
}

@end

@implementation CFIColorPopUpButton

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
}

@end
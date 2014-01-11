//
//  CFIFontMenu.m
//  DotMail
//
//  Created by Robert Widmann on 7/13/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

#import "DMFontMenu.h"

@interface DMFontMenu ()

//internally used to represent the default list of fonts to appear at the top
//of the control and in the regular list of fonts.
@property (nonatomic, strong) NSArray *primaryFonts;

@end

@implementation DMFontMenu

+ (id)sharedFontMenu {
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		//List of common fonts for the top of the list
		self.primaryFonts = @[@"Courier New", @"Geneva", @"Georgia", @"Hoefler Text", @"Helvetica Neue", @"Impact", @"Marker Felt", @"Menlo", @"Trebuchet", @"Verdana"];
		
		for (NSString *font in self.primaryFonts) {
			[self addItem:[[NSMenuItem alloc]initWithTitle:font action:nil keyEquivalent:@""]];
		}
		[self addItem:[NSMenuItem separatorItem]]; //insert a separator between
		for (NSString* font in [[NSFontManager sharedFontManager] availableFontFamilies]) {
			[self addItem:[[NSMenuItem alloc]initWithTitle:font action:nil keyEquivalent:@""]];
		}
	}
	return self;
}
@end

//
//  DMTokenizingEmailField.m
//  DotMail
//
//  Created by Robert Widmann on 2/2/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMTokenizingEmailField.h"
#import <Puissant/PSTAddressBookManager.h>

@interface DMTokenizingEmailField ()

@property (nonatomic, assign) BOOL tokenizing;

@end

@implementation DMTokenizingEmailField


- (void)setAddresses:(NSArray *)addresses {
	NSMutableArray *normalizedAddresses = [[NSMutableArray alloc]init];
	for (MCOAddress *address in addresses) {
		[normalizedAddresses addObject:[address nonEncodedRFC822String]];
	}
	[self setTokenArray:normalizedAddresses];
}

- (NSArray *)addresses {
	NSMutableArray *retVal = [NSMutableArray array];
	for (NSString *string in self.tokenArray) {
		if (!string.length) continue;
		MCOAddress *address = [MCOAddress addressWithNonEncodedRFC822String:string];
		if (address != nil) {
			[retVal addObject:address];
		}
	}
	return retVal;
}

- (void)setTokenArray:(NSArray *)tokenArray {
	[self willChangeValueForKey:@"addresses"];
	NSMutableArray *normalizedAddresses = tokenArray.mutableCopy;
	if ([[tokenArray lastObject]isKindOfClass:MCOAddress.class]) {
		normalizedAddresses = [[NSMutableArray alloc]init];
		for (MCOAddress *address in tokenArray) {
			[normalizedAddresses addObject:[address nonEncodedRFC822String]];
		}
	}
	[super setTokenArray:normalizedAddresses];
	[self didChangeValueForKey:@"addresses"];
	[self setNeedsDisplay:YES];
}

@end

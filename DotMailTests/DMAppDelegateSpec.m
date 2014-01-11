//
//  DMAppDelegateSpec.m
//  DotMail
//
//  Created by Robert Widmann on 5/17/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMAppDelegate.h"

@interface DMAppDelegateSpec : XCTestCase

@end

@implementation DMAppDelegateSpec

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testTypeOfDelegate {
	XCTAssertNotNil([NSApp delegate], @"");
	XCTAssertEqual([[NSApp delegate] class], DMAppDelegate.class, @"");
	XCTAssertEqualObjects([NSApp delegate], NSApplication.sharedApplication.delegate, @"Application delegate is not equal to NSApplication.delegate");
}

- (void)testInfoDictionaryVersionNumbers {
	XCTAssertEqualObjects([(DMAppDelegate *)[NSApp delegate] shortVersionNumber], NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"], @"Application delegate is not equal to NSApplication.delegate");
	XCTAssertEqualObjects([(DMAppDelegate *)[NSApp delegate] bundleVersionNumber], NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"], @"Application delegate is not equal to NSApplication.delegate");
	XCTAssertNotNil([(DMAppDelegate *)[NSApp delegate] versionColloquialName], @"Application delegate does not have a colloquial name associated with it.");
}

- (void)testDelegateHasAboutWindow {
	XCTAssertNotNil([(DMAppDelegate *)[NSApp delegate] aboutWindowController], @"Application does not have a viable about window present.");
}

@end

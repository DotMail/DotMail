//
//  DMApplication.h
//  DotMail
//
//  Created by Robert Widmann on 7/3/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

@interface DMApplication : NSApplication

typedef void (^DMSheetHandler)(NSInteger returnCode);

- (void)dm_beginSheet:(NSWindow *)sheet modalForWindow:(NSWindow *)modalWindow completion:(DMSheetHandler)handler;
- (void)dm_presentError:(NSError *)error modalForWindow:(NSWindow *)window;

@end

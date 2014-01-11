//
//  NSAlert+DMSynchronicity.h
//  DotMail
//
//  Created by Robert Widmann on 10/17/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@interface NSAlert (DMSynchronicity)

- (NSInteger)runModalSheetForWindow:(NSWindow *)aWindow;
- (NSInteger)runModalSheet;

@end

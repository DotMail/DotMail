//
//  CFIPopUpButton.h
//  DotMail
//
//  Created by Robert Widmann on 7/12/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

@interface DMPopUpButton : NSPopUpButton

- (RACSignal *)rac_selectionSignal;

@end

@interface CFIColorPopUpButton : DMPopUpButton

@end

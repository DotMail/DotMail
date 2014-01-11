//
//  CFIFontMenu.h
//  DotMail
//
//  Created by Robert Widmann on 7/13/12.
//  Copyright (c) 2012 CodaFi Inc. All rights reserved.
//

/**
 An NSMenu subclass that produces a shared menu containing all the fonts
 installed on the machine.  It is a singleton for loading purposes, as the
 font-to-menu loop is a very expensive operation, so we only do it once per
 application cycle this way.
 */



@interface DMFontMenu : NSMenu

//Default initializer
+ (id)sharedFontMenu;

@end

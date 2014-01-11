//
//  DMWindowErrorBanner.h
//  DotMail
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi Inc. All rights reserved.
//

#import "DMShadowView.h"

@interface DMWindowErrorBanner : DMShadowView

@property (nonatomic, strong) NSError *error;

@end

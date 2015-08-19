//
//  CommonAlert.h
//  MobileTV
//
//  Created by itpro on 4/19/15.
//  Copyright (c) 2015 ITPRO. All rights reserved.
//

#ifndef MobileTV_CommonAlert_h
#define MobileTV_CommonAlert_h
#import <Foundation/Foundation.h>

@interface CommonAlert : NSObject

// a singleton:
+ (CommonAlert*) sharedCommonAlert;

- (void)showServerCommonErrorAlert;

@end

#endif

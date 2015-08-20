//
//  HTMLHelper.h
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#ifndef LazzyBee_HTMLHelper_h
#define LazzyBee_HTMLHelper_h
#import <Foundation/Foundation.h>

@interface HTMLHelper : NSObject

// a singleton:
+ (HTMLHelper*) sharedHTMLHelper;

- (NSString *)createHTMLForQuestion:(NSString *)word;
@end

#endif

//
//  Algorithm.h
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#ifndef LazzyBee_Algorithm_h
#define LazzyBee_Algorithm_h
#import <Foundation/Foundation.h>
#import "WordObject.h"

#define EASE_AGAIN 0
#define EASE_HARD 1
#define EASE_GOOD 2
#define EASE_EASY 3

@interface Algorithm : NSObject

// a singleton:
+ (Algorithm*) sharedAlgorithm;

- (NSArray *)nextIvlStrLst:(WordObject *)wordObj;
- (void)updateWord:(WordObject *)wordObj withEaseLevel:(int)ease;
@end

#endif

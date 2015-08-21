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

@interface Algorithm : NSObject

// a singleton:
+ (Algorithm*) sharedAlgorithm;

- (NSArray *)getArrayOfDaysToReview:(WordObject *)wordObj;
- (void)updateScheduleToReviewWord:(WordObject *)wordObj afterDays:(NSInteger)days;
@end

#endif

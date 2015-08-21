//
//  Algorithm.m
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import "Algorithm.h"
#import "UIKit/UIKit.h"
#import "sqlite3.h"
#import "Common.h"
// Singleton
static Algorithm* sharedAlgorithm = nil;

@implementation Algorithm


//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
+ (Algorithm*) sharedAlgorithm {
    // lazy instantiation
    if (sharedAlgorithm == nil) {
        sharedAlgorithm = [[Algorithm alloc] init];
    }
    return sharedAlgorithm;
}


//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
    }
    return self;
}

- (NSArray *)getArrayOfDaysToReview:(WordObject *)wordObj {
    return nil;
}

- (void)updateScheduleToReviewWord:(WordObject *)wordObj afterDays:(NSInteger)days {
    
}
@end

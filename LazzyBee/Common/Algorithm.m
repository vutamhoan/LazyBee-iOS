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

#define SECONDS_PERDAY 86400

//private static final int[] FACTOR_ADDITION_VALUES = { -300, -150, 0, 150 };
#define BONUS_EASY 1.4
#define MIN_FACTOR 1300

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

#pragma mark internal function
- (int)factorAdditionValue:(int)ease {
    if (ease == EASE_AGAIN) {
        return -300;
        
    } else if (ease == EASE_HARD) {
        return -150;
        
    } else if (ease == EASE_GOOD) {
        return 0;
        
    } else if (ease == EASE_EASY) {
        return 150;
        
    } else {
        return 0;
    }
}


/*
 Return string of next time to review corresponded to ease level
 */
- (NSString *)nextIvlStr:(WordObject *)wordObj withEaseLevel:(int)ease {
    NSString *str;
    int ivl = [self nextIntervalBySeconds:wordObj withEaseLevel:ease];
    
    if (ivl < SECONDS_PERDAY)
        str =  @"< 10min";
    
    else {
        int day = ivl / SECONDS_PERDAY;
        if (day <= 30)
            str = [NSString stringWithFormat:@"%d day(s)", (int)round(day)];
        else {
            int month = day / 30;
            str = [NSString stringWithFormat:@"%d month(s)", (int)round(month)];
            
            if (month > 12) {
                double year = day / 365;

                str = [NSString stringWithFormat:@"%0.1f year(s)", year];
            }
        }
    }
    return str;
}

/**
 * Return the next interval for CARD, in seconds.
 */
- (int)nextIntervalBySeconds:(WordObject *)wordObj withEaseLevel:(int)ease {
    if (ease == EASE_AGAIN){
        return 600; /*10 minute*/
    }
    else {
        return [self nextIntervalByDays:wordObj withEaseLevel:ease] * SECONDS_PERDAY;
    }
}

/**
 * Ideal next interval by days for CARD, given EASE > 0
 */
- (int)nextIntervalByDays:(WordObject *)wordObj withEaseLevel:(int)ease {
    NSInteger delay = [self daysLate:wordObj];
    int interval = 0;
    
    double fct = [wordObj.eFactor integerValue] / 1000.0;
    int intLastInterval = [wordObj.lastInterval intValue];
    int ivl_hard = MAX((int)((intLastInterval + delay/4) * 1.2), intLastInterval + 1);
    int ivl_good = MAX((int)((intLastInterval + delay/2) * fct), ivl_hard + 1);
    int ivl_easy = MAX((int)((intLastInterval + delay) * fct * BONUS_EASY), ivl_good + 1);
    
    if (ease == EASE_HARD) {
        interval = ivl_hard;
        
    } else if (ease == EASE_GOOD) {
        interval = ivl_good;
        
    } else if (ease == EASE_EASY) {
        interval = ivl_easy;
    }
    // Should we maximize the interval?
    return interval;
}

/**
 * Number of days later than scheduled.
 * only for reviewing, not just learnt few minute ago
 */
- (NSInteger)daysLate:(WordObject *)wordObj {
    int queue = [wordObj.queue intValue];
    if(queue != QUEUE_REVIEW) {
        return 0;
    }
    
    NSInteger due = [wordObj.due integerValue];
    NSInteger now = [[Common sharedCommon] getCurrentDateInSec];
    
    NSInteger diff_day = (now - due)/SECONDS_PERDAY;
    return MAX(0, diff_day);
}


#pragma mark external function
/*
 Return string of next time to review corresponded to ease level
 */
- (NSArray *)nextIvlStrLst:(WordObject *)wordObj {
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++){
        [res addObject:[self nextIvlStr:wordObj withEaseLevel:i]];
    }
    
    return res;
}

/**
 * Whenever a Card is answered, call this function on Card.
 * Scheduler will update the following parameters into Card's instance:
 * <ul>
 * <li>due
 * <li>last_ivl
 * <li>queue
 * <li>e_factor
 * <li>rev_count
 * </ul>
 * After 'answerCard', the caller will check Card's data for further decisions
 * (update database or/and put it back to app's queue)
 */
- (void)updateWord:(WordObject *)wordObj withEaseLevel:(int)ease {
    int nextIvl = [self nextIntervalBySeconds:wordObj withEaseLevel:ease];
    
    NSTimeInterval current = [[Common sharedCommon] getCurrentDateInSec];
    
    if (nextIvl < SECONDS_PERDAY) {
        /*User forget card or just learnt
         * We don't re-count 'due', because app will put it back to learnt queue
         * */
        wordObj.queue = [NSString stringWithFormat:@"%d", QUEUE_LEARNED];
        //Reset last-interval to reduce next review
        wordObj.lastInterval = @"0";
        
    } else {
        wordObj.queue = [NSString stringWithFormat:@"%d", QUEUE_REVIEW];
        wordObj.due = [NSString stringWithFormat:@"%.f", current + nextIvl];
        wordObj.lastInterval =  [NSString stringWithFormat:@"%d", [self nextIntervalByDays:wordObj withEaseLevel:ease]];
    }
    
    int eFactor = MAX( MIN_FACTOR, [wordObj.eFactor intValue] + [self factorAdditionValue:ease]);
    wordObj.eFactor = [NSString stringWithFormat:@"%d", eFactor];
}

@end

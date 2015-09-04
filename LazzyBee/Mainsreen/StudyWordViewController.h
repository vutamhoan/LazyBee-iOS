//
//  StudyWordViewController.h
//  LazzyBee
//
//  Created by HuKhong on 8/20/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordObject.h"

typedef enum {
    Mode_New_Word = 0,
    Mode_Study,
    Mode_Review,
} STUDY_SCREEN_MODE;

@interface StudyWordViewController : UIViewController
{
    IBOutlet UIWebView *webViewWord;
    IBOutlet UIView *viewReservationForAds;
    IBOutlet UIView *viewButtonsPanel;
    IBOutlet UIView *viewShowAnswer;
    
    IBOutlet UIButton *btnAgain;
    IBOutlet UIButton *btnHard;
    IBOutlet UIButton *btnNorm;
    IBOutlet UIButton *btnEasy;
    
    IBOutlet UILabel *lbNewCount;
    IBOutlet UILabel *lbAgainCount;
    IBOutlet UILabel *lbReviewCount;
}

@property (nonatomic, assign) STUDY_SCREEN_MODE studyScreenMode;
@property (nonatomic, assign) BOOL isReviewScreen;  //transfered from studiedlist
@property (nonatomic, strong) WordObject *wordObj;  //current word

@property (nonatomic, strong) NSMutableArray *nwordList;
@property (nonatomic, strong) NSMutableArray *studyAgainList;
@property (nonatomic, strong) NSMutableArray *reviewWordList;

@end

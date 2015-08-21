//
//  StudyWordViewController.h
//  LazzyBee
//
//  Created by HuKhong on 8/20/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>

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
    
}

@property (nonatomic, assign) STUDY_SCREEN_MODE screenMode;
@end

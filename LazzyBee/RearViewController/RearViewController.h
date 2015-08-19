//
//  RearViewController.h
//  MobileTV
//
//  Created by itpro on 3/4/15.
//  Copyright (c) 2015 ITPRO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RearTable_Section_Test1 = 0,
    RearTable_Section_Test2,
    RearTable_Section_Share,
    RearTable_Section_Max
} REAR_TABLEVIEW_SECTION;

typedef enum {
    Test1Section_Test1 = 0,
    Test1Section_Max
} TEST1_SECTION_ITEM;

typedef enum {
    Test2Section_Test1 = 0,
    Test2Section_Max
} TEST2_SECTION_ITEM;

typedef enum {
    ShareSection_ShareFB = 0,
    ShareSection_Max
} SHARE_SECTION_ITEM;


@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UILabel *lbName;
//    IBOutlet UILabel *lbEmail;
    IBOutlet UIImageView *imgAvatar;
    IBOutlet UIImageView *imgCover;
//    IBOutlet UIButton *btnLogout;
//    IBOutlet UIButton *btnLogin;
    
}
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;

@end
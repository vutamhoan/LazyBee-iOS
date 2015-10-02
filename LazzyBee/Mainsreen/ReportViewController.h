//
//  ReportViewController.h
//  LazzyBee
//
//  Created by HuKhong on 10/2/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordObject.h"

@interface ReportViewController : UIViewController
{
    IBOutlet UIView *viewContainer;

    IBOutlet UITextField *txtMeaning;
    IBOutlet UITextView *txtComment;
    
}

@property (nonatomic, strong) WordObject *wordObj;
@end

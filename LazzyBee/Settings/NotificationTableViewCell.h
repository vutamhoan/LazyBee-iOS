//
//  NotificationTableViewCell.h
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NotificationCellDelegate <NSObject>

@optional // Delegate protocols

- (void)switchControlChangeValue:(id)sender;

@end

@interface NotificationTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UISwitch *swControl;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property(nonatomic, readwrite) id <NotificationCellDelegate> delegate;
@end

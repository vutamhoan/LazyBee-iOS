//
//  NotificationTableViewCell.m
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "Common.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reminderChangeValue:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    NSNumber *reminderNumberObj = nil;
    
    if (sw.isOn) {
        reminderNumberObj = [NSNumber numberWithBool:YES];
    } else {
        reminderNumberObj = [NSNumber numberWithBool:NO];
    }
    
    [[Common sharedCommon] saveDataToUserDefaultStandard:reminderNumberObj withKey:@"ReminderOnOff"];
}

@end

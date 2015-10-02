//
//  SettingsViewController.m
//  LazzyBee
//
//  Created by HuKhong on 3/3/15.
//  Copyright (c) 2014 ITPRO. All rights reserved.
//

#import "SettingsViewController.h"
#import "CommonSqlite.h"
#import "AboutViewController.h"
#import "Common.h"
#import "AppDelegate.h"
#import "SpeedTableViewCell.h"
#import "DailyTargetViewController.h"
#import "NotificationTableViewCell.h"
#import "TimerViewController.h"
#import "LevelPickerViewController.h"

@interface SettingsViewController ()
{
    TimerViewController *timerView;
    LevelPickerViewController *levelView;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
#endif

    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setTitle:@"Settings"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSettingsScreen)
                                                 name:@"updateSettingsScreen"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateSettingsScreen {
    [settingsTableView reloadData];
}

#pragma mark data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SettingsTableViewSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
    if (section == SettingsTableViewSectionAbout) {
        return AboutSectionMax;
        
    } else if (section == SettingsTableViewSectionSpeech) {
        return SpeechSectionMax;
        
    } else if (section == SettingsTableViewSectionDailyTarget) {
        return DailyTargetSectionMax;
        
    } else if (section == SettingsTableViewSectionAutoPlay) {
        return AutoPlayMax;
        
    } else if (section == SettingsTableViewSectionNotification) {
        return NotificationSectionMax;
        
    } else if (section == SettingsTableViewSectionReset) {
        return ResetSectionMax;
    }
    
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SettingsTableViewSectionSpeech) {
        return @"Speaking Speed";
        
    } else if (section == SettingsTableViewSectionNotification) {
        return @"Reminder";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalCellIdentifier = @"NormalCell";
    
    switch (indexPath.section) {
        case SettingsTableViewSectionAbout:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.textLabel.text = @"About";
                
                return cell;
            }
            break;
        
        case SettingsTableViewSectionSpeech:
            switch (indexPath.row) {
                case SpeakingSpeed:
                    {
                        NSString *speedCellIdentifier = @"SpeedCellIdentifier";
                        
                        SpeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:speedCellIdentifier];
                        if (cell == nil) {
                            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SpeedTableViewCell" owner:nil options:nil];
                            cell = [nib objectAtIndex:0];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                        
                        return cell;
                    }
                    break;
                    
                default:
                    break;
            }
            break;
        
        case SettingsTableViewSectionDailyTarget:
            switch (indexPath.row) {
                case DailyTarget:
                    {
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                        
                        cell.textLabel.textColor = [UIColor blackColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        NSNumber *targetNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"DailyTarget"];
                        
                        if (targetNumberObj) {
                            cell.textLabel.textAlignment = NSTextAlignmentCenter;
                            cell.textLabel.text = [NSString stringWithFormat:@"Daily target: %ld words", [targetNumberObj integerValue]];
                        }
                        
                        return cell;
                    }
                    break;
                    
                case LowestLevel:
                    {
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                        
                        cell.textLabel.textColor = [UIColor blackColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        NSString *level = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"LowestLevel"];
                        
                        if (level) {
                            cell.textLabel.textAlignment = NSTextAlignmentCenter;
                            cell.textLabel.text = [NSString stringWithFormat:@"Level: %@", level];
                        }
                        
                        return cell;
                    }
                    break;
                    
                default:
                    break;
            }
            
        case SettingsTableViewSectionAutoPlay:
            {
                NSString *autoPlayCellIdentifier = @"AutoPlayCell";
                
                NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:autoPlayCellIdentifier];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                cell.tag = SettingsTableViewSectionAutoPlay;
                cell.delegate = (id)self;
                
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.lbTitle.text = @"Autoplay sound";
                
                NSNumber *autoPlayFlag = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"AutoPlay"];
                
                cell.swControl.on = [autoPlayFlag boolValue];
                
                return cell;
            }
            break;
           
        case SettingsTableViewSectionNotification:
            switch (indexPath.row) {
                case NotificationOnOff:
                {
                    NSString *notificationOnOffCell = @"NotificationOnOffCell";
                    
                    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationOnOffCell];
                    if (cell == nil) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:nil options:nil];
                        cell = [nib objectAtIndex:0];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    
                    cell.tag = SettingsTableViewSectionNotification;
                    cell.delegate = (id)self;
                    
                    cell.lbTitle.text = @"Turn on reminder";
                    
                    NSNumber *reminderFlag = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"ReminderOnOff"];
                    
                    cell.swControl.on = [reminderFlag boolValue];
                    
                    return cell;
                }
                break;
                    
                case NotificationTime:
                    {
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                        
                        cell.textLabel.textColor = [UIColor blackColor];
                        cell.textLabel.font = [UIFont systemFontOfSize:16];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        NSString *time = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"RemindTime"];
                        
                        if (time) {
                            cell.textLabel.textAlignment = NSTextAlignmentCenter;
                            cell.textLabel.text = [NSString stringWithFormat:@"Time to remind: %@", time];
                        }
                        
                        return cell;
                    }
                    break;
                default:
                    break;
            }
            break;
            
            case SettingsTableViewSectionReset:
                switch (indexPath.row) {
                    case UpdateCurrentDate:
                        {
                            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                                cell.accessoryType = UITableViewCellAccessoryNone;
                            }
                            
                            cell.textLabel.textAlignment = NSTextAlignmentLeft;
                            cell.textLabel.textColor = [UIColor blackColor];
                            cell.textLabel.font = [UIFont systemFontOfSize:16];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            
                            cell.textLabel.text = @"Update current date";
                            
                            return cell;
                        }
                        break;
                        
                    case UpdateDatabase:
                        {
                            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
                                cell.accessoryType = UITableViewCellAccessoryNone;
                            }
                            
                            cell.textLabel.textAlignment = NSTextAlignmentLeft;
                            cell.textLabel.textColor = [UIColor blackColor];
                            cell.textLabel.font = [UIFont systemFontOfSize:16];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            
                            cell.textLabel.text = @"Update database";
                            
                            return cell;
                        }
                        break;
                    default:
                        break;
                }
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SettingsTableViewSectionAbout:
            {
                AboutViewController *aboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                
                [self.navigationController pushViewController:aboutView animated:YES];
            }
            break;
            
        case SettingsTableViewSectionSpeech:
            switch (indexPath.row) {
                case SpeakingSpeed:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case SettingsTableViewSectionDailyTarget:
            switch (indexPath.row) {
                case DailyTarget:
                    {
                        DailyTargetViewController *dailyTargetView = [[DailyTargetViewController alloc] initWithNibName:@"DailyTargetViewController" bundle:nil];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dailyTargetView];
                        
                        [nav setModalPresentationStyle:UIModalPresentationFormSheet];
                        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                        
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                    break;
                    
                case LowestLevel:
                    {
                        [self showLevelPicker];
                    }
                    break;
                default:
                    break;
            }
            break;
            
            
        case SettingsTableViewSectionNotification:
            switch (indexPath.row) {
                case NotificationOnOff:
                    break;
                    
                case NotificationTime:
                    [self showTimePicker];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case SettingsTableViewSectionReset:
            switch (indexPath.row) {
                case UpdateCurrentDate:
                {
                    [[CommonSqlite sharedCommonSqlite] resetDateOfPickedWordList];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Date is updated." delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = 1;
                    
                    [alert show];
                }
                    break;
                    
                case UpdateDatabase:
                {
                    
                }
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

//NotificationCellDelegate delegate
- (void)switchControlChangeValue:(id)sender {
    NotificationTableViewCell *cell = (NotificationTableViewCell *)sender;
    UISwitch *sw = cell.swControl;
    
    if (cell.tag == SettingsTableViewSectionAutoPlay) {
        NSNumber *autoPlayNumberObj = nil;
        
        if (sw.isOn) {
            autoPlayNumberObj = [NSNumber numberWithBool:YES];
        } else {
            autoPlayNumberObj = [NSNumber numberWithBool:NO];
        }
        
        [[Common sharedCommon] saveDataToUserDefaultStandard:autoPlayNumberObj withKey:@"AutoPlay"];
        
    } else if (cell.tag == SettingsTableViewSectionNotification) {
        
        NSNumber *reminderNumberObj = nil;
        
        if (sw.isOn) {
            reminderNumberObj = [NSNumber numberWithBool:YES];
        } else {
            reminderNumberObj = [NSNumber numberWithBool:NO];
        }
        
        [[Common sharedCommon] saveDataToUserDefaultStandard:reminderNumberObj withKey:@"ReminderOnOff"];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex != 0) {
        }
        
    }
    
    return;
}

- (void)showTimePicker {
    timerView = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];

    timerView.view.alpha = 0;
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    [timerView.view setFrame:rect];
    
    [self.view addSubview:timerView.view];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        timerView.view.alpha = 1;
    }];
}

- (void)showLevelPicker {
    levelView = [[LevelPickerViewController alloc] initWithNibName:@"LevelPickerViewController" bundle:nil];
    
    levelView.view.alpha = 0;
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    [levelView.view setFrame:rect];
    
    [self.view addSubview:levelView.view];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        levelView.view.alpha = 1;
    }];
}
@end

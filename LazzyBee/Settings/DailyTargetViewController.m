//
//  DailyTargetViewController.m
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "DailyTargetViewController.h"
#import "Common.h"

@interface DailyTargetViewController ()
{
    NSIndexPath *selectedIndexPath;
}
@end

@implementation DailyTargetViewController

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
    
    NSNumber *targetNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"DailyTarget"];
    
    if (targetNumberObj) {
        selectedIndexPath = [NSIndexPath indexPathForRow:([targetNumberObj integerValue]/5 - 1) inSection:0];
    }
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:(id)self  action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:(id)self  action:@selector(doneButtonClick)];
    self.navigationItem.rightBarButtonItem = btnDone;
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

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonClick {
    NSInteger target = (selectedIndexPath.row + 1) * 5;
    NSNumber *targetNumberObj = [NSNumber numberWithInteger:target];
    [[Common sharedCommon] saveDataToUserDefaultStandard:targetNumberObj withKey:@"DailyTarget"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSettingsScreen" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *dailyOptionCellIdentifier = @"DailyOptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dailyOptionCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dailyOptionCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    if (indexPath.row == selectedIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"5 words - Easy"];
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"10 words - Normal"];
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"15 words - Hard"];
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"20 words - Impossible"];
    }
    
    return cell;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != selectedIndexPath.row) {
        selectedIndexPath = indexPath;
        
        [tableView reloadData];
    }
}
@end

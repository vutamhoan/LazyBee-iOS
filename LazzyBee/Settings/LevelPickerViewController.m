//
//  LevelPickerViewController.m
//  LazzyBee
//
//  Created by HuKhong on 10/2/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "LevelPickerViewController.h"
#import "Common.h"

#define MAX_LEVEL 6

@interface LevelPickerViewController ()

@end

@implementation LevelPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *level = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:KEY_LOWEST_LEVEL];
    
    if (!level) {
        level = @"2";
        [[Common sharedCommon] saveDataToUserDefaultStandard:level withKey:KEY_LOWEST_LEVEL];
    }
    
    [levelPicker selectRow:[level integerValue] - 1 inComponent:0 animated:YES];
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

- (IBAction)tapGestureHandle:(id)sender {
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (IBAction)btnDoneClick:(id)sender {
    NSString *level = [NSString stringWithFormat:@"%ld", [levelPicker selectedRowInComponent:0] + 1];
    [[Common sharedCommon] saveDataToUserDefaultStandard:level withKey:KEY_LOWEST_LEVEL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSettingsScreen" object:nil];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX_LEVEL;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", row + 1];
}

#pragma mark picker delegate
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
/*    NSString *level = [NSString stringWithFormat:@"%ld", [levelPicker selectedRowInComponent:0] + 1];
    [[Common sharedCommon] saveDataToUserDefaultStandard:level withKey:KEY_LOWEST_LEVEL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSettingsScreen" object:nil];
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
 */
}
@end

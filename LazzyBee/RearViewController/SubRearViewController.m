//
//  SubRearViewController.m
//  LazzyBee
//
//  Created by HuKhong on 3/10/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import "SubRearViewController.h"
#import "RearTableViewCell.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface SubRearViewController ()
{
    NSIndexPath *presentedCell;
}
@end

@implementation SubRearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

#pragma marl - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subRearCellIdentifier = @"SubRearTableViewCell"
    ;
    
    RearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subRearCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RearTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSString *text = @"";

    cell.lbTitle.text = text;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    if ([indexPath isEqual:presentedCell]) {
        [self.sidePanelController showCenterPanelAnimated:YES];
        return;
    }
}
@end

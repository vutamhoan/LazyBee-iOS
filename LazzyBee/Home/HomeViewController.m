//
//  HomeViewController.m
//  LazzyBee
//
//  Created by nobody on 8/3/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "HomeViewController.h"
#import "StudyWordViewController.h"
#import "StudiedListViewController.h"
#import "CommonDefine.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    [self setTitle:@"LazzyBee"];

//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar)];
//    
//    self.navigationItem.rightBarButtonItem = searchButton;
    
    [viewInformation setBackgroundColor:COMMON_COLOR];
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

- (void)showSearchBar {
    
}

#pragma mark buttons handle
- (IBAction)btnStudyClick:(id)sender {
    StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
    
    [self.navigationController pushViewController:studyViewController animated:YES];
}

- (IBAction)btnStudiedListClick:(id)sender {
    StudiedListViewController *studiedListViewController = [[StudiedListViewController alloc] initWithNibName:@"StudiedListViewController" bundle:nil];
    studiedListViewController.screenType = List_StudiedList;
    
    [self.navigationController pushViewController:studiedListViewController animated:YES];
}

@end

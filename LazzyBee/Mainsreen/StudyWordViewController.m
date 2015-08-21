//
//  StudyWordViewController.m
//  LazzyBee
//
//  Created by HuKhong on 8/20/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "StudyWordViewController.h"
#import "CommonSqlite.h"
#import "HTMLHelper.h"

@interface StudyWordViewController ()

@end

@implementation StudyWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionsPanel)];
    
    self.navigationItem.rightBarButtonItems = @[actionButton, searchButton];
    
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGRect buttonsPanelRect = viewButtonsPanel.frame;
    
    //move buttons panel from the screen
    buttonsPanelRect.origin.y = mainRect.size.height;
    [viewButtonsPanel setFrame:buttonsPanelRect];
    
    //display question
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForQuestion:@"To check for browser support simply look for something"];
    
    [webViewWord loadHTMLString:htmlString baseURL:baseURL];
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

- (void)showActionsPanel {
    
}


@end

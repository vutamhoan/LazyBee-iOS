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
@synthesize screenMode = _screenMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar)];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionsPanel)];
    
    self.navigationItem.rightBarButtonItems = @[actionButton, searchButton];
    
    NSString *title = @"Study";
    if (_screenMode == Mode_New_Word) {
        title = @"New Word";
    } else if (_screenMode == Mode_Study) {
        title = @"Study";
    } else if (_screenMode == Mode_Review) {
        title = @"Review";
    }
    
    [self setTitle:title];
    
    //move buttons panel from the screen
    [self showHideButtonsPanel:NO];
    
    [self getAWordAndDisplayQuestion];
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

- (void)showHideButtonsPanel:(BOOL)show {
    [UIView animateWithDuration:0.3 animations:^(void) {
        CGRect mainRect = [UIScreen mainScreen].bounds;
        CGRect showAnswerrect = viewShowAnswer.frame;
        CGRect buttonsPanelRect = viewButtonsPanel.frame;
        
        if (show) {
            //overlap showAnswer panel
            buttonsPanelRect.origin.y = showAnswerrect.origin.y;
        } else {
            //move buttons panel from the screen
            buttonsPanelRect.origin.y = mainRect.size.height;
        }
        
        [viewButtonsPanel setFrame:buttonsPanelRect];
    }];
}

- (void)getAWordAndDisplayQuestion {
    //display question
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    WordObject *wordObj = [[CommonSqlite sharedCommonSqlite] getWordInformation:@"confident"];
    NSString *htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForQuestion:wordObj.question];
    
    [webViewWord loadHTMLString:htmlString baseURL:baseURL];
}

- (void)getAWordAndDisplayAnswer {
    //display question
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    WordObject *wordObj = [[CommonSqlite sharedCommonSqlite] getWordInformation:@"confident"];
    NSString *htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForAnswer:wordObj withPackage:@"common"];
    
    [webViewWord loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark buttons handle
- (IBAction)btnShowAnswerClick:(id)sender {
    [self getAWordAndDisplayAnswer];
    [self showHideButtonsPanel:YES];
}

@end

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
#import "CommonSqlite.h"

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
    
    //prepare 100 words
    [[CommonSqlite sharedCommonSqlite] prepareWordsToStudyingQueue:BUFFER_SIZE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completedDailyTarget)
                                                 name:@"completedDailyTarget"
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

- (void)showSearchBar {
    
}

#pragma mark buttons handle
- (IBAction)btnStudyClick:(id)sender {
    //check and pick new words
    [[CommonSqlite sharedCommonSqlite] pickUpRandom10WordsToStudyingQueue:PICKED_WORDS_QUEUE_SIZE];
    
    StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
    
    [self.navigationController pushViewController:studyViewController animated:YES];
}

- (IBAction)btnStudiedListClick:(id)sender {
    StudiedListViewController *studiedListViewController = [[StudiedListViewController alloc] initWithNibName:@"StudiedListViewController" bundle:nil];
    studiedListViewController.screenType = List_StudiedList;
    
    [self.navigationController pushViewController:studiedListViewController animated:YES];
}

- (IBAction)btnMoreWordClick:(id)sender {
    NSInteger count = [[CommonSqlite sharedCommonSqlite] getCountOfPickedWord];
    
    if (count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You need to complete your current target before add more words." delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Study now", nil];
        alert.tag = 1;
        
        [alert show];
        
    } else {
        //pick more words from buffer
        [[CommonSqlite sharedCommonSqlite] pickUpRandom10WordsToStudyingQueue:PICKED_WORDS_QUEUE_SIZE];
        
        //transfer to study screen
        StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
        
        [self.navigationController pushViewController:studyViewController animated:YES];
    }
}

#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {   //add more words alert
        if (buttonIndex != 0) {
            //transfer to study screen
            StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
            
            [self.navigationController pushViewController:studyViewController animated:YES];
        }
    }
}

- (void)completedDailyTarget {
    //update screen info
    
    
    //show alert to congrat
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation" message:@"You have completed your daily target." delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 2;
    
    [alert show];
}
@end

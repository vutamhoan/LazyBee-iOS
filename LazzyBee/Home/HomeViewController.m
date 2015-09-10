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

@interface HomeViewController ()<GADInterstitialDelegate>
{
    
}

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noWordToStudyToday)
                                                 name:@"noWordToStudyToday"
                                               object:nil];
    
    //admob
    GADRequest *request = [GADRequest request];
    self.adBanner.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.adBanner.rootViewController = self;
    [self.adBanner loadRequest:request];
    [self createAndLoadInterstitial];
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
    if ([[CommonSqlite sharedCommonSqlite] getCountOfBuffer] < PICKED_WORDS_QUEUE_SIZE) {
        [[CommonSqlite sharedCommonSqlite] prepareWordsToStudyingQueue:BUFFER_SIZE];
    }
    
    [[CommonSqlite sharedCommonSqlite] pickUpRandom10WordsToStudyingQueue:PICKED_WORDS_QUEUE_SIZE withForceFlag:NO];
    
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
        if ([[CommonSqlite sharedCommonSqlite] getCountOfBuffer] < PICKED_WORDS_QUEUE_SIZE) {
            [[CommonSqlite sharedCommonSqlite] prepareWordsToStudyingQueue:BUFFER_SIZE];
        }
        
        [[CommonSqlite sharedCommonSqlite] pickUpRandom10WordsToStudyingQueue:PICKED_WORDS_QUEUE_SIZE withForceFlag:YES];
        
        //transfer to study screen
        StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
        
        [self.navigationController pushViewController:studyViewController animated:YES];
        
        //show ad full screen
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        }
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

- (void)noWordToStudyToday {
    //show alert to congrat
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There is no more word to study today. Click \"More Words\" if you really want to study more." delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 3;
    
    [alert show];
}

#pragma mark admob
- (void)createAndLoadInterstitial {
        self.interstitial =
        [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
        self.interstitial.delegate = self;
    
        GADRequest *request = [GADRequest request];
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADInterstitial automatically returns test ads when running on a
        // simulator.
        request.testDevices = @[
                                @"8466af21f9717b97f0ba30fa23e53e1ba94d3422"
                                ];
        [self.interstitial loadRequest:request];
}

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
}
@end

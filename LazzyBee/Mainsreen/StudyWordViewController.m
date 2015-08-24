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
@synthesize studyScreenMode = _studyScreenMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_isReviewScreen == YES) {
        if (_wordObj) {
            [self displayAnswer:_wordObj];
            
            //hide buttons panel and "show answer" panel, expand webview full screen
            viewButtonsPanel.hidden = YES;
            viewShowAnswer.hidden = YES;
            
            CGRect mainRect = [UIScreen mainScreen].bounds;
            CGRect adsViewRect = viewReservationForAds.frame;
            CGRect webViewRect = webViewWord.frame;
            
            webViewRect.origin.y = 0;
            webViewRect.size.height = mainRect.size.height - adsViewRect.size.height;
            [webViewWord setFrame:webViewRect];
            
            adsViewRect.origin.y = webViewRect.size.height;
            [viewReservationForAds setFrame:adsViewRect];
            
            //show word
            [self displayAnswer:_wordObj];
        }
        
    } else {
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar)];
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionsPanel)];
        
        self.navigationItem.rightBarButtonItems = @[actionButton, searchButton];
        
        NSString *title = @"Study";
        if (_studyScreenMode == Mode_New_Word) {
            title = @"New Word";
        } else if (_studyScreenMode == Mode_Study) {
            title = @"Study";
        } else if (_studyScreenMode == Mode_Review) {
            title = @"Review";
        }
        
        [self setTitle:title];
        
        //move buttons panel from the screen
        [self showHideButtonsPanel:NO];
        
        //init words list
        
    }
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

- (void)setStudyScreenMode:(STUDY_SCREEN_MODE)studyScreenMode {
    _studyScreenMode = studyScreenMode;
    
    NSString *title = @"Study";
    if (_studyScreenMode == Mode_New_Word) {
        title = @"New Word";
    } else if (_studyScreenMode == Mode_Study) {
        title = @"Study";
    } else if (_studyScreenMode == Mode_Review) {
        title = @"Review";
    }
    
    [self setTitle:title];
}

- (void)showSearchBar {
    
}

- (void)showActionsPanel {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Ignore this word" otherButtonTitles: nil];
    
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
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

- (void)displayQuestion:(WordObject *)wordObj {
    //display question
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    wordObj = [[CommonSqlite sharedCommonSqlite] getWordInformation:@"confident"];
    NSString *htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForQuestion:wordObj.question];
    
    [webViewWord loadHTMLString:htmlString baseURL:baseURL];
}

- (void)displayAnswer:(WordObject *)wordObj {
    //display question
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    wordObj = [[CommonSqlite sharedCommonSqlite] getWordInformation:@"confident"];
    NSString *htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForAnswer:wordObj withPackage:@"common"];
    
    [webViewWord loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark buttons handle
- (IBAction)btnShowAnswerClick:(id)sender {
    [self showHideButtonsPanel:YES];
}

#pragma mark actions sheet handle
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"ignore this word");
            //remove this word from list
            
            //update queue value in DB
            _wordObj.queue = @"-2";
            [[CommonSqlite sharedCommonSqlite] updateWord:_wordObj];
            
        } else if (buttonIndex == 3) {
            NSLog(@"Cancel");
        }
    }
    
}

@end

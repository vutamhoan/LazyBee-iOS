//
//  ReportViewController.m
//  LazzyBee
//
//  Created by HuKhong on 10/2/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "ReportViewController.h"
#import "CommonDefine.h"
#import "CommonSqlite.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

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
    
    [viewContainer setBackgroundColor:GREEN_COLOR];
    
    //parse the answer to dictionary object
    NSData *data = [_wordObj.answers dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictAnswer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *strPronounciation = [dictAnswer valueForKey:@"pronoun"];
    
    //A word may has many meanings corresponding to many fields (common, it, economic...)
    //The meaning of each field is considered as a package
    NSDictionary *dictPackages = [dictAnswer valueForKey:@"packages"];
    NSDictionary *dictSinglePackage = [dictPackages valueForKey:@"common"];
    //"common":{"meaning":"", "explain":"<p>The edge of something is the part of it that is farthest from the center.</p>", "example":"<p>He ran to the edge of the cliff.</p>"}}
    
    NSString *strMeaning = [dictSinglePackage valueForKey:@"meaning"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strMeaning dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    txtMeaning.attributedText = attributedString;
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:(id)self  action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnSubmit = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:(id)self  action:@selector(doneButtonClick)];
    self.navigationItem.rightBarButtonItem = btnSubmit;
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
    //parse the answer to dictionary object
/*    NSData *data = [_wordObj.answers dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictAnswer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSDictionary *dictPackages = [dictAnswer valueForKey:@"packages"];
    NSDictionary *dictSinglePackage = [dictPackages valueForKey:@"common"];

    [dictSinglePackage setValue:txtMeaning.text forKey:@"meaning"];
    
    data = [NSJSONSerialization dataWithJSONObject:dictAnswer options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _wordObj.answers = myString;
    
    [[CommonSqlite sharedCommonSqlite] updateWord:_wordObj];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStudyScreen" object:_wordObj];
*/
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtComment resignFirstResponder];
    [txtMeaning resignFirstResponder];
}

#pragma mark text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:txtMeaning]) {
        [txtComment becomeFirstResponder];
        
    } else if ([textField isEqual:txtComment]) {
        [txtComment resignFirstResponder];
    }
    
    return NO;
}
@end

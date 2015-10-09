//
//  DictDetailContainerViewController.m
//  LazzyBee
//
//  Created by HuKhong on 10/8/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "DictDetailContainerViewController.h"
#import "DictDetailViewController.h"
#import "MHTabBarController.h"
#import "TagManagerHelper.h"

@interface DictDetailContainerViewController ()
{
    MHTabBarController *tabViewController;
}
@end

@implementation DictDetailContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [TagManagerHelper pushOpenScreenEvent:@"iDictionaryViewWordScreen"];
    
    [self setTitle:_wordObj.question];
    
    DictDetailViewController *vnViewController = [[DictDetailViewController alloc] initWithNibName:@"DictDetailViewController" bundle:nil];
    vnViewController.dictType = DictVietnam;
    vnViewController.wordObj = _wordObj;
    vnViewController.title = @"VN";
    
    DictDetailViewController *enViewController = [[DictDetailViewController alloc] initWithNibName:@"DictDetailViewController" bundle:nil];
    enViewController.dictType = DictEnglish;
    enViewController.wordObj = _wordObj;
    enViewController.title = @"EN";
    
    NSArray *viewControllers = @[enViewController, vnViewController];
    
    tabViewController = [[MHTabBarController alloc] init];
    
    tabViewController.delegate = (id)self;
    tabViewController.viewControllers = viewControllers;
    [tabViewController.view setFrame:self.view.frame];
    
    tabViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                                UIViewAutoresizingFlexibleHeight |
                                                UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleBottomMargin |
                                                UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:tabViewController.view];
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

@end

//
//  StudiedListViewController.m
//  LazzyBee
//
//  Created by HuKhong on 8/21/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "StudiedListViewController.h"
#import "StudiedTableViewCell.h"
#import "CommonSqlite.h"
#import "Common.h"
#import "StudyWordViewController.h"

@interface StudiedListViewController ()
{
    NSMutableDictionary *levelsDictionary;
    NSArray *keyArr;
}
@end

@implementation StudiedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Studied list"];
    
    levelsDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *wordList = nil;

    if (_screenType == List_StudiedList) {
        wordList = [[CommonSqlite sharedCommonSqlite] getStudiedList];
        
    } else if (_screenType == List_SearchHint) {
        wordList = [[CommonSqlite sharedCommonSqlite] getSearchHintList:_searchText];
        
    } else if (_screenType == List_SearchResult) {
        wordList = [[CommonSqlite sharedCommonSqlite] getSearchResultList:_searchText];
    }

    //group by level
    for (WordObject *wordObj in wordList) {
        NSMutableArray *arr = [levelsDictionary objectForKey:wordObj.level];
        
        if (arr == nil) {
            arr = [[NSMutableArray alloc] init];
        }
        [arr addObject:wordObj];
        
        [levelsDictionary setObject:arr forKey:wordObj.level];
    }
    
    keyArr = [levelsDictionary allKeys];
    keyArr = [keyArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    lbHeaderInfo.text = [NSString stringWithFormat:@"Total: %lu", (unsigned long)[wordList count]];
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

#pragma mark data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[levelsDictionary allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = [NSString stringWithFormat:@"Level %@", [keyArr objectAtIndex:section]];
    
    return headerTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor whiteColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentLeft;
    
    header.backgroundView.backgroundColor = [UIColor darkGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    NSString *key = [keyArr objectAtIndex:section];
    
    return [[levelsDictionary objectForKey:key] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *studiedCellIdentifier = @"StudiedTableViewCell";
    
    StudiedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studiedCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudiedTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString *key = [keyArr objectAtIndex:indexPath.section];
    
    NSArray *arrWords = [levelsDictionary objectForKey:key];
    WordObject *wordObj = [arrWords objectAtIndex:indexPath.row];
    
    //parse the answer to dictionary object
    NSData *data = [wordObj.answers dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictAnswer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *strPronounciation = [dictAnswer valueForKey:@"pronoun"];
    
    //A word may has many meanings corresponding to many fields (common, it, economic...)
    //The meaning of each field is considered as a package
    NSDictionary *dictPackages = [dictAnswer valueForKey:@"packages"];
    NSDictionary *dictSinglePackage = [dictPackages valueForKey:@"common"];
    //"common":{"meaning":"", "explain":"<p>The edge of something is the part of it that is farthest from the center.</p>", "example":"<p>He ran to the edge of the cliff.</p>"}}
    
    NSString *strMeaning = [dictSinglePackage valueForKey:@"meaning"];
    strMeaning = [[Common sharedCommon] stringByRemovingHTMLTag:strMeaning];
    
    cell.lbWord.text = wordObj.question;
    cell.lbPronounce.text = strPronounciation;
    cell.lbMeaning.text = strMeaning;
    
    return cell;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [keyArr objectAtIndex:indexPath.section];
    NSArray *arrWords = [levelsDictionary objectForKey:key];
    WordObject *wordObj = [arrWords objectAtIndex:indexPath.row];
    
    if (_screenType == List_SearchHint) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectRowFromSearch" object:wordObj];
        
    } else {
        StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
        studyViewController.isReviewScreen = YES;
        studyViewController.wordObj = wordObj;
        
        [self.navigationController pushViewController:studyViewController animated:YES];
    }

}
@end

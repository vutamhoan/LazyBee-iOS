//
//  CommonDefine.h
//  MobileTV
//
//  Created by itpro on 4/19/15.
//  Copyright (c) 2015 ITPRO. All rights reserved.
//

#ifndef MobileTV_CommonDefine_h
#define MobileTV_CommonDefine_h
#import <Foundation/Foundation.h>

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

//#define COMMON_COLOR [UIColor colorWithRed:243/255.f green:111/255.f blue:33/255.f alpha:1]
#define COMMON_COLOR [UIColor colorWithRed:100/255.f green:142/255.f blue:45/255.f alpha:1]

#define SERVER_LINK  @"http://192.168.0.202/vod/"
#define REQUEST_HOME @"act=home&limit=%d"    //act=home&limit=xxx
#define REQUEST_MAIN_CATEGORY @"act=home&catid=%@&limit=%d"    //act=home&catid=xxx&limit=xxx
#define REQUEST_SUB_CATEGORY @"act=movie-list&catid=%@&page=%d&limit=%d"    //act=movie-list&catid=xxx&search=xxx&orderby=xxx&ordertype=xxxpage=xxxlimit=xxx
#define REQUEST_MOVIE_DETAIL @"act=movie-detail&id=%@"    //act=movie-detail&id=xxx
#define REQUEST_MOVIE_LINK @"act=movie-link&id=%@"    //act=movie-link&id=xxx
#define REQUEST_SEARCH @"act=movie-list&search=%@&catid=%@&page=%d&limit=%d"    //act=movie-list&catid=xxx&search=xxx&orderby=xxx&ordertype=xxxpage=xxxlimit=xxx
#define REQUEST_CHECK_USER_STATUS @"act=user-status"    //act=user-status
#define REQUEST_COMMENT_LIST @"act=movie-commentlist&id=%@&page=%d&limit=%d"    //act=movie-commentlist&id=xxx&orderby=xxx&ordertype=xxxpage=xxxlimit=xxx
#define REQUEST_LIKE @"act=movie-favorite&id=%@&favorite=%@"    //act=movie-favorite&id=xxx&favorite=y
#define REQUEST_USER_FAVOURITE_LIST @"act=user-favoritelist"    //act=user-favoritelist
#define REQUEST_SEND_COMMENT @"act=movie-comment&id=%@"    //act=movie-comment&id=xxx
#define REQUEST_UPDATE_PROFILE @"act=user-profileupdate&fullname=%@&birthday=%@"    //act=user-profileupdate&fullname=x&birthday=y
#define REQUEST_ABOUT_CONTENT @"act=about"
#define REQUEST_CHECKVERSION @"act=check-update"

#define SHORT_CODE @"999999"

#define CELL_WIDTH 156
#define CELL_HEIGHT 115
#define COLLCECTIONVIEW_MAX_CELL_IN_SECTION 4
#define COLLCECTIONVIEW_ITEM_LIMIT 20
#define COLLCECTIONVIEW_NUM_ITEM_IN_ROW 2

#define COLLCECTIONVIEW_HEADER_HEIGHT 35
#define COLLCECTIONVIEW_CELL_OFFSET 3
#define COLLCECTIONVIEW_BOTTOM_OFFSET 0

#define INFORMATION_VIEW_MINIMUM_WIDTH 5
#define INFORMATION_VIEW_MINIMUM_HEIGHT 5

#define CELL_WIDTH_IP6 183
#define CELL_HEIGHT_IP6 125
#define COLLCECTIONVIEW_HEADER_HEIGHT_IP6 35

#define CELL_WIDTH_IP6_PLUS 202
#define CELL_HEIGHT_IP6_PLUS 130
#define COLLCECTIONVIEW_HEADER_HEIGHT_IP6_PLUS 35
#define COLLCECTIONVIEW_MAX_CELL_IN_SECTION_IP6 6

#define CELL_WIDTH_IPAD 250
#define CELL_HEIGHT_IPAD 150
#define COLLCECTIONVIEW_HEADER_HEIGHT_IPAD 40
#define COLLCECTIONVIEW_MAX_CELL_IN_SECTION_IPAD 6
#define COLLCECTIONVIEW_NUM_ITEM_IN_ROW_IPAD 3

@interface CommonLink : NSObject

@end

#endif

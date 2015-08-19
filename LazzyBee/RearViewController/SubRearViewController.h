//
//  SubRearViewController.h
//  MobileTV
//
//  Created by itpro on 3/10/15.
//  Copyright (c) 2015 ITPRO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TableLaosSubType = 0,
    TableForeignSubType,
    TableOtherVoiceSubType,
    TableSubTypeMax
} TABLE_SUBTYPE;

typedef enum {
    LaosSubTypeString = 0,
    LaosSubTypeBana,
    LaosSubTypeTraditional,
    LaosSubTypeMax
} LAOS_SUBTYPE;

typedef enum {
    ForeignSubTypeInter = 0,
    ForeignSubTypeThaiString,
    ForeignSubTypeThaiLoukThoung,
    ForeignSubTypeVietNam,
    ForeignSubTypeKorea,
    ForeignSubTypeChinese,
    ForeignSubTypeAsia,
    ForeignSubTypeMax
} FOREIGN_SUBTYPE;

typedef enum {
    OtherVoiceFunny = 0,
    OtherVoiceLove,
    OtherVoicePoem,
    OtherVoiceEffect,
    OtherVoiceMax
} OTHERVOICE_SUBTYPE;

@interface SubRearViewController : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *subRearTableView;
@property (assign, nonatomic) TABLE_SUBTYPE tableType;
@end

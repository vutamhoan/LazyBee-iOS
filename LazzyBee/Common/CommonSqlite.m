//
//  CommonSqlite.m
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import "CommonSqlite.h"
#import "UIKit/UIKit.h"
#import "sqlite3.h"
#import "CommonDefine.h"
// Singleton
static CommonSqlite* sharedCommonSqlite = nil;

@implementation CommonSqlite


//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
+ (CommonSqlite*) sharedCommonSqlite {
    // lazy instantiation
    if (sharedCommonSqlite == nil) {
        sharedCommonSqlite = [[CommonSqlite alloc] init];
    }
    return sharedCommonSqlite;
}


//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
    }
    return self;
}

- (WordObject *)getWordInformation:(NSString *)word {
    NSString *strQuery = [NSString stringWithFormat: @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" WHERE question = '%@'", word];
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return [resArr objectAtIndex:0];
}

- (NSArray *)getStudiedList {
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue >= 1 ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getNewWordsList {
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getStudyAgainList {
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue = 1 ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getReviewList {
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue = 2 ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

//selected fields in the query string must be ordered as: id, question, answers, subcats, status, package, level
- (NSArray *)getWordByQueryString:(NSString *)strQuery {
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];
    NSURL *storeURL = [NSURL URLWithString:dbPath];
    
    const char *dbFilePathUTF8 = [[storeURL path] UTF8String];
    sqlite3 *db;
    int dbrc; //database return code
    dbrc = sqlite3_open(dbFilePathUTF8, &db);
    
    if (dbrc) {
        return nil;
    }
    sqlite3_stmt *dbps;

    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        WordObject *wordObj = [[WordObject alloc] init];
        
        if (sqlite3_column_text(dbps, 0)) {
            wordObj.wordid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
        }
        
        if (sqlite3_column_text(dbps, 1)) {
            wordObj.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 1)];
        }
        
        if (sqlite3_column_text(dbps, 2)) {
            wordObj.answers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 2)];
        }
        
        if (sqlite3_column_text(dbps, 3)) {
            wordObj.subcats = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 3)];
        }
        
        if (sqlite3_column_text(dbps, 4)) {
            wordObj.status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 4)];
        }
        
        if (sqlite3_column_text(dbps, 5)) {
            wordObj.package = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 5)];
        }
        
        if (sqlite3_column_text(dbps, 6)) {
            wordObj.level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 6)];
        }
        
        [resArr addObject:wordObj];
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);
    
    return resArr;
}

- (void)updateWord:(WordObject *)wordObj {
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];
    NSURL *storeURL = [NSURL URLWithString:dbPath];
    
    const char *dbFilePathUTF8 = [[storeURL path] UTF8String];
    sqlite3 *db;
    int dbrc; //database return code
    dbrc = sqlite3_open(dbFilePathUTF8, &db);
    
    if (dbrc) {
        return;
    }
    sqlite3_stmt *dbps;
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE \"vocabulary\" SET queue = %d where question = \'%@\'", [wordObj.queue intValue], wordObj.question];
    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    if(SQLITE_DONE != sqlite3_step(dbps)) {
        NSLog(@"Error while updating. %s", sqlite3_errmsg(db));
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);

}

@end

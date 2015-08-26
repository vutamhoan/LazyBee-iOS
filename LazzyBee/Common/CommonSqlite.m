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
#import "Common.h"

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


#pragma mark vocabulary
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
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue = 1 ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getStudyAgainList {
    NSString *strQuery = @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue = 1 ORDER BY level";
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getReviewList {
    NSString *strQuery = [NSString stringWithFormat:@"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where queue = 2 AND due <= %f ORDER BY level", [self getNextDayInSec]];
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getSearchHintList:(NSString *)searchText {
    NSString *strQuery = [NSString stringWithFormat:@"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where question like '%@%%' ORDER BY level LIMIT 10", searchText];
    
    NSArray *resArr = [self getWordByQueryString:strQuery];
    
    return resArr;
}

- (NSArray *)getSearchResultList:(NSString *)searchText {
    NSString *strQuery = [NSString stringWithFormat:@"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" where question like '%@%%' ORDER BY level", searchText];
    
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

- (NSTimeInterval)getNextDayInSec {
    NSTimeInterval datetime = [[Common sharedCommon] getCurrentDateInMinisec];
    
    datetime = datetime + 24*3600;
    
    return datetime;
}

#pragma mark system
- (void)prepareWordsToStudyingQueue:(NSInteger)amount {
    //get current words list from system table
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
    
    NSString *strQuery = @"SELECT value from \"system\" WHERE key = 'buffer'";
    
    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    NSString *jsonString = @"";
    
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        if (sqlite3_column_text(dbps, 0)) {
            jsonString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
            //{"count":37,"card":["67","5","27","29","39","46","58","4","21","43","81","139","165","175","180","262","269","277","279","334","359","387","2","7","8","10","11","13","14","19","31","35","38","42","44","47","49"]}
            
        }
    }
    
    sqlite3_finalize(dbps);
    
    //parse the result to get word-id list
    NSString *strIDList = @"";
    NSArray *idListArr = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dictIDList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        idListArr = [dictIDList valueForKey:@"card"];
        strIDList = [[Common sharedCommon] stringByRemovingSpaceAndNewLineSymbol:[idListArr description]];
        
    }

    //get "amount" news word-ids from vocabulary that not included the old words
    strQuery = [NSString stringWithFormat:@"SELECT id from \"vocabulary\" WHERE id NOT IN %@ LIMIT %ld", strIDList, amount];
    charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        if (sqlite3_column_text(dbps, 0)) {
            NSString *wordID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
            
            [resArr addObject:wordID];
        }
    }

    [resArr addObjectsFromArray:idListArr];
    
    //create json to re-add to db
    NSMutableDictionary *dictNewWords = [[NSMutableDictionary alloc] init];
    [dictNewWords setObject:[[NSNumber alloc] initWithInteger:[resArr count]] forKey:@"count"];
    [dictNewWords setObject:resArr forKey:@"card"];
    
    //convert to json string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictNewWords
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //update new buffer to db
    strQuery = [NSString stringWithFormat:@"UPDATE \"system\" SET value = \'%@\' where key = 'buffer'", jsonString];
    
    charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    if(SQLITE_DONE != sqlite3_step(dbps)) {
        NSLog(@"Error while updating. %s", sqlite3_errmsg(db));
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);
}

- (void)fetchRandom10WordsToStydyingQueue:(NSInteger)amount {
    //get random 10 words from system table
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
    
    NSString *strQuery = @"SELECT value from \"system\" WHERE key = 'buffer'";
    
    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    NSString *jsonString = @"";
    
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        if (sqlite3_column_text(dbps, 0)) {
            jsonString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
            //{"count":37,"card":["67","5","27","29","39","46","58","4","21","43","81","139","165","175","180","262","269","277","279","334","359","387","2","7","8","10","11","13","14","19","31","35","38","42","44","47","49"]}
            
        }
    }
    
    sqlite3_finalize(dbps);
    
    //parse the result to get word-id list
    NSArray *idListArr = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dictIDList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        idListArr = [dictIDList valueForKey:@"card"];
    }
    
    NSUInteger randomIndex = 0;
    NSMutableArray *pickedIDArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        randomIndex = arc4random() % [idListArr count];
        
        [pickedIDArr addObject:[idListArr objectAtIndex:randomIndex]];
    }
    
    //create json to add to db
    NSMutableDictionary *dictNewWords = [[NSMutableDictionary alloc] init];
    NSString *strDate = [NSString stringWithFormat:@"%f",[[Common sharedCommon] getCurrentDateInMinisec]];
    
    [dictNewWords setObject:strDate forKey:@"date"];
    [dictNewWords setObject:pickedIDArr forKey:@"card"];
    
    //convert to json string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictNewWords
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //update new buffer to db
    strQuery = [NSString stringWithFormat:@"UPDATE \"system\" SET value = \'%@\' where key = 'pickedword'", jsonString];
    
    charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    if(SQLITE_DONE != sqlite3_step(dbps)) {
        NSLog(@"Error while updating. %s", sqlite3_errmsg(db));
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);
}

- (void)addAWordToStydyingQueue:(WordObject *)wordObj {
    //get random 10 words from system table
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
    
    NSString *strQuery = @"SELECT value from \"system\" WHERE key = 'buffer'";
    
    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    NSString *jsonString = @"";
    
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        if (sqlite3_column_text(dbps, 0)) {
            jsonString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
            //{"count":37,"card":["67","5","27","29","39","46","58","4","21","43","81","139","165","175","180","262","269","277","279","334","359","387","2","7","8","10","11","13","14","19","31","35","38","42","44","47","49"]}
            
        }
    }
    
    sqlite3_finalize(dbps);
    
    //parse the result to get word-id list
    NSMutableArray *idListArr = [[NSMutableArray alloc] init];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dictIDList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [idListArr addObjectsFromArray:[dictIDList valueForKey:@"card"]];
    }
    
    //add new word
    [idListArr addObject:wordObj.wordid];
    
    //create json to add to db
    NSMutableDictionary *dictNewWords = [[NSMutableDictionary alloc] init];
    NSString *strDate = [NSString stringWithFormat:@"%f",[[Common sharedCommon] getCurrentDateInMinisec]];
    
    [dictNewWords setObject:strDate forKey:@"date"];
    [dictNewWords setObject:idListArr forKey:@"card"];
    
    //convert to json string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictNewWords
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //update new buffer to db
    strQuery = [NSString stringWithFormat:@"UPDATE \"system\" SET value = \'%@\' where key = 'pickedword'", jsonString];
    
    charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    if(SQLITE_DONE != sqlite3_step(dbps)) {
        NSLog(@"Error while updating. %s", sqlite3_errmsg(db));
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);
}

@end

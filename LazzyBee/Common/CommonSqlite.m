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
    
    NSString *strQuery = [NSString stringWithFormat: @"SELECT id, question, answers, subcats, status, package, level FROM \"vocabulary\" WHERE question = '%@'", word];
    
    const char *charQuery = [strQuery UTF8String];
    
    sqlite3_prepare_v2(db, charQuery, -1, &dbps, NULL);
    
    WordObject *wordObj = [[WordObject alloc] init];
    while(sqlite3_step(dbps) == SQLITE_ROW) {
        
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
    }
    
    sqlite3_finalize(dbps);
    sqlite3_close(db);
    
    return wordObj;
}

/*
 -(void) deleteAirplaneOfCompany:(NSString *) companyAcronym {
	NSURL *applicationDataFolderURL = [NSURL fileURLWithPath:[[TDRCommon sharedData] applicationDataFolder]];
	NSURL *storeURL = [applicationDataFolderURL URLByAppendingPathComponent:@"CoreDataToC.sqlite"];
 
	const char *dbFilePathUTF8 = [[storeURL path] UTF8String];
	sqlite3 *db;
	int dbrc; //database return code
	dbrc = sqlite3_open(dbFilePathUTF8, &db);
	
	if (dbrc) {
 return;
	}
	sqlite3_stmt *dbps;
	
	NSString *nsDeleteAirplanes = [NSString stringWithFormat: @"DELETE FROM \"ZTSAIRPLANEDATA\" WHERE ZOPERATORCD = '%@' AND '%@' NOT IN (SELECT ZCOMPANYACRONYM FROM \"ZPUBLICATION\")",  companyAcronym, companyAcronym];
	
	const char *deleteAirplanes = [nsDeleteAirplanes UTF8String];
 
	sqlite3_prepare_v2(db, deleteAirplanes, -1, &dbps, NULL);
	sqlite3_step(dbps);
 
	sqlite3_finalize(dbps);
	sqlite3_close(db);
 }
 */

/*
 //vacuum coredata, call this function after delete records
 -(void) vacuumCoredata {
	NSURL *applicationDataFolderURL = [NSURL fileURLWithPath:[[TDRCommon sharedData] applicationDataFolder]];
	NSURL *storeURL = [applicationDataFolderURL URLByAppendingPathComponent:@""];
	
	const char *dbFilePathUTF8 = [[storeURL path] UTF8String];
	sqlite3 *db;
	int dbrc; //database return code
	dbrc = sqlite3_open(dbFilePathUTF8, &db);
	
	if (dbrc) {
 return;
	}
	sqlite3_stmt *dbps;
	
	//run vaccum command to defrag and reduce database size
	NSString *nsVaccum = @"VACUUM";
	
	dbrc = sqlite3_prepare_v2(db, [nsVaccum UTF8String], -1, &dbps, NULL);
	dbrc = sqlite3_step(dbps);
 
	sqlite3_finalize(dbps);
	sqlite3_close(db);
 }
 */


@end

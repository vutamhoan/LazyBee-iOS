//
//  CommonSqlite.h
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#ifndef LazzyBee_CommonAlert_h
#define LazzyBee_CommonAlert_h
#import <Foundation/Foundation.h>
#import "WordObject.h"

@interface CommonSqlite : NSObject

// a singleton:
+ (CommonSqlite*) sharedCommonSqlite;

- (WordObject *)getWordInformation:(NSString *)word;
- (NSArray *)getStudiedList;
- (void)updateWord:(WordObject *)wordObj;

- (NSArray *)getNewWordsList;
- (NSArray *)getStudyAgainList;
- (NSArray *)getReviewList;

- (NSArray *)getSearchHintList:(NSString *)searchText;
- (NSArray *)getSearchResultList:(NSString *)searchText;

- (void)prepareWordsToStudyingQueue:(NSInteger)amount;
- (void)pickUpRandom10WordsToStudyingQueue:(NSInteger)amount withForceFlag:(BOOL)force;
- (void)addAWordToStydyingQueue:(WordObject *)wordObj;
- (void)updatePickedWordList:(NSArray *)wordsArr;
- (NSInteger)getCountOfPickedWord;
- (NSInteger)getCountOfBuffer;
@end

#endif

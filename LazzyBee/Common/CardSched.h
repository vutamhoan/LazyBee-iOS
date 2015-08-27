//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: CardSched.java
//

#ifndef _ComBorn2goLazzybeeAlgorithmsCardSched_H_
#define _ComBorn2goLazzybeeAlgorithmsCardSched_H_

#include "J2ObjC_header.h"

@class IOSObjectArray;
@protocol ComBorn2goLazzybeeAlgorithmsCardSched_Card;

#define ComBorn2goLazzybeeAlgorithmsCardSched_REVLOG_LRN 0
#define ComBorn2goLazzybeeAlgorithmsCardSched_REVLOG_REV 1
#define ComBorn2goLazzybeeAlgorithmsCardSched_REVLOG_RELRN 2
#define ComBorn2goLazzybeeAlgorithmsCardSched_REVLOG_CRAM 3
#define ComBorn2goLazzybeeAlgorithmsCardSched_EASE_AGAIN 0
#define ComBorn2goLazzybeeAlgorithmsCardSched_EASE_HARD 1
#define ComBorn2goLazzybeeAlgorithmsCardSched_EASE_GOOD 2
#define ComBorn2goLazzybeeAlgorithmsCardSched_EASE_EASY 3
#define ComBorn2goLazzybeeAlgorithmsCardSched_SECONDS_PERDAY 86400

@interface ComBorn2goLazzybeeAlgorithmsCardSched : NSObject

#pragma mark Public

- (instancetype)init;

- (jint)_nextIntervalByDaysWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card
                                                                  withInt:(jint)ease;

- (NSString *)_nextIvlStrWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card
                                                                withInt:(jint)ease;

- (void)answerCardWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card
                                                         withInt:(jint)ease;

- (jint)nextIvlBySecondsWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card
                                                               withInt:(jint)ease;

- (IOSObjectArray *)nextIvlStrLstWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card;

#pragma mark Protected

- (jlong)_daysLateWithComBorn2goLazzybeeAlgorithmsCardSched_Card:(id<ComBorn2goLazzybeeAlgorithmsCardSched_Card>)card;

@end

J2OBJC_STATIC_INIT(ComBorn2goLazzybeeAlgorithmsCardSched)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, REVLOG_LRN, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, REVLOG_REV, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, REVLOG_RELRN, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, REVLOG_CRAM, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, EASE_AGAIN, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, EASE_HARD, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, EASE_GOOD, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, EASE_EASY, jint)

J2OBJC_STATIC_FIELD_GETTER(ComBorn2goLazzybeeAlgorithmsCardSched, SECONDS_PERDAY, jint)

FOUNDATION_EXPORT void ComBorn2goLazzybeeAlgorithmsCardSched_init(ComBorn2goLazzybeeAlgorithmsCardSched *self);

FOUNDATION_EXPORT ComBorn2goLazzybeeAlgorithmsCardSched *new_ComBorn2goLazzybeeAlgorithmsCardSched_init() NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(ComBorn2goLazzybeeAlgorithmsCardSched)

@protocol ComBorn2goLazzybeeAlgorithmsCardSched_Card < NSObject, JavaObject >

- (jint)getId;

- (void)setIdWithInt:(jint)id_;

- (NSString *)getQuestion;

- (void)setQuestionWithNSString:(NSString *)question;

- (NSString *)getAnswers;

- (void)setAnswersWithNSString:(NSString *)answers;

- (NSString *)getCategories;

- (void)setCategoriesWithNSString:(NSString *)categories;

- (NSString *)getSubcat;

- (void)setSubcatWithNSString:(NSString *)subcat;

- (jint)getStatus;

- (void)setStatusWithInt:(jint)status;

- (jint)getgId;

- (void)setgIdWithInt:(jint)gId;

- (jint)getQueue;

- (void)setQueueWithInt:(jint)queue;

- (jlong)getDue;

- (void)setDueWithLong:(jlong)due;

- (NSString *)getPackage;

- (void)setPackageWithNSString:(NSString *)_package;

- (jint)getLevel;

- (void)setLevelWithInt:(jint)level;

- (jint)getRev_count;

- (void)setRev_countWithInt:(jint)rev_count;

- (NSString *)getUser_note;

- (void)setUser_noteWithNSString:(NSString *)user_note;

- (jint)getLast_ivl;

- (void)setLast_ivlWithInt:(jint)last_ivl;

- (void)increaseRevCount;

- (jint)getFactor;

- (void)setFactorWithInt:(jint)factor;

@end

J2OBJC_EMPTY_STATIC_INIT(ComBorn2goLazzybeeAlgorithmsCardSched_Card)

J2OBJC_TYPE_LITERAL_HEADER(ComBorn2goLazzybeeAlgorithmsCardSched_Card)

#endif // _ComBorn2goLazzybeeAlgorithmsCardSched_H_
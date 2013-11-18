//
//  YJTestResultHandle.h
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//
/*题目的判断*/

#import "YJQuestionHandle.h"
#import "YJTestDefine.h"
@protocol YJTestResultHandleDelegate;
@interface YJTestResult : NSObject
@property(nonatomic,assign)float score;
@property(nonatomic,retain)NSArray *trueArray;
@property(nonatomic,retain)NSArray *falseArray;
@property(nonatomic,retain)NSDictionary *answerDict;
@property(nonatomic,retain)NSDictionary *timeDict;
@end
@interface YJTestResultHandle : NSObject
@property(nonatomic,assign)id<YJTestResultHandleDelegate>delegate;
@property(nonatomic,retain)YJQuestionHandle *questionHandle;
@property(nonatomic,retain)NSMutableDictionary *answerDict;
@property(nonatomic,retain)NSMutableDictionary *timeDict;
-(id)initWithQuestionHandle:(YJQuestionHandle *)handle;
-(YJTestResult *)result;
-(BOOL)checkAnswerWithQuestionId:(int)questionId answerArray:(NSArray *)answers;
-(BOOL)userRightOrNotWithQuestionId:(int)questionId;
-(void)insertAnswer:(NSArray *)answer withQuestionId:(int)questionId;
-(void)insertAnswerTime:(double)time withQuestionId:(int)questionId;
-(NSArray *)getUserAnswerWithQuestionId:(int)questionId;
-(BOOL)userAnswerOrNotQueationWithQuestionId:(int)questionId;
-(int)getAnswerQuestionCount;//答过的题目数目
-(int)getSelectAnswerQuestionCount;//作出选择的题目的数目
@end
@interface NSArray (YJTestResultHandle)
-(NSString *)getStringWithSeparator:(NSString *)separator;
-(BOOL)isEquleToAnswerArray:(NSArray *)answerArray;
-(BOOL)containsNumber:(NSNumber *)number;
@end
@protocol YJTestResultHandleDelegate <NSObject>
@optional
-(void)checkFinishedWithQuestionId:(int )questionId trueOrNot:(BOOL)trueOrNot;
@end
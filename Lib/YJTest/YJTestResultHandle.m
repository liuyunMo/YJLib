//
//  YJTestResultHandle.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJTestResultHandle.h"
@implementation YJTestResult
@synthesize score=_score;
@synthesize trueArray=_trueArray;
@synthesize falseArray=_falseArray;
@synthesize answerDict=_answerDict;
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_timeDict release];
    [_trueArray release];
    [_falseArray release];
    [_answerDict release];
    [super dealloc];
}
@end
@interface YJTestResultHandle ()
@property(nonatomic,assign)float score;
@property(nonatomic,retain)NSMutableArray *trueArray;
@property(nonatomic,retain)NSMutableArray *falseArray;
@end
@implementation YJTestResultHandle
@synthesize score=_score;
@synthesize trueArray=_trueArray;
@synthesize falseArray=_falseArray;
@synthesize answerDict=_answerDict;
@synthesize questionHandle=_questionHandle;
-(id)init
{
    if (self=[super init])
    {
        _answerDict=[[NSMutableDictionary alloc] init];
        _trueArray=[[NSMutableArray alloc] init];
        _falseArray=[[NSMutableArray alloc] init];
        _timeDict=[[NSMutableDictionary alloc] init];
        _score=0;
    }
    return self;
}
-(id)initWithQuestionHandle:(YJQuestionHandle *)handle
{
    if (self=[self init])
    {
        self.questionHandle=handle;
    }
    return self;
}
-(YJTestResult *)result
{
    if (self.answerDict.count<1||!self.questionHandle)
    {
        return nil;
    }
    YJTestResult *result=[[YJTestResult alloc] init];
    result.falseArray=[self.falseArray sortedArrayUsingSelector:@selector(compare:)];
    result.trueArray=[self.trueArray sortedArrayUsingSelector:@selector(compare:)];
    result.answerDict=[NSDictionary dictionaryWithDictionary:self.answerDict];
    result.timeDict=[NSDictionary dictionaryWithDictionary:self.timeDict];
    result.score=self.score;
    return [result autorelease];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_timeDict release];
    [_questionHandle release];
    [_trueArray release];
    [_falseArray release];
    [_answerDict release];
    [super dealloc];
}
-(BOOL)checkAnswerWithQuestionId:(int)questionId answerArray:(NSArray *)answers
{
    BOOL trueOrNot=NO;
    NSString *questionIdStr=[NSString stringWithFormat:@"%d",questionId];
    if (answers)
    {
        NSString *ansStr=[[answers sortedArrayUsingSelector:@selector(compare:)] getStringWithSeparator:@","];
        NSString *answer=[[self.questionHandle getAnswerWithQuestionId:questionId] getStringWithSeparator:@","];
        trueOrNot=[ansStr isEqualToString:answer];
        
        
        NSArray *answerSave=[self.answerDict objectForKey:questionIdStr];
        if ([answerSave isEquleToAnswerArray:answers])
        {
            
        }else{
            [self.answerDict setObject:[answers sortedArrayUsingSelector:@selector(compare:)] forKey:questionIdStr];
            if (trueOrNot)
            {
                if (![self.trueArray containsObject:questionIdStr])
                {
                    [self.trueArray addObject:questionIdStr];
                }
                if ([self.falseArray containsObject:questionIdStr])
                {
                    [self.falseArray removeObject:questionIdStr];
                }
            }else{
                if (![self.falseArray containsObject:questionIdStr])
                {
                    [self.falseArray addObject:questionIdStr];
                }
                if ([self.trueArray containsObject:questionIdStr])
                {
                    [self.trueArray removeObject:questionIdStr];
                }
            }
            if ([self.delegate respondsToSelector:@selector(checkFinishedWithQuestionId:trueOrNot:)])
            {
                [self.delegate checkFinishedWithQuestionId:questionId trueOrNot:trueOrNot];
            }
        }
    }else{
        [self.answerDict removeObjectForKey:questionIdStr];
        [self.falseArray removeObject:questionIdStr];
        [self.trueArray  removeObject:questionIdStr];
    }
    return trueOrNot;
}
-(BOOL)userRightOrNotWithQuestionId:(int)questionId
{
    return [self.trueArray containsObject:[NSString stringWithFormat:@"%d",questionId]];
}
-(float)score
{
    _score=0.0f;
    for (NSNumber *num in self.trueArray)
    {
        _score+=[self.questionHandle getQuestionWithQuestionId:[num intValue]].score;
    }
    return _score;
}
-(void)insertAnswer:(NSArray *)answer withQuestionId:(int)questionId
{
    [self.answerDict setObject:answer.count>1?[answer sortedArrayUsingSelector:@selector(compare:)]:answer forKey:[NSString stringWithFormat:@"%d",questionId]];
}
-(void)insertAnswerTime:(double)time withQuestionId:(int)questionId
{
    [self.timeDict setObject:@(time) forKey:[NSString stringWithFormat:@"%d",questionId]];
}
-(NSArray *)getUserAnswerWithQuestionId:(int)questionId
{
    return [self.answerDict objectForKey:[NSString stringWithFormat:@"%d",questionId]];
}
-(BOOL)userAnswerOrNotQueationWithQuestionId:(int)questionId
{
    NSArray *arr=[self getUserAnswerWithQuestionId:questionId];
    return arr&&[arr isKindOfClass:[NSArray class]]&&arr.count>0;
}
-(int)getAnswerQuestionCount
{
    return self.answerDict.count;
}
-(int)getSelectAnswerQuestionCount
{
    int selectCount=0;
    NSArray *arr=[self.answerDict allKeys];
    for (int i=0; i<arr.count; i++)
    {
        int questionId=[[arr objectAtIndex:i] intValue];
        if ([self userAnswerOrNotQueationWithQuestionId:questionId])
        {
            selectCount++;
        }
    }
    return selectCount;
}
@end
@implementation NSArray (YJTestResultHandle)
-(NSString *)getStringWithSeparator:(NSString *)separator
{
    if (!self)
    {
        return nil;
    }
    if (self.count<1)
    {
        return @"";
    }
    NSMutableString *str =[[NSMutableString alloc] init];
    NSArray *arr=[self sortedArrayUsingSelector:@selector(compare:)];
    for(NSString *subStr in arr)
    {
        if ([subStr isKindOfClass:[NSString class]])
        {
            [str appendString:subStr];
            if ([arr indexOfObject:subStr]==arr.count-1) continue;
            [str appendString:separator];
        }else{
            [str appendFormat:@"%@",subStr];
            if ([arr indexOfObject:subStr]==arr.count-1) continue;
            [str appendString:separator];
        }
    }
    return [str autorelease];
}
-(BOOL)isEquleToAnswerArray:(NSArray *)answerArray
{
    if (![answerArray isKindOfClass:[NSArray class]]) return NO;
    return [[self getStringWithSeparator:@","] isEqualToString:[answerArray getStringWithSeparator:@","]];
}
-(BOOL)containsNumber:(NSNumber *)number
{
    int contain=NO;
    for (NSNumber *num in self)
    {
        if ([num isKindOfClass:[NSNumber class]]&&[num isEqualToNumber:number])
        {
            contain=YES;
        }
    }
    return contain;
}
@end
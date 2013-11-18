//
//  YJQuestionHandle.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJQuestionHandle.h"
@interface YJQuestionHandle()
@property(nonatomic,retain)NSMutableDictionary *questionDict;
@end

@implementation YJQuestionHandle
@synthesize questionIdArray=_questionIdArray;
@synthesize questionDict=_questionDict;
-(id)init
{
    return nil;
}
-(void)initData
{
    _questionDict=[[NSMutableDictionary alloc] init];
}
-(id)initWithQuestionArray:(NSArray *)questionArray
{
    if (self=[super init])
    {
        [self initData];
        NSMutableArray *idArr=[[NSMutableArray alloc] init];
        for (YJQuestion *question in questionArray)
        {
            [idArr addObject:@(question.questionId)];
            [_questionDict setObject:question forKey:@(question.questionId)];
        }
        _questionIdArray=[[idArr sortedArrayUsingSelector:@selector(compare:)] retain];
        [idArr release];
    }
    return self;
}
-(YJQuestion *)getQuestionWithIndex:(int)index
{
    if (index>=self.questionCount)
    {
        //抛出错误！！
        return nil;
    }
    int questionId=[[self.questionIdArray objectAtIndex:index] intValue];
    return [self getQuestionWithQuestionId:questionId];
}
-(YJQuestion *)getQuestionWithQuestionId:(int)questionId
{
    return [self.questionDict objectForKey:@(questionId)];
}
-(int)getQuestionIdWithIndex:(int)index
{
    return [[self.questionIdArray objectAtIndex:index] intValue];
}
-(int)questionCount
{
    return [self.questionIdArray count];
}
-(NSArray *)getAnswerWithQuestionId:(int)questionId
{
    YJQuestion *question=[self getQuestionWithQuestionId:questionId];
    return [question.answerArray sortedArrayUsingSelector:@selector(compare:)];
}
-(NSArray *)getAnswerWithIndex:(int)index
{
    if (index>=self.questionCount)
    {
        //抛出错误！！
        return nil;
    }
    int questionId=[[self.questionIdArray objectAtIndex:index] intValue];
    return [self getAnswerWithQuestionId:questionId];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_questionIdArray release];
    [_questionDict release];
    [super dealloc];
}
@end

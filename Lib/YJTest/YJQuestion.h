//
//  YJQuestion.h
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-22.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

/* 问题对象 */

#import <Foundation/Foundation.h>
#import "YJTestDefine.h"
enum 
{
    kSingle=1,//单选
    kMultinomial,//多选
    kQA,//问答
    kFillIn//填空    暂不支持
};
typedef NSInteger YJQuestionType;
@interface YJQuestion : NSObject
@property(nonatomic,retain)NSString *question;//题干
@property(nonatomic,retain)NSArray *optionArray;//选项
@property(nonatomic,retain)NSArray *flagArray;//标示
@property(nonatomic,retain)NSArray *answerArray;
@property(nonatomic,retain)NSString *parse;//解释语
@property(nonatomic,assign)int questionId;//题目id （必需）用于排序
@property(nonatomic,assign)YJQuestionType questionType;
@property(nonatomic,assign)float score;
@end

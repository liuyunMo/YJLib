//
//  YJQuestionView.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJQuestionView.h"
#define __QUESTION_FONT [UIFont systemFontOfSize:15]
@implementation YJQuestionView
-(id)initWithString:(NSString *)string frame:(CGRect)frame
{
    if (self=[super initWithString:string frame:frame])
    {
        self.font=__QUESTION_FONT;
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
@end

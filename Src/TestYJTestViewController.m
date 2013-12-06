//
//  TestYJTestViewController.m
//  YJLib
//
//  Created by zhongyy on 13-10-16.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "TestYJTestViewController.h"

@interface TestYJTestViewController ()<YJExamViewDelegate>
{
    NSMutableDictionary *answerDict;
}
@end

@implementation TestYJTestViewController
-(NSArray *)getQuestions
{
    NSMutableArray *questions=OBJ_CREATE(NSMutableArray);
    answerDict=[[NSMutableDictionary alloc] init];
    for (int i=0; i<10; i++)
    {
        YJQuestion *question=OBJ_CREATE(YJQuestion);
        question.questionId=i+1;
        question.questionType=i%3+1;
        question.question=@"这个是题目啊哈啊哈啊哈";
        question.flagArray=@[@"A",@"B"];
        question.optionArray=@[@"第一个选项",@"第二个选项"];
        question.answerArray=@[@"A"];
        question.parse=@"解释语";
        question.score=1.5;
        [questions addObject:question];
        [question release];
        if(i%2==0)[answerDict setObject:@[@"A"] forKey:[NSString stringWithFormat:@"%d",question.questionId]];
    }
    return [questions autorelease];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    UIButton *bu=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    bu.frame=CGRectMake(100, 100, 100, 100);
    [bu addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
}

-(void)buttonPressed:(UIButton*)bu
{
    YJExamViewController *exam=[[YJExamViewController alloc] initWithQuestionArray:[self getQuestions]];
    exam.delegate_exam=self;
    exam.examType=kYJExamExam;
    exam.userAnswerDict=answerDict;
    if (exam) {
        [self presentModalViewController:exam animated:YES];
        [exam release];
    }else{
        [self showAlertWithMessage:@"哈哈  创建失败！"];
    }
}
-(void)examViewControllerCreateViewFinished:(YJExamViewController *)exam
{
    YJAnswerView *anserView=(YJAnswerView *)[exam.view getYJFlagViewWithFlag:@"exam_answer"];
    CGRect rect=anserView.frame;
    rect.size.height-=49;
    anserView.frame=rect;
    
    YJButton *nextBu=[[YJButton alloc] initWithFrame:CGRectMake(230, exam.view.bounds.size.height-40, 80, 30) event:^(YJButton *bu) {
        
    }];
    nextBu.backgroundColor=[UIColor blueColor];
    nextBu.titleLabel.text=@"下一题";
    [exam.view addSubview:nextBu];
}
-(void)examViewControllerWillDisappear:(YJExamViewController*)exam result:(YJTestResult *)result isUserExit:(BOOL)userExit
{
    NSLog(@"result :%@",result.answerDict);
    [exam dismissModalViewControllerAnimated:YES];
}
@end

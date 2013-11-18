//
//  YJExamViewController.m
//  iService
//
//  Created by szfore on 13-5-9.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJExamViewController.h"
@interface YJExamViewController ()<YJNavBarDelegate,YJAnswerViewDelegate>
{
    YJQuestionHandle *questionHandle;
    YJTestResultHandle *resultHandle;
    NSTimer *timer;
    
    float currentAnswerTime;//当前题目的答题时间计数
}
@end

@implementation YJExamViewController
-(id)init
{
    SAFE_RELEASE(self);
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    SAFE_RELEASE(self);
    return self;
}
-(id)initWithQuestionArray:(NSArray *)questionArr
{
    if (self=[super initWithNibName:nil bundle:nil])
    {
        if (questionArr) {
            questionHandle=[[YJQuestionHandle alloc] initWithQuestionArray:questionArr];
            resultHandle=[[YJTestResultHandle alloc] initWithQuestionHandle:questionHandle];
        }else{
            SAFE_RELEASE(self);
        }
    }
    return self;
}
-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *leftGes=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextQuestion)];
    leftGes.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGes];
    [leftGes release];
    
    UISwipeGestureRecognizer *rightGes=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPreQuestion)];
    rightGes.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGes];
    [rightGes release];
}
-(void)showQuestionAtIndex:(int)index
{
    if (index>self.questionCount-1||index<0)
    {
        if ([self.delegate_exam respondsToSelector:@selector(loadQuestionError:exam:)])
        {
            NSError *error=[NSError errorWithDomain:@"题目索引越界！" code:kYJExamErrorBeyond userInfo:nil];
            [self.delegate_exam loadQuestionError:error exam:self];
        }
    }else{
        self.currentQuestionIndex=index;
        [self showCurrentQuestionAnimation:NO nextOrPre:YES];
    }
}
-(void)gotoNextQuestion
{
    if (![self answerWillChangeQuestion]) return;
    
    _currentQuestionIndex++;
    if (_currentQuestionIndex>self.questionCount-1)
    {
        if ([self.delegate_exam respondsToSelector:@selector(loadQuestionError:exam:)])
        {
            NSError *error=[NSError errorWithDomain:@"已经是最后一题了！" code:kYJExamErrorNoNext userInfo:nil];
            [self.delegate_exam loadQuestionError:error exam:self];
        }
        _currentQuestionIndex=self.questionCount-1;
        return;
    }
    [self showCurrentQuestionAnimation:YES nextOrPre:YES];
}
-(void)gotoPreQuestion
{
    if (![self answerWillChangeQuestion]) return;
    if (self.examType==kYJExamCompetition) return;//竞赛  不允许显示上一题;
    _currentQuestionIndex--;
    if (_currentQuestionIndex<0)
    {
        if ([self.delegate_exam respondsToSelector:@selector(loadQuestionError:exam:)])
        {
            NSError *error=[NSError errorWithDomain:@"已经是第一题了！" code:kYJExamErrorNoPre userInfo:nil];
            [self.delegate_exam loadQuestionError:error exam:self];
        }
        _currentQuestionIndex=0;
        return;
    }
    [self showCurrentQuestionAnimation:YES nextOrPre:NO];
}
-(BOOL)answerWillChangeQuestion
{
    YJQuestion *currentQuestion=[questionHandle getQuestionWithIndex:_currentQuestionIndex];
    switch (self.examType)
    {
        case kYJExamExam:
        {
            [self checkCurrentQuestion];
            answerView.ableChangeAnswer=YES;
        }
            break;
        case kYJExamHistory:
        {
            
        }
           break;
        case kYJExamTest1:
        {
            [self checkCurrentQuestion];
            if (currentQuestion.questionType==kMultinomial&&!answerView.showingParse&&[resultHandle userAnswerOrNotQueationWithQuestionId:currentQuestion.questionId])
            {
                [answerView showParseView];
                return NO;
            }
        }
            break;
        case kYJExamTest2:
        {
            [self checkCurrentQuestion];
            if (!answerView.showingParse&&[resultHandle userAnswerOrNotQueationWithQuestionId:currentQuestion.questionId])
            {
                [answerView showParseView];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    return YES;
}
-(BOOL)checkCurrentQuestion
{
    int currentQuestionId=[questionHandle getQuestionIdWithIndex:_currentQuestionIndex];
    NSArray *answer=[answerView getCurrentUserAnswer];
    return [resultHandle checkAnswerWithQuestionId:currentQuestionId answerArray:answer];
}
-(void)showCurrentQuestionAnswer
{
    nav.title=[NSString stringWithFormat:@"第%d题/共%d题",_currentQuestionIndex+1,self.questionCount];
    YJQuestion *currentQuestion=[questionHandle getQuestionWithIndex:_currentQuestionIndex];
    NSArray *currentQuestionAnswer=[resultHandle getUserAnswerWithQuestionId:currentQuestion.questionId];
    if (currentQuestion.questionType==kSingle||currentQuestion.questionType==kMultinomial)
    {
        [answerView selectOptionViewWithFlagStrings:currentQuestionAnswer];
    }else if(currentQuestion.questionType==kQA||currentQuestion.questionType==kFillIn){
        if(currentQuestionAnswer.count>0)[answerView setAnswerForQA:[currentQuestionAnswer objectAtIndex:0]];
    }
}
-(void)showCurrentQuestionAnimation:(BOOL)animation nextOrPre:(BOOL)next
{
    YJQuestion *question=[questionHandle getQuestionWithIndex:_currentQuestionIndex];
    answerView.question=question;
    
    [self showCurrentQuestionAnswer];
    
    switch (self.examType)
    {
        case kYJExamHistory:
        {
            if(self.showParserWhenHistory)
            {
                if (question.questionType==kFillIn||question.questionType==kQA)
                {
                    if (_showFillInParWhenHis) {
                        [answerView showParseView];
                    }
                }else{
                    [answerView showParseView];
                }
            }
            answerView.ableSelect=NO;
        }
            break;
        case kYJExamExam:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    if (animation&&[self.delegate_exam respondsToSelector:@selector(getAnimationWithYJQuestion:index:nextOrPre:exam:)])
    {
        [answerView.layer addAnimation:[self.delegate_exam getAnimationWithYJQuestion:question index:_currentQuestionIndex nextOrPre:next exam:self] forKey:@"anewerAnimation"];
    }
}
-(int)questionCount
{
    return [questionHandle questionCount];
}
-(void)creatViewInExamViewController
{
    nav=[[YJNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) flagStr:@"exam_nav"];
    nav.showLeftItem=YES;
    [nav setUpLeftItemTitle:@"退出"];
    nav.showRightItem=YES;
    [nav setUpRightItemTitle:@"完成"];
    nav.delegate_navBar=self;
    [self.view addSubview:nav];
    [nav release];
    
    answerView=[[YJAnswerView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44) flagStr:@"exam_answer"];
    if ([self.delegate_exam respondsToSelector:@selector(setAnswerViewQuestionFont:optionFont:)])
    {
        UIFont *questionFont=nil,*optionFont=nil;
        [self.delegate_exam setAnswerViewQuestionFont:&questionFont optionFont:&optionFont];
        answerView.questionFont=questionFont;
        answerView.optionFont=optionFont;
    }
    answerView.delegate=self;
    answerView.scrollWithQuestion=YES;
    [self.view addSubview:answerView];
    [answerView release];
    
    if (self.examType==kYJExamCompetition)
    {
        nav.showRightItem=NO;
        CGRect rect=answerView.frame;
        rect.origin.y+=40;
        answerView.frame=rect;
        
        
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatViewInExamViewController];
    if ([self.delegate_exam respondsToSelector:@selector(examViewControllerCreateViewFinished:)])
    {
        [self.delegate_exam examViewControllerCreateViewFinished:self];
    }
    
    if(!_disenableDefaultGes)[self addGestureRecognizer];
    
    if (self.examType==kYJExamHistory) resultHandle.answerDict=[NSMutableDictionary dictionaryWithDictionary:self.userAnswerDict];
    answerView.showParseInstant=self.examType==kYJExamTest1;
    
    [self showCurrentQuestionAnimation:NO nextOrPre:YES];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_userAnswerDict release];
    [questionHandle release];
    [_layoutFilePath release];
    [resultHandle release];
    [super dealloc];
}
-(void)dissmissExamViewController:(BOOL)animation isUserExit:(BOOL)userExit
{
    CLOSE_TIMER(timer);
    if ([self.delegate_exam respondsToSelector:@selector(examViewControllerWillDisappear:result:isUserExit:)])
    {
        [self.delegate_exam examViewControllerWillDisappear:self result:resultHandle.result isUserExit:userExit];
    }else{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:animation completion:NULL];
        }
    }
}
-(YJTestResult *)getResult
{
    return resultHandle.result;
}
#pragma mark--  YJNavBarDelegate
-(void)leftItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    [self checkCurrentQuestion];
    [self dissmissExamViewController:NO isUserExit:YES];
}
-(void)rightItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    [self checkCurrentQuestion];
    YJResultViewController *result=[[YJResultViewController alloc] initWithResult:resultHandle];
    result.showPostBut=self.examType==kYJExamExam;
    result.delegate=self;
    [self presentViewController:result animated:YES completion:NULL];
    [result release];
}
#pragma mark-- YJAnswerViewDelegate 
-(BOOL)getTrueOrNotToShowParserViewWithQuestion:(YJQuestion *)question
{
    NSArray *answer=[answerView getCurrentUserAnswer];
    switch (self.examType)
    {
        case kYJExamHistory:
            answer=[resultHandle getUserAnswerWithQuestionId:question.questionId];
            break;
            
        default:
            break;
    }
    if (answer&&answer.count>0)
    {
        return [resultHandle checkAnswerWithQuestionId:[questionHandle getQuestionWithIndex:_currentQuestionIndex].questionId answerArray:answer];
    }
    return NO;
}
#pragma mark-- YJResultViewControllerDelegate
-(void)selectQuestionWithIndex:(int)index
{
    [self showQuestionAtIndex:index];
}
-(void)postButPressed
{
    [self dissmissExamViewController:NO isUserExit:NO];
}
@end

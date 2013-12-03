//
//  YJExamViewController.h
//  iService
//
//  Created by szfore on 13-5-9.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*kYJExamCompetition 还没做～～*/

#import "YJTestDefine.h"
#import "YJAnswerView.h"
#import "YJNavBar.h"
#import "YJTestDelegate.h"
#import "YJResultViewController.h"
#import "YJImageView.h"

enum  {
    kYJExamExam = 0,
    kYJExamHistory,
    kYJExamTest1,//单选即时显示答案
    kYJExamTest2,//单选不即时显示答案，确定用户选择不再修改时显示答案
    kYJExamCompetition//竞赛
    };
typedef NSUInteger YJExamType;



@interface YJExamViewController : UIViewController<YJResultViewControllerDelegate>
{
    YJAnswerView *answerView;
    YJNavBar *nav;
}
@property(nonatomic,assign)YJExamType examType;
@property(nonatomic,assign)int currentQuestionIndex;
@property(nonatomic,assign)id<YJExamViewDelegate>delegate_exam;
@property(nonatomic,retain)NSString *layoutFilePath;
@property(nonatomic,readonly)int questionCount;
@property(nonatomic,retain)NSDictionary *userAnswerDict;
@property(nonatomic,assign)BOOL showParserWhenHistory;
@property(nonatomic,assign)BOOL showFillInParWhenHis;
@property(nonatomic,assign)BOOL disenableDefaultGes;//取消默认手势; default NO;

//kYJExamCompetition 
@property(nonatomic,assign)float timePerQuestion;
@property(nonatomic,assign)int currentScore;


-(id)initWithQuestionArray:(NSArray *)questionArr;
-(NSArray*)getQuestionIdArr;
-(YJTestResult *)getResult;
-(void)dissmissExamViewController:(BOOL)animation isUserExit:(BOOL)userExit;
-(void)showQuestionAtIndex:(int)index;
-(void)gotoNextQuestion;
-(void)gotoPreQuestion;
@end


@protocol YJExamViewDelegate <NSObject>
@optional
-(void)examViewControllerCreateViewFinished:(YJExamViewController *)exam;
-(void)setAnswerViewQuestionFont:(UIFont **)questionFont optionFont:(UIFont**)optionFont;
-(void)loadQuestionError:(NSError *)error exam:(YJExamViewController*)exam;
-(CAAnimation *)getAnimationWithYJQuestion:(YJQuestion *)question index:(int)index nextOrPre:(BOOL)next exam:(YJExamViewController*)exam;
-(void)examViewControllerWillDisappear:(YJExamViewController*)exam result:(YJTestResult *)result isUserExit:(BOOL)userExit;
@end
/*
 答题界面显示
 
 展示和统计用户答案，不负责答案的判断，题目的判定需要通过
 YJAnswerViewDelegate传递
 
 
 还有问答题部分需要处理～～～
 */

#import <UIKit/UIKit.h>
#import "YJOptionView.h"
#import "YJQuestionView.h"
#import "YJQuestion.h"
#import "YJTestResultHandle.h"
#define ANSWER_QA_TAG 10
@protocol YJAnswerViewDelegate;
@interface YJAnswerView : YJFlagView<YJOptionViewDelegate,UITextViewDelegate>
@property(nonatomic,retain)YJQuestion *question;
@property(nonatomic,readonly)UIScrollView *optionSuperView;
@property(nonatomic,assign)BOOL scrollWithQuestion;//滚动时联动题干，默认为NO;
@property(nonatomic,assign)BOOL ableSelect;// 默认YES
@property(nonatomic,readonly)BOOL showingParse;
@property(nonatomic,assign)BOOL showParseInstant;//单选是否即时显示答案
@property(nonatomic,assign)BOOL ableChangeAnswer;//是否允许修改答案
@property(nonatomic,assign)id<YJAnswerViewDelegate>delegate;
@property(nonatomic,retain)UIFont *questionFont;
@property(nonatomic,retain)UIFont *optionFont;
-(id)initWithFrame:(CGRect)frame question:(YJQuestion *)question;
-(void)selectOptionViewWithIndex:(int)index;
-(void)selectOptionViewWithIndexs:(NSArray *)indexs;
-(void)selectOptionViewWithFlagStr:(NSString *)flagStr;
-(void)selectOptionViewWithFlagStrings:(NSArray*)flagStrings;
-(void)showParseView;
-(void)setAnswerForQA:(NSString *)answerStr;
-(NSArray *)getCurrentUserAnswer;
@end
@protocol YJAnswerViewDelegate <NSObject>
@optional
-(BOOL)getTrueOrNotToShowParserViewWithQuestion:(YJQuestion *)question;
@end
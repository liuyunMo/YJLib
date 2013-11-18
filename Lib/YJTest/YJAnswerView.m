//
//  YJAnswerView.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJAnswerView.h"
@interface YJAnswerView ()
{
    float contentHeight;
    CGRect fillInRect;
}
@property(nonatomic,retain)NSArray *answerArr;
@end
@implementation YJAnswerView
@synthesize question=_question;
@synthesize optionSuperView=_optionSuperView;
@synthesize scrollWithQuestion=_scrollWithQuestion;
@synthesize answerArr=_answerArr;
@synthesize ableSelect=_ableSelect;
-(void)createAnswerViewWithText:(NSString *)text;
{
    UITextView *textView=(UITextView *)[_optionSuperView viewWithTag:ANSWER_QA_TAG];
    if (!textView)
    {
        float height=_optionSuperView.bounds.size.height-contentHeight-10;
        fillInRect=CGRectMake(10, contentHeight, _optionSuperView.bounds.size.width-20, height<20?20:height);
        textView=[[UITextView alloc] initWithFrame:fillInRect];
        textView.tag=ANSWER_QA_TAG;
        textView.font=[UIFont systemFontOfSize:15];
        textView.textColor=[UIColor purpleColor];
        textView.delegate=self;
        textView.returnKeyType=UIReturnKeyDone;
        textView.backgroundColor=[UIColor whiteColor];
        textView.layer.cornerRadius=3;
        textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth=.5;
        [_optionSuperView addSubview:textView];
        [textView release];
        
        contentHeight+=textView.frame.size.height;
    }
    if (text)
    {
        textView.text=text;
    }
    
    [self adjustContentSize];
    if (text||!self.ableSelect)
    {
        if (!self.ableChangeAnswer)
        {
            textView.userInteractionEnabled=NO;
            self.ableSelect=NO;
            //[self showParseView];
        }
    }
}
-(void)createView
{
    _showingParse=NO;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backgroundColor=[UIColor clearColor];
    _optionSuperView=[[UIScrollView alloc] initWithFrame:self.bounds];
    _optionSuperView.showsVerticalScrollIndicator=NO;
    _optionSuperView.bounces=NO;
    [self addSubview:_optionSuperView];
    [_optionSuperView release];
    
    
    
    UILabel *typeLa=[[UILabel alloc] init];
    typeLa.frame=CGRectMake(10, 5, 300, 20);
    typeLa.textColor=[UIColor redColor];
    typeLa.backgroundColor=[UIColor clearColor];
    YJQuestionView *questionView=[[YJQuestionView alloc] initWithString:self.question.question frame:CGRectMake(0, typeLa.bounds.size.height+10, self.bounds.size.width, 0)];
    if (self.questionFont) questionView.font=self.questionFont;
    if (self.scrollWithQuestion)
    {
        [_optionSuperView addSubview:questionView];
        [_optionSuperView addSubview:typeLa];
        contentHeight=questionView.bounds.size.height+typeLa.bounds.size.height+10;
    }else{
        [self addSubview:questionView];
        [self addSubview:typeLa];
        _optionSuperView.frame=CGRectMake(0, questionView.bounds.size.height+typeLa.bounds.size.height, self.bounds.size.width, self.bounds.size.height-questionView.bounds.size.height-typeLa.bounds.size.height);
        contentHeight=0;
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    [questionView addGestureRecognizer:tap];
    [tap release];
    [questionView release];
    [typeLa release];
    
    
    if (self.question.questionType==kQA)
    {
        typeLa.text=[NSString stringWithFormat:@"题型：问答题"];
        
        
        /*
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, contentHeight, self.bounds.size.height, 20)];
        la.text=@"答案是：";
        la.backgroundColor=[UIColor clearColor];
        [_optionSuperView addSubview:la];
        [la release];
        contentHeight+=20;
         */
        
        [self createAnswerViewWithText:nil];
        
        return;
    }else if(self.question.questionType==kSingle){
        typeLa.text=[NSString stringWithFormat:@"题型：单选题"];
    }else if(self.question.questionType==kMultinomial){
        typeLa.text=[NSString stringWithFormat:@"题型：多选题"];
    }else /*if(self.question.questionType==kFillIn){
        typeLa.text=[NSString stringWithFormat:@"题型：填空题"];
    }else*/{
        typeLa.text=[NSString stringWithFormat:@"题型：其他"];
    }
    
    
    for (int i=0;i<self.question.optionArray.count;i++)
    {
        NSString *optionStr=[self.question.optionArray objectAtIndex:i];
        YJOptionView *optionView=[[YJOptionView alloc] initWithString:[NSString stringWithFormat:@"%@、%@",[self.question.flagArray objectAtIndex:i],optionStr] frame:CGRectMake(5, contentHeight, self.bounds.size.width-5, 0)];
        optionView.delegate=self;
        if (self.optionFont)optionView.font=self.optionFont;
        optionView.tag=i+1;
        optionView.userInteractionEnabled=self.ableSelect;
        if (i<self.question.flagArray.count)
        {
            optionView.flagStr=[self.question.flagArray objectAtIndex:i];
        }else{
            optionView.flagStr=optionStr;
        }
        if ([self.answerArr containsObject:optionView.flagStr ])
        {
            optionView.selected=YES;
        }
        [_optionSuperView addSubview:optionView];

        contentHeight+=optionView.bounds.size.height;
        [optionView release];
    }
    [self adjustContentSize];
}
-(void)adjustContentSize;
{
    [_optionSuperView setContentSize:CGSizeMake(self.bounds.size.width, contentHeight)];
}
-(void)setScrollWithQuestion:(BOOL)scrollWithQuestion
{
    _scrollWithQuestion=scrollWithQuestion;
    [self createView];
}
-(void)setQuestionFont:(UIFont *)questionFont
{
    SET_PAR(_questionFont, questionFont);
    [self createView];
}
-(void)setOptionFont:(UIFont *)optionFont
{
    SET_PAR(_optionFont, optionFont);
    [self createView];
}
-(void)setAnswerForQA:(NSString *)answerStr
{
    [self createAnswerViewWithText:answerStr];
}
-(id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame question:nil];
}
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame flagStr:flagStr])
    {
        return [self initWithFrame:frame];
    }
    return nil;
}
-(id)initWithFrame:(CGRect)frame question:(YJQuestion *)question
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        self.ableSelect=YES;
        self.question=question;
    }
    return self;
}
-(void)setQuestion:(YJQuestion *)question
{
    [question retain];
    [_question release];
    _question=question;
    self.answerArr=@[];
    self.ableSelect=YES;
    [self createView];
}
-(NSArray *)getCurrentUserAnswer
{
    [self resignTextView];
    return self.answerArr;
}
-(void)selectOptionViewWithIndex:(int)index
{
    [self selectOptionViewWithIndexs:@[@(index)]];
}
-(void)setAbleSelect:(BOOL)ableSelect
{
    _ableSelect=ableSelect;
    for (YJOptionView *vi in _optionSuperView.subviews)
    {
        if ([vi isKindOfClass:[YJOptionView class]])
        {
            vi.userInteractionEnabled=_ableSelect;
        }
        if ([vi isKindOfClass:[UITextView class]]) {
            [(UITextView *)vi setEditable:NO];
        }
    }
}
-(void)selectOptionViewWithIndexs:(NSArray *)indexs
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:self.answerArr];
    for (int i=0; i<indexs.count; i++)
    {
        int index=[[indexs objectAtIndex:i] intValue];
        YJOptionView *vi=(YJOptionView *)[_optionSuperView viewWithTag:index+1];
        if (vi&&[vi isKindOfClass:[YJOptionView class]])
        {
            if (!self.ableChangeAnswer)
            {
                self.ableSelect=NO;
                [self showParseView];
            }
            vi.selected=YES;
            if (![arr containsObject:vi.flagStr])
            {
                [arr addObject:vi.flagStr];
            }
        }
    }
    self.answerArr=arr;
    [arr release];
}
-(void)selectOptionViewWithFlagStr:(NSString *)flagStr
{
    [self selectOptionViewWithFlagStrings:@[flagStr]];
}
-(void)selectOptionViewWithFlagStrings:(NSArray*)flagStrings
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:self.answerArr];
    for (NSString *flag in flagStrings)
    {
        if (!self.ableChangeAnswer)
        {
            self.ableSelect=NO;
            //[self showParseView];
        }
        YJOptionView *vi=(YJOptionView *)[_optionSuperView getYJFlagViewWithFlag:flag];
        vi.selected=YES;
        if (![arr containsObject:flag])
        {
            [arr addObject:flag];
        }
    }
    self.answerArr=arr;
    [arr release];
}
-(void)showParseView
{
    if (self.showingParse) return;
    self.ableSelect=NO;
    _showingParse=YES;
    
    UILabel *answerLa=[[UILabel alloc] initWithFrame:CGRectMake(0, contentHeight+5,200, 20)];
    answerLa.text=[NSString stringWithFormat:@"参考答案：%@",[self.question.answerArray getStringWithSeparator:@","]];
    answerLa.textColor=[UIColor redColor];
    for (NSString *flag in self.question.answerArray)
    {
        YJOptionView *optionView=(YJOptionView *)[_optionSuperView getYJFlagViewWithFlag:flag];
        optionView.textColor=[UIColor colorWithRed:.8 green:.3 blue:.3 alpha:1];
    }
    
    answerLa.backgroundColor=[UIColor clearColor];
    [_optionSuperView addSubview:answerLa];
    [answerLa release];
    
    contentHeight+=20;
    
//    if ([self.delegate respondsToSelector:@selector(getTrueOrNotToShowParserViewWithQuestion:)])
//    {
//        BOOL trueOrNot=[self.delegate getTrueOrNotToShowParserViewWithQuestion:self.question];
//        UIImageView *im=[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-65, contentHeight, 60, 20)];
//        im.backgroundColor=trueOrNot?[UIColor redColor]:[UIColor blackColor];
//        [_optionSuperView addSubview:im];
//        [im release];
//    }
//    
//    contentHeight+=20;  
//    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, contentHeight,200, 20)];
//    la.text=@"题目解析：";
//    la.backgroundColor=[UIColor clearColor];
//    [_optionSuperView addSubview:la];
//    [la release];
//    
//    contentHeight+=20;
//    
//    UITextView *parseView=[[UITextView alloc] initWithFrame:CGRectMake(0, contentHeight, _optionSuperView.bounds.size.width, 10)];
//    parseView.font=[UIFont systemFontOfSize:15];
//    parseView.backgroundColor=[UIColor clearColor];
//    parseView.userInteractionEnabled=NO;
//    if (self.question.parse)
//    {
//        parseView.text=self.question.parse;
//    }else{
//        parseView.text=@"暂无解析！";
//    }
//    [_optionSuperView addSubview:parseView];
//    [parseView release];
//    
//    CGRect rect=parseView.frame;
//    rect.size.height=parseView.contentSize.height;
//    parseView.frame=rect;
//    
//    contentHeight+=parseView.contentSize.height;
    [_optionSuperView setContentSize:CGSizeMake(self.bounds.size.width, contentHeight)];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_optionFont release];
    [_questionFont release];
    [_answerArr release];
    [_question release];
    [super dealloc];
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)showKeyboard:(NSNotification *)note
{
    float duringTime=[[note.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    float keyBoardHeight=[[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    int animationCurve=[[note.userInfo objectForKey:@"UIKeyboardAnimationCurveUserInfoKey"] intValue];
    
    UITextView *textView=(UITextView *)[_optionSuperView viewWithTag:ANSWER_QA_TAG];
    __block typeof(self)bSelf=self;
    
    [UIView animateWithDuration:duringTime animations:^{
        [UIView setAnimationCurve:animationCurve];
        CGRect rect=textView.frame;
        rect.size.width=bSelf.superview.bounds.size.width;
        rect.size.height=self.superview.bounds.size.height-keyBoardHeight-rect.origin.x;
        rect.origin.x=0;
        rect.origin.y=0;
        textView.frame=rect;
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)note
{
    float duringTime=[[note.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    int animationCurve=[[note.userInfo objectForKey:@"UIKeyboardAnimationCurveUserInfoKey"] intValue];
    
    UITextView *textView=(UITextView *)[_optionSuperView viewWithTag:ANSWER_QA_TAG];
    [UIView animateWithDuration:duringTime animations:^{
        [UIView setAnimationCurve:animationCurve];
        textView.frame=fillInRect;
    }];
}
-(void)selectOptionView:(YJOptionView *)optionView
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:self.answerArr];
    if (self.question.questionType==kSingle)
    {
        for (NSString *flag in self.answerArr)
        {
            YJOptionView *vi=(YJOptionView *)[self.optionSuperView  getYJFlagViewWithFlag:flag];
            vi.selected=NO;
        }
        [arr removeAllObjects];
    }
    if (![arr containsObject:optionView.flagStr])
    {
        [arr addObject:optionView.flagStr];
    }
    self.answerArr=arr;
    [arr release];
    
    if (self.question.questionType==kSingle&&self.showParseInstant)
    {
        [self showParseView];
    }
}
-(void)deselectOptionView:(YJOptionView *)optionView
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:self.answerArr];
    [arr removeObject:optionView.flagStr];
    self.answerArr=arr;
    [arr release];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        [self addNotification];
    }else{
        [self removeNotification];
    }
}
-(void)resignTextView
{
    UITextView *textView=(UITextView *)[_optionSuperView viewWithTag:ANSWER_QA_TAG];
    if (textView)
    {
        [textView resignFirstResponder];
        if(textView.text&&![textView.text isEqualToString:@""])
        {
            NSArray *arr=[NSArray arrayWithObject:textView.text];
            self.answerArr=arr;
        }else{
            self.answerArr=nil;
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text)
    {
        NSArray *arr=[NSArray arrayWithObject:textView.text];
        self.answerArr=arr;
    }
    if ([@"\n" isEqualToString:text])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
@end

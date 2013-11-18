//
//  YJResultViewController.m
//  iTest
//
//  Created by szfore on 13-4-12.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJResultViewController.h"

@interface YJResultViewController ()

@end

@implementation YJResultViewController
-(id)initWithResult:(YJTestResultHandle *)resultHandle;
{
    if (self=[super init])
    {
        self.resultHandle=resultHandle;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 26)];
    la.text=[NSString stringWithFormat:@"共有题目%d题，已回答%d题",self.resultHandle.questionHandle.questionCount,[self.resultHandle getSelectAnswerQuestionCount]];
    la.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:la];
    [la release];
    UIScrollView *sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.bounds.size.height-70)];
    sc.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sc];
    [sc release];
    
    
    UINavigationBar *nav=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    nav.tintColor=[UIColor colorWithPatternImage:[YJImageManager getImageWithKeyString:@"exam_nav_tab_bg"]];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定交卷" style:UIBarButtonItemStyleBordered target:self action:@selector(endEaxmButPressed)];
    UINavigationItem *item=[[UINavigationItem alloc] init];
    item.leftBarButtonItem=leftItem;
    item.rightBarButtonItem=self.showPostBut?rightItem:nil;
    nav.items=@[item];
    nav.tag=101;
    [self.view addSubview:nav];
    [nav release];
    [leftItem release];
    [rightItem release];
    [item release];
    
    YJResultView *view=[[YJResultView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) count:self.resultHandle.questionHandle.questionCount];
    view.datasource=self;
    view.delegate=self;
    [sc addSubview:view];
    [view release];
    sc.contentSize=view.frame.size;
}
-(void)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)endEaxmButPressed
{
    [self dismissViewControllerAnimated:YES completion:^{if ([self.delegate respondsToSelector:@selector(postButPressed)])
    {
        [self.delegate postButPressed];
    }}];
    
}
-(void)dealloc
{
    [_resultHandle release];
    [super dealloc];
}
-(NSString *)getStringToShowWithIndex:(int)index
{
    return [NSString stringWithFormat:@"%d",index+1];
}
-(UIColor *)getTextColorToShowWithIndex:(int)index
{
    int questionId=[self.resultHandle.questionHandle getQuestionIdWithIndex:index];
    
    return [self.resultHandle userAnswerOrNotQueationWithQuestionId:questionId]?[UIColor blackColor]:[UIColor redColor];
}
-(UIColor *)getBackgroundColorToShowWithIndex:(int)index
{
    int questionId=[self.resultHandle.questionHandle getQuestionIdWithIndex:index];
    return [self.resultHandle userAnswerOrNotQueationWithQuestionId:questionId]?[UIColor whiteColor]:[UIColor orangeColor];
}
-(void)selectItemAtIndex:(int)index
{
    [self backButtonPressed];
    if ([self.delegate respondsToSelector:@selector(selectQuestionWithIndex:)])
    {
        [self.delegate selectQuestionWithIndex:index];
    }
}
@end

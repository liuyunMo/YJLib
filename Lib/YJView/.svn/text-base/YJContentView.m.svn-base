//
//  YJContentView.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-25.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJContentView.h"

@implementation YJContentView
@synthesize optionString=_optionString;
@synthesize contentOffSet=_contentOffSet;
@synthesize font=_font;
-(id)initWithString:(NSString *)string frame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.userInteractionEnabled=NO;
        self.optionString=string;
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_textColor release];
    [_font release];
    [_optionString release];
    [super dealloc];
}
-(void)setOptionString:(NSString *)optionString
{
    [optionString retain];
    [_optionString release];
    _optionString=optionString;
    [self createView];
}
-(void)setContentOffSet:(CGSize)contentOffSet
{
    _contentOffSet=contentOffSet;
    [self createView];
}
-(void)setFont:(UIFont *)font
{
    [font retain];
    [_font release];
    _font=font;
    [self createView];
}
-(void)setTextColor:(UIColor *)textColor
{
    [textColor retain];
    [_textColor release];
    _textColor=textColor;
    UITextView *contentView=(UITextView *)[self viewWithTag:1019];
    if (!contentView)
    {
        [self createView];
    }else{
        contentView.textColor=_textColor;
    }
}
-(UITextView *)getContentView
{
    return (UITextView *)[self viewWithTag:1019];
}
-(void)createView
{
    UITextView *contentView=(UITextView *)[self viewWithTag:1019];
    if (!contentView)
    {
        self.backgroundColor=[UIColor clearColor];
        contentView=[[UITextView alloc] initWithFrame:CGRectMake(self.contentOffSet.width, self.contentOffSet.height, self.bounds.size.width-self.contentOffSet.width, self.bounds.size.height)];
        contentView.editable=NO;
        contentView.tag=1019;
        contentView.backgroundColor=[UIColor clearColor];
        contentView.userInteractionEnabled=NO;
        [self addSubview:contentView];
        [contentView release];
    }
    contentView.textColor=self.textColor;
    contentView.font=self.font;
    contentView.text=self.optionString;
    float height=contentView.contentSize.height;
    CGRect rect=self.frame;
    rect.size.height=height+self.contentOffSet.height;
    self.frame=rect;
    contentView.frame=CGRectMake(self.contentOffSet.width, self.contentOffSet.height, self.bounds.size.width-self.contentOffSet.width, self.bounds.size.height-self.contentOffSet.height);
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        UITextView *contentView=(UITextView *)[self viewWithTag:1019];
        if (contentView)
        {
            float height=contentView.contentSize.height;
            CGRect rect=self.frame;
            rect.size.height=height+self.contentOffSet.height;
            self.frame=rect;
            contentView.frame=CGRectMake(self.contentOffSet.width, self.contentOffSet.height, self.bounds.size.width-self.contentOffSet.width, self.bounds.size.height-self.contentOffSet.height);
        }
    }
}
@end


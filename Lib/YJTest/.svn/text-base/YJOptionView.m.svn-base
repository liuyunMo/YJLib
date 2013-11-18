//
//  YJOptionView.m
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJOptionView.h"
#define __OPTION_FONT [UIFont systemFontOfSize:13]
@interface YJOptionView()
{
    UIImageView *selectView;
    BOOL move;
}
@end
@implementation YJOptionView
@synthesize selected=_selected;
@synthesize delegate=_delegate;
-(id)initWithString:(NSString *)string frame:(CGRect)frame
{
    if (self=[super initWithString:string frame:frame])
    {
        self.font=__OPTION_FONT;
        self.contentOffSet=CGSizeMake(20,0);
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [selectView release];
    [super dealloc];
}
-(void)setSelected:(BOOL)selected
{
    _selected=selected;
    selectView.image=[YJImageManager getStayUpImageWithKeyString:OPTION_IMAGR_KEY status:self.selected?kYJImageStatusSelected:kYJImageStatusDefault];
}
-(void)setTextColor:(UIColor *)textColor
{
    [self getContentView].textColor=textColor;
}
-(void)createView
{
    [super createView];
    if (!selectView)
    {
        selectView=[[UIImageView alloc] initWithFrame:CGRectMake(2,self.bounds.size.height/2-10 , 20, 20)];
        selectView.image=[YJImageManager getStayUpImageWithKeyString:OPTION_IMAGR_KEY status:self.selected?kYJImageStatusSelected:kYJImageStatusDefault];
        [self addSubview:selectView];
    }
    selectView.frame=CGRectMake(2,self.bounds.size.height/2-10 , 20, 20);
}
-(id)initWithFrame:(CGRect)frame
{
    return [self initWithString:nil frame:frame];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    move=NO;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    move=YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (move) return;
    self.selected=!self.selected;
    if (self.selected&&[self.delegate respondsToSelector:@selector(selectOptionView:)])
    {
        [self.delegate selectOptionView:self];
    }else if(!self.selected&&[self.delegate respondsToSelector:@selector(deselectOptionView:)])
    {
        [self.delegate deselectOptionView:self];
    }
}
@end

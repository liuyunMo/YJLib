//
//  YJCardView.m
//  iService
//
//  Created by szfore on 13-5-7.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCardView.h"
@implementation YJCardView
-(void)createViewInYJCardView
{
    if (!contentView)
    {
        contentView=[[UIScrollView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor=[UIColor clearColor];
        [self addSubview:contentView];
        [contentView release];
    }
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float contentHeight=0;
    for (int i=0; i<[self.dataSource_cardView getSectionCount:self]; i++)
    {
        YJCardCell *cell=[[YJCardCell alloc] initWithFrame:CGRectMake(0, contentHeight, self.bounds.size.width, 44)];
        cell.delegate_touch=self;
        cell.index=i;
        cell.backgroudImage=nil;
        cell.title=[self.dataSource_cardView getSectionTitleWithSectionIndex:self index:i];
        cell.cardImage=[self.dataSource_cardView getSectionImageWithSectionIndex:self index:i];
        [contentView addSubview:cell];
        [cell release];
        
        YJImageView *im=[[YJImageView alloc] init];
        im.backgroundColor=[UIColor lightGrayColor];
        im.frame=CGRectMake(0, 43.5, self.bounds.size.width, .5);
        [cell addSubview:im];
        [im release];
        
        contentHeight+=44+.5;
    }
    contentView.contentSize=CGSizeMake(contentView.bounds.size.width, contentHeight);
}
-(void)addContentView:(YJContentView *)textContentView animation:(BOOL)animation
{
    textContentView.clipsToBounds=YES;
    [contentView insertSubview:textContentView atIndex:0];
    
    
    if ([self.delegate_cardView respondsToSelector:@selector(cardView:didSelectCell:showContentView:)])
    {
        [self.delegate_cardView cardView:self didSelectCell:nil showContentView:textContentView];
    }
    
    float textHeight=textContentView.frame.size.height;
   
    int tag=[textContentView.flagStr intValue];
    for (YJFlagView *vi in contentView.subviews)
    {
        if ([vi isKindOfClass:[YJContentView class]]&&[vi.flagStr intValue]>tag)
        {
            goto changeFrame;
        }
        if ([vi isKindOfClass:[YJCardCell class]]&&[(YJCardCell *)vi index]>tag)
        {
            goto changeFrame;
        }
        continue;
    changeFrame:
        {
            if (animation)
            {
                [UIView animateWithDuration:.5 animations:^{
                    CGRect rect=vi.frame;
                    rect.origin.y+=textHeight;
                    vi.frame=rect;}];
            }else{
                CGRect rect=vi.frame;
                rect.origin.y+=textHeight;
                vi.frame=rect;
            }
        }
    }
    
    
    
    CGSize size=contentView.contentSize;
    size.height+=textHeight;
    contentView.contentSize=size;
}
-(void)removeContentViewWithFlag:(NSString *)flag animation:(BOOL)animation
{
    YJContentView *textView=(YJContentView *)[contentView getYJFlagViewWithFlag:flag];
    float textHeight=textView.frame.size.height;
    int tag=[flag intValue];
    for (YJFlagView *vi in contentView.subviews)
    {
        if ([vi isKindOfClass:[YJContentView class]]&&[vi.flagStr intValue]>tag)
        {
            goto changeFrame;
        }
        if ([vi isKindOfClass:[YJCardCell class]]&&[(YJCardCell *)vi index]>tag)
        {
            goto changeFrame;
        }
        continue;
    changeFrame:
        {
            if (animation)
            {
                [UIView animateWithDuration:.5 animations:^{
                    CGRect rect=vi.frame;
                    rect.origin.y-=textHeight;
                    vi.frame=rect;}];
            }else{
                CGRect rect=vi.frame;
                rect.origin.y-=textHeight;
                vi.frame=rect;
            }
        }
    }
    [textView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animation?.5:0];
    CGSize size=contentView.contentSize;
    size.height-=textHeight;
    contentView.contentSize=size;
    if ([self.delegate_cardView respondsToSelector:@selector(cardView:didDeselectCell:removeContentView:)])
    {
        [self.delegate_cardView cardView:self didDeselectCell:nil removeContentView:textView];
    }
}
-(void)setDataSource_cardView:(id<YJCardViewDataSource>)dataSource_cardView
{
    _dataSource_cardView=dataSource_cardView;
    [self createViewInYJCardView];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
#pragma mark--YJTouchViewDelegate Methods
-(void)viewToucheEnd:(UIView *)view touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    YJCardCell *cardView=(YJCardCell*)view;
    cardView.selected=!cardView.selected;
    if (cardView.selected)
    {
        YJContentView *textContentView=[[YJContentView alloc] initWithString:[self.dataSource_cardView getContentWithSectionTitle:self sectionTitle:cardView.title index:cardView.index] frame:CGRectMake(0, cardView.frame.size.height+cardView.frame.origin.y, cardView.frame.size.width, 10)];
        if ([self.dataSource_cardView respondsToSelector:@selector(getContentFont:cardView:)])
        {
            textContentView.font=[self.dataSource_cardView getContentFont:cardView.index cardView:self];
        }
        if ([self.dataSource_cardView respondsToSelector:@selector(getContentTextColor:cardView:)])
        {
            textContentView.textColor=[self.dataSource_cardView getContentTextColor:cardView.index cardView:self];
        }
        if ([self.dataSource_cardView respondsToSelector:@selector(getContentBackgroundColor:cardView:)])
        {
            textContentView.backgroundColor=[self.dataSource_cardView getContentBackgroundColor:cardView.index cardView:self];
        }
        textContentView.flagStr=[NSString stringWithFormat:@"%d",cardView.index];
        [self addContentView:textContentView animation:NO];
        [textContentView release];
    }else{
        [self removeContentViewWithFlag:[NSString stringWithFormat:@"%d",cardView.index] animation:NO];
    }
}
@end

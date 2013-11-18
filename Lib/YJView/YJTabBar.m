//
//  YJTabBar.m
//  YJHealth
//
//  Created by szfore on 13-7-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTabBar.h"

@implementation YJTabBar

- (id)initWithFrame:(CGRect)frame
{
    SAFE_RELEASE(self);
    return nil;
}
-(void)createTabBarView
{
    if (!backgroundImageView)
    {
        backgroundImageView=[[YJImageView alloc] initWithFrame:self.bounds];
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
    }
    float width=0.0F;
    for (int i=0;i<self.items.count;i++)
    {
        YJBarItem *item=[self.items objectAtIndex:i];
        item.selected=(i==0);
        YJImageView *image=[[YJImageView alloc] initWithFrame:CGRectMake(width, 0, item.width, self.bounds.size.height)];
        image.image=item.selected?item.selectImage:item.defaultImage;
        image.flagStr=[NSString stringWithFormat:@"%d",i];
        image.userInteractionEnabled=YES;
        [self addSubview:image];
        [image release];
        
        UILabel *la=[[UILabel alloc] initWithFrame:image.bounds];
        la.backgroundColor=[UIColor clearColor];
        la.text=item.title;
        la.font=[UIFont systemFontOfSize:13];
        la.textAlignment=UITextAlignmentCenter;
        la.tag=i+1;
        la.textColor=item.selected?item.selectColor:item.defaultColor;
        [image addSubview:la];
        [la release];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
        [image addGestureRecognizer:tap];
        [tap release];
        
        width+=item.width;
    }
}
-(void)setSelectIndex:(int)selectIndex
{
    if ([self.delegate respondsToSelector:@selector(shouldSelectItem:index:tabBar:)]&&![self.delegate shouldSelectItem:[self.items objectAtIndex:selectIndex] index:selectIndex tabBar:self]) return;
    if (selectIndex==_selectIndex)return;
    
    YJBarItem *lastItem=[self.items objectAtIndex:_selectIndex];
    YJImageView *lastIm=(YJImageView *)[self getYJFlagViewWithFlag:[NSString stringWithFormat:@"%d",_selectIndex]];
    UILabel *lastLa=(UILabel *)[lastIm viewWithTag:_selectIndex+1];
    lastItem.selected=NO;
    lastIm.image=lastItem.defaultImage;
    lastLa.textColor=lastItem.defaultColor;
    
    if ([self.delegate respondsToSelector:@selector(deselectItem:index:tabBar:)])
    {
        [self.delegate deselectItem:lastItem index:_selectIndex tabBar:self];
    }
    
    _selectIndex=selectIndex;
    
    YJBarItem *item=[self.items objectAtIndex:_selectIndex];
    YJImageView *im=(YJImageView *)[self getYJFlagViewWithFlag:[NSString stringWithFormat:@"%d",_selectIndex]];
    UILabel *la=(UILabel *)[im viewWithTag:_selectIndex+1];
    item.selected=YES;
    im.image=item.selectImage;
    la.textColor=item.selectColor;
    
    if ([self.delegate respondsToSelector:@selector(selectItem:index:tabBar:)])
    {
        [self.delegate selectItem:item index:_selectIndex tabBar:self];
    }
}
-(void)tapItem:(UITapGestureRecognizer *)tap
{
    YJImageView *im=(YJImageView *)tap.view;
    self.selectIndex=[im.flagStr intValue];
}
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    SET_PAR(_backgroundImage, backgroundImage);
    if (!backgroundImageView)
    {
        backgroundImageView=[[YJImageView alloc] initWithFrame:self.bounds];
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
    }
    backgroundImageView.image=_backgroundImage;
}
-(id)initWithItemArray:(NSArray *)items
{
    if (self=[super initWithFrame:TAB_BAR_RECT])
    {
        _items=[items retain];
        [self createTabBarView];
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_backgroundImage release];
    [_items release];
    [super dealloc];
}
@end

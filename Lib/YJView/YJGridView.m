//
//  YJGirdView.m
//  iService
//
//  Created by szfore on 13-5-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJGridView.h"
@implementation YJGridView
-(void)createViewInYJGridView
{
    if (!contentView)
    {
        contentView=[[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        [contentView release];
    }
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float contentHeight=0;
    int count=[self.dataSource_grid getGridItemCount:self];
    for (int i=0; i<count; i++)
    {
        CGRect frame=[self.dataSource_grid getFrameWithIndex:i gridView:self];
        __block typeof(self)bSelf=self;
        YJButton *item=[[YJButton alloc] initWithFrame:frame event:^(YJButton*bu){
            [bSelf handleWithSelectItemAtIndex:i];
        }];
        UIImage *defaultImage=nil,*selctedImage=nil;
        [self.dataSource_grid getImageWithIndex:i gridView:self defaultImage:&defaultImage selectedImage:&selctedImage];
        [item setImage:defaultImage forYJButtonStatus:kYJButtonStatusDefault];
        [item setImage:selctedImage forYJButtonStatus:kYJButtonStatusSelected];
        item.flagStr=[NSString stringWithFormat:@"YJGridItem_%d",i];
        [contentView addSubview:item];
        [item release];
        
        if (i==count-1) contentHeight=frame.size.height+frame.origin.y;
    }
    contentView.contentSize=CGSizeMake(contentView.frame.size.width, contentHeight);
}
-(void)handleWithSelectItemAtIndex:(int)index
{
    if ([self.delegate_grid respondsToSelector:@selector(selectGridItemAtIndex:gridView:)])
    {
        [self.delegate_grid selectGridItemAtIndex:index gridView:self];
    }
}
-(void)setDataSource_grid:(id<YJGridViewDataSource>)dataSource_grid
{
    _dataSource_grid=dataSource_grid;
    [self createViewInYJGridView];
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
@end

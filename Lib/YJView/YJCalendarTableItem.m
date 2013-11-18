//
//  YJCalendarTableItem.m
//  YJSwear
//
//  Created by zhongyy on 13-9-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCalendarTableItem.h"
@interface YJCalendarTableItem()
{
    UILabel *la;
    UILabel *left;
}
@end    
@implementation YJCalendarTableItem
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame flagStr:flagStr])
    {
        la=[[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:la];
        [la release];
    }
    return self;
}
-(void)setLeftHeight:(int)leftHeight
{
    _leftHeight=leftHeight;
    if (!left) {
        left=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, _leftHeight)];
        left.backgroundColor=[UIColor redColor];
        [self addSubview:left];
        [left release];
    }
    left.frame=CGRectMake(0, 50, 50, _leftHeight);
}
-(void)setIndex:(int)index
{
    _index=index;
    la.text=[NSString stringWithFormat:@"%d",index];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
@end

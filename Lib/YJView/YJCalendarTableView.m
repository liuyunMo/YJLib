//
//  YJCalendarTableView.m
//  YJSwear
//
//  Created by zhongyy on 13-9-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCalendarTableView.h"
@interface YJCalendarTableView()<UIScrollViewDelegate>
{
    UIScrollView *sc;
    NSMutableSet *items;
    int itemCount;
    int createCount;
    int currentIndex;
    float lastOffSetX;
}
@end
@implementation YJCalendarTableView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        items=OBJ_CREATE(NSMutableSet);
        [self createView];
    }
    return self;
}
-(void)createView
{
    if (!sc) {
        sc=[[UIScrollView alloc] initWithFrame:self.bounds];
        sc.delegate=self;
        sc.backgroundColor=[UIColor clearColor];
        sc.showsHorizontalScrollIndicator=NO;
        sc.showsVerticalScrollIndicator=NO;
        [self addSubview:sc];
        [sc release];
    }
}
-(void)setDelegate:(id<YJCalendarTableViewDelegate>)delegate
{
    _delegate=delegate;
    itemCount=[self.delegate numberForItemInCalendarTableView:self];
    [sc setContentSize:CGSizeMake(itemCount*ITEM_WIDTH, self.frame.size.height)];
    createCount=self.frame.size.width/ITEM_WIDTH+1;
    for (int i=0; i<createCount; i++)
    {
        YJCalendarTableItem *item=[self.delegate calendarTableView:self getItemWithIndex:i];
        item.index=i;
        item.frame=CGRectMake(ITEM_WIDTH*i, 0, ITEM_WIDTH, sc.frame.size.height);
        [sc addSubview:item];
        [items addObject:item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x=(sc.frame.size.width+scrollView.contentOffset.x)/ITEM_WIDTH;
    if (x!=currentIndex) {
        
        BOOL leftSwipe=(lastOffSetX-scrollView.contentOffset.x>0.0f);
        lastOffSetX=scrollView.contentOffset.x;
        
        currentIndex=x;
        
        if (leftSwipe) {
            YJCalendarTableItem *lastItem=[self getItemWithIndex:currentIndex+2];
            if (lastItem) {
                [lastItem removeFromSuperview];
            }
            int preX=currentIndex-createCount;
            if (preX>=0) {
                YJCalendarTableItem *preItem=[self.delegate calendarTableView:self getItemWithIndex:preX];
                preItem.index=preX;
                preItem.frame=CGRectMake(ITEM_WIDTH*preX, 0, ITEM_WIDTH, sc.frame.size.height);
                [sc addSubview:preItem];
                [items addObject:preItem];
            }
        }else{
            YJCalendarTableItem *firstItem=[self getItemWithIndex:currentIndex-createCount-1];
            if (firstItem) {
                [firstItem removeFromSuperview];
            }
            if (currentIndex<itemCount) {
                YJCalendarTableItem *item=[self.delegate calendarTableView:self getItemWithIndex:currentIndex];
                item.index=currentIndex;
                item.frame=CGRectMake(ITEM_WIDTH*x, 0, ITEM_WIDTH, sc.frame.size.height);
                [sc addSubview:item];
                [items addObject:item];
            }
        }
    }
}
-(YJCalendarTableItem *)getItemWithIndex:(int)index
{
    for (YJCalendarTableItem *item in sc.subviews) {
        if (item.index==index) {
            return item;
        }
    }
    return nil;
}
-(YJCalendarTableItem *)getItemNoShowWithFlag:(NSString *)flag
{
    for (YJCalendarTableItem *item in items) {
        if ([item.flagStr isEqualToString:flag]&&item.superview==nil) {
            NSLog(@"fu yong  %d",item.index);
            return item;
        }
    }
    return nil;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [items release];
    [super dealloc];
}
@end

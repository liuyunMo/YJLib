//
//  YJCalendarTableView.h
//  YJSwear
//
//  Created by zhongyy on 13-9-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCalendarTableItem.h"
#define ITEM_WIDTH 50
@protocol YJCalendarTableViewDelegate;
@interface YJCalendarTableView : YJFlagView
@property(nonatomic,assign)id<YJCalendarTableViewDelegate>delegate;
-(YJCalendarTableItem *)getItemNoShowWithFlag:(NSString *)flag;
@end
@protocol YJCalendarTableViewDelegate <NSObject>
-(int)numberForItemInCalendarTableView:(YJCalendarTableView*)calendarTabView;
-(YJCalendarTableItem *)calendarTableView:(YJCalendarTableView*)calendarTabView getItemWithIndex:(int)index;
@optional
-(void)calendarTableView:(YJCalendarTableView*)calendarTabView willShowItemAtIndex:(int)index;
@end
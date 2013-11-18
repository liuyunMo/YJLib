//
//  YJCalendar.h
//  YJSwear
//
//  Created by zhongyy on 13-8-29.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlagView.h"
enum  {
    kCalendarTypeNormal = 0,
    kCalendarTypeScroll
};
typedef NSUInteger YJCalendarType;
struct YJIndexPath {
    int row;
    int index;
};
typedef struct YJIndexPath YJIndexPath;
@class YJCalendarCell;
@protocol YJCalendarDelegate;
@interface YJCalendar : YJFlagView
@property(nonatomic,readonly)int year;
@property(nonatomic,readonly)int month;
@property(nonatomic,readonly)YJCalendarType type;
@property(nonatomic,assign)id<YJCalendarDelegate>delegate;
-(void)showYear:(int)year month:(int)month;
-(void)changeToType:(YJCalendarType)type animation:(BOOL)animation;
@end
@protocol YJCalendarDelegate <NSObject>
@optional
-(void)calenderView:(YJCalendar *)calenderView withChangeToHeight:(float)toHeight withTime:(float)time;
//-(void)calenderView:(YJCalendar *)calenderView selectCell:(YJCalendarCell *)cell location:(int)location;
-(void)calenderView:(YJCalendar *)calenderView selectDay:(int)day;
-(int)calenderView:(YJCalendar *)calenderView getDotCountForDay:(int)day;
-(void)calenderView:(YJCalendar *)calenderView changeToYearFinish:(int)year month:(int)month;
@end

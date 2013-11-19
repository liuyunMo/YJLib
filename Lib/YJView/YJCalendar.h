
/*
 
 version : 2013.11.19
 
 增加 reloadData方法
 增加选中日期的显示
 去除YJCalendar type属性
 
 */
#import "YJFlagView.h"
@class YJCalendarCell;
@protocol YJCalendarDelegate;


@interface YJCalendar : YJFlagView
@property(nonatomic,readonly)int year;
@property(nonatomic,readonly)int month;
@property(nonatomic,assign)int selectDay;
@property(nonatomic,assign)id<YJCalendarDelegate>delegate;
-(void)showYear:(int)year month:(int)month;
-(void)reloadData;
@end
@protocol YJCalendarDelegate <NSObject>

@optional
-(void)calendarView:(YJCalendar *)calenderView withChangeToHeight:(float)toHeight withTime:(float)time;
-(void)calendarView:(YJCalendar *)calenderView selectDay:(int)day;
-(void)calendarView:(YJCalendar *)calenderView drawDayRectFinish:(int)day rect:(CGRect)rect ctx:(CGContextRef)ctx;
-(void)calendarView:(YJCalendar *)calenderView changeToYearFinish:(int)year month:(int)month;
-(UIImage*)getSelectDayImage:(YJCalendar *)calenderView;
@end

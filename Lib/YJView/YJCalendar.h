
/*
 
 version : 2013.11.25

 增加  左右滑动手势  左右切换月份
 
 */
#import "YJFlagView.h"

#define ANIMATION_TIME_CALENDAR .5

@class YJCalendarCell;
@protocol YJCalendarDelegate;



@interface YJCalendar : YJFlagView
@property(nonatomic,readonly)int year;
@property(nonatomic,readonly)int month;
@property(nonatomic,assign)int selectDay;
@property(nonatomic,assign)id<YJCalendarDelegate>delegate;
@property(nonatomic,assign)BOOL resignDefautGes;//取消默认手势,左右滑动切换月份
-(void)showYear:(int)year month:(int)month;//垂直方向动画
-(void)gotoYear:(int)year month:(int)month animation:(BOOL)animation;//垂直方向动画
-(void)reloadData;
@end
@protocol YJCalendarDelegate <NSObject>

@optional
-(void)calendarView:(YJCalendar *)calendarView willChangeToHeight:(float)toHeight withTime:(float)time;
-(void)calendarView:(YJCalendar *)calendarView willShowYear:(int)year month:(int)month;
-(void)calendarView:(YJCalendar *)calendarView selectDay:(int)day;
-(void)calendarView:(YJCalendar *)calendarView drawDayRectFinish:(int)day rect:(CGRect)rect ctx:(CGContextRef)ctx;
-(void)calendarView:(YJCalendar *)calendarView changeToYearFinish:(int)year month:(int)month;
-(UIImage*)getSelectDayImage:(YJCalendar *)calendarView;
@end

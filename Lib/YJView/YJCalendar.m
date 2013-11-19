//
//  YJCalendar.m
//  YJSwear
//
//  Created by zhongyy on 13-8-29.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCalendar.h"
#import "YJCalendarCell.h"
#import "YJCalendarTableView.h"
#define CELL_HEIGHT 30
@interface YJCalendar ()<YJCalendarCellDelegate>
{
    float currentHeight;
    float beginHeight;
    UIImageView *selectedIm;
}
@property(nonatomic,retain)NSMutableArray *dayArr;
@end
@implementation YJCalendar
-(void)createCalendarView
{
    YJCalendarCell *cell=[[YJCalendarCell alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    cell.backgroundColor=[UIColor whiteColor];
    cell.index=100;
    cell.titils=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    [self addSubview:cell];
    [cell release];
    
    beginHeight=20;
    currentHeight=beginHeight;
}

-(void)reloadData
{
    [selectedIm removeFromSuperview];
    selectedIm=nil;
    [self showYear:self.year month:self.month];
    self.selectDay=_selectDay;
}
-(void)showYear:(int)year month:(int)month
{
    _year=year;_month=month;
    [selectedIm removeFromSuperview];
    
    float conBeginHeight=currentHeight-beginHeight;
    float sizeHeight=0;
    
    if (self.dayArr) {
        [self.dayArr removeAllObjects];
    }else{
        self.dayArr=[NSMutableArray array];
    }
    int index=0;
    NSDateFormatter *formatter=OBJ_CREATE(NSDateFormatter);
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateString=[NSString stringWithFormat:@"%d-%d-01 08:00",year,month];
    NSDate *date=[formatter dateFromString:dateString];
    
    
    NSDateComponents *com=[[NSCalendar currentCalendar] components:kCFCalendarUnitWeekday fromDate:date];
    int week=com.weekday;
    int dayCount=31;
    if (month==2) {
        dayCount=(year%100!=0&&year%4==0)?29:28;
    }else if (month==4||month==6||month==9||month==11){
        dayCount=30;
    }
    [formatter setDateFormat:@"dd"];
    NSString *lastDay=[formatter stringFromDate:[NSDate dateWithTimeInterval:-24*3600 sinceDate:date]];
    
    //first
    NSMutableArray *firstWeek=[NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    for (int i=0; i<week-1; i++) {
        firstWeek[week-1-i-1]=[NSString stringWithFormat:@"%d",[lastDay intValue]-i];
    }
    int currentDay=1;
    for (int i=week-1; i<7; i++)
    {
        firstWeek[i]=[NSString stringWithFormat:@"%d",currentDay];
        currentDay++;
    }
    [self.dayArr addObject:firstWeek];
    
    YJCalendarCell *firstCell=[[YJCalendarCell alloc] initWithFrame:CGRectMake(0, currentHeight, self.frame.size.width, 30)];
    firstCell.index=index;
    firstCell.backgroundColor=[UIColor clearColor];
    firstCell.type=kCalendarCellTypeFirstWeek;
    firstCell.delegate=self;
    firstCell.titils=firstWeek;
    [self insertSubview:firstCell atIndex:0];
    [firstCell release];
    
    currentHeight+=30;
    sizeHeight+=30;
    
    do {
        NSMutableArray *weeks=[NSMutableArray arrayWithCapacity:7];
        [weeks addObject:[NSString stringWithFormat:@"%d",currentDay]];
        for (int i=0; i<6; i++) {
            [weeks addObject:[NSString stringWithFormat:@"%d",currentDay+i+1]];
        }
        [self.dayArr addObject:weeks];
        
        index++;
        YJCalendarCell *cell=[[YJCalendarCell alloc] initWithFrame:CGRectMake(0, currentHeight, self.frame.size.width, 30)];
        cell.index=index;
        cell.backgroundColor=[UIColor clearColor];
        cell.titils=weeks;
        cell.delegate=self;
        [self insertSubview:cell atIndex:0];
        [cell release];
        
        currentHeight+=30;
        sizeHeight+=30;
        
        currentDay+=7;
    } while (currentDay<=dayCount-7);
    
    
    //last
    NSMutableArray *lastWeek=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        if (currentDay>dayCount) {
            currentDay=currentDay-dayCount;
        }
        [lastWeek addObject:[NSString stringWithFormat:@"%d",currentDay]];
        currentDay++;
    }
    [self.dayArr addObject:lastWeek];
    
    index++;
    YJCalendarCell *lastCell=[[YJCalendarCell alloc] initWithFrame:CGRectMake(0, currentHeight, self.frame.size.width, 30)];
    lastCell.index=index;
    lastCell.delegate=self;
    lastCell.backgroundColor=[UIColor clearColor];
    lastCell.titils=lastWeek;
    lastCell.type=kCalendarCellTypeLastWeek;
    [self insertSubview:lastCell atIndex:0];
    [lastCell release];
    
    currentHeight+=30;
    sizeHeight+=30;
    
    [formatter release];
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(calendarView:withChangeToHeight:withTime:)]) {
        [self.delegate calendarView:self withChangeToHeight:sizeHeight+beginHeight withTime:.5];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect =self.frame;
        rect.size.height=sizeHeight+beginHeight;
        self.frame=rect;
        
        for (YJCalendarCell *calendarCell in self.subviews)
        {
            if ([calendarCell isKindOfClass:[YJCalendarCell class]]&&calendarCell.index!=100)
            {
                CGRect cellRect=calendarCell.frame;
                cellRect.origin.y-=conBeginHeight;
                calendarCell.frame=cellRect;
            }
        }
    } completion:^(BOOL finish)
     {
         if (finish) {
             
             currentHeight=beginHeight+sizeHeight;
             
             
             for (YJCalendarCell *calendarCell in self.subviews)
             {
                 if ([calendarCell isKindOfClass:[YJCalendarCell class]]&&calendarCell.index!=100)
                 {
                     if (calendarCell.frame.origin.y<beginHeight||calendarCell.frame.origin.y>=currentHeight)
                     {
                         [calendarCell removeFromSuperview];
                     }
                 }
             }
             
             
             if ([self.delegate respondsToSelector:@selector(calendarView:changeToYearFinish:month:)])
             {
                 [self.delegate calendarView:self changeToYearFinish:_year month:_month];
             }
             
             selectedIm=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320/7.0, 30)];
             selectedIm.hidden=YES;
             UIImage *image=nil;
             if ([self.delegate respondsToSelector:@selector(getSelectDayImage:)]) {
                 image=[self.delegate getSelectDayImage:self];
             }else{
                 image=getNavBarItemDefaultBackgroupImage();
             }
             selectedIm.image=image;
             [self insertSubview:selectedIm atIndex:0];
             [selectedIm release];
             
             self.selectDay=_selectDay;
         }
         
     
     }];
    
}
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame])
    {
        [self createCalendarView];
        self.clipsToBounds=YES;
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
-(void)setSelectDay:(int)selectDay
{
    if (selectDay>31||selectDay<1) {
        return;
    }
    _selectDay=selectDay;
    signed int index=-1;
    signed int location=-1;
    
    for (int i=_selectDay>8?1:0; i<self.dayArr.count; i++)
    {
        NSArray *weeks=[self.dayArr objectAtIndex:i];
        for (int j=0; j<weeks.count; j++)
        {
            int day=[[weeks objectAtIndex:j] intValue];
            if (day==_selectDay)
            {
                index=i;
                location=j;
                goto endCircle;
            }
        }
    }
endCircle:
    if (index!=-1&&location!=-1)
    {
        selectedIm.hidden=NO;
        CGRect rect=selectedIm.frame;
        rect.origin.y=index*30+20;
        rect.origin.x=location*320/7.0;
        selectedIm.frame=rect;
        
        if ([self.delegate respondsToSelector:@selector(calendarView:selectDay:)])
        {
            [self.delegate calendarView:self selectDay:_selectDay];
        }
    }
}
-(void)selectCalendarCell:(YJCalendarCell *)cell atLocation:(int)location
{
    NSArray *week=[self.dayArr objectAtIndex:cell.index];
    NSString *day=[week objectAtIndex:location];
    
    _selectDay=[day intValue];
    switch (cell.type) {
        case kCalendarCellTypeFirstWeek:
            if([day intValue]>8)
            {
                int month=_month-1;
                int year=_year;
                if (month<1) {
                    month=12;
                    year-=1;
                }
                
                [self showYear:year month:month];
                return;
            }
            break;
        case kCalendarCellTypeNormal:
            
            break;
        case kCalendarCellTypeLastWeek:
            if([day intValue]<8)
            {
                int month=_month+1;
                int year=_year;
                if (month>12) {
                    month=1;
                    year+=1;
                }
                [self showYear:year month:month];
                
                return;
            }
            break;
        default:
            break;
    }
    
    
    selectedIm.hidden=NO;
    CGRect rect=selectedIm.frame;
    rect.origin.y=cell.index*30+20;
    rect.origin.x=location*320/7.0;
    selectedIm.frame=rect;
   
    if ([self.delegate respondsToSelector:@selector(calendarView:selectDay:)]) {
        [self.delegate calendarView:self selectDay:[day intValue]];
    }
    
}
-(void)drawEnd:(YJCalendarCell *)cell atLocation:(int)location withRect:(CGRect)rect ctx:(CGContextRef)ctx
{
    NSArray *week=[self.dayArr objectAtIndex:cell.index];
    NSString *day=[week objectAtIndex:location];
    if (cell.type==kCalendarCellTypeFirstWeek&&[day intValue]>8) {
        return;
    }
    if (cell.type==kCalendarCellTypeLastWeek&&[day intValue]<8) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(calendarView:drawDayRectFinish:rect:ctx:)])
    {
        [self.delegate calendarView:self drawDayRectFinish:[day intValue] rect:rect ctx:ctx];
    }
}
@end

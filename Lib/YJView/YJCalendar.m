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
@interface YJCalendar ()<YJCalendarCellDelegate,YJCalendarTableViewDelegate>
{
    float currentHeight;
    float beginHeight;
    UIImageView *selectedIm;
}
@property(nonatomic,retain)NSMutableArray *dayArr;
@end
@implementation YJCalendar
-(void)createCalenderView
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
-(void)changeToType:(YJCalendarType)type animation:(BOOL)animation
{
    if (_type!=type) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _type=type;
        if (_type==kCalendarTypeNormal) {
            [self createCalenderView];
            [self showYear:self.year month:self.month];
        }else{
            currentHeight=50-beginHeight;
            
            YJCalendarTableView *view=[[YJCalendarTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            view.delegate=self;
            [self addSubview:view];
            [view release];
        }
        [UIView animateWithDuration:animation*.25 animations:^{
            CGRect rect =self.frame;
            rect.size.height=beginHeight+currentHeight;
            self.frame=rect;
        }];
        if ([self.delegate respondsToSelector:@selector(calenderView:withChangeToHeight:withTime:)]) {
            [self.delegate calenderView:self withChangeToHeight:currentHeight+beginHeight withTime:animation*.25];
        }
    }
}

-(void)showYear:(int)year month:(int)month
{
    _year=year;_month=month;
    
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
        [self.dayArr addObject:lastWeek];
    }
    
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
    
    [selectedIm removeFromSuperview];
    
    selectedIm=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320/7.0, 30)];
    selectedIm.hidden=YES;
    selectedIm.image=[UIImage imageNamed:@"selectDay.png"];
    [self insertSubview:selectedIm atIndex:0];
    [selectedIm release];
    
    
    if ([self.delegate respondsToSelector:@selector(calenderView:withChangeToHeight:withTime:)]) {
        [self.delegate calenderView:self withChangeToHeight:sizeHeight+beginHeight withTime:.5];
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
             
             
             if ([self.delegate respondsToSelector:@selector(calenderView:changeToYearFinish:month:)])
             {
                 [self.delegate calenderView:self changeToYearFinish:_year month:_month];
             }
         }
         
     
     }];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.clipsToBounds=YES;
        [self createCalenderView];
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
-(void)selectCalendarCell:(YJCalendarCell *)cell atLocation:(int)location
{
    NSArray *week=[self.dayArr objectAtIndex:cell.index];
    NSString *day=[week objectAtIndex:location];
    
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
    if ([self.delegate respondsToSelector:@selector(calenderView:selectDay:)]) {
        [self.delegate calenderView:self selectDay:[day intValue]];
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
    NSArray *colors=@[[UIColor brownColor],[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor]];
    int count=0;
    if ([self.delegate respondsToSelector:@selector(calenderView:getDotCountForDay:)])
    {
        count=[self.delegate calenderView:self getDotCountForDay:[day intValue]];
    }
    count=count>5?5:count;
    float arcWidth=4;
    float span =4;
    float beginX=(rect.size.width-span*(count-1)-arcWidth*count)/2;
    for (int i=0; i<count; i++)
    {
        CGContextSaveGState(ctx);
        [(UIColor *)[colors objectAtIndex:i] setFill];
        CGContextAddEllipseInRect(ctx, CGRectMake(beginX+(arcWidth+span)*i+location*rect.size.width, rect.size.height-8, arcWidth, arcWidth));
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextRestoreGState(ctx);
    }
}
-(int)numberForItemInCalendarTableView:(YJCalendarTableView*)calendarTabView
{
    return 30;
}
-(YJCalendarTableItem *)calendarTableView:(YJCalendarTableView*)calendarTabView getItemWithIndex:(int)index
{
    YJCalendarTableItem *item=[calendarTabView getItemNoShowWithFlag:@"item_calendar"];
    if (!item) {
        item=[[[YJCalendarTableItem alloc] initWithFrame:CGRectMake(0, 0, 50, 50) flagStr:@"item_calendar"] autorelease];
    }
    return item;
}
-(void)calendarTableView:(YJCalendarTableView*)calendarTabView willShowItemAtIndex:(int)index
{
    NSLog(@"%d",index);
}
@end

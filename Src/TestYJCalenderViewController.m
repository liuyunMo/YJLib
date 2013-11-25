//
//  TestYJCalenderViewController.m
//  YJLib
//
//  Created by zhongyy on 13-11-19.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "TestYJCalenderViewController.h"
#import "YJCalendar.h"
@interface TestYJCalenderViewController ()<YJCalendarDelegate>
{
    YJCalendar *calendar;
    UILabel *la;
}
@end

@implementation TestYJCalenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    la=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    la.textColor=[UIColor redColor];
    la.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:la];
    [la release];
    
    calendar=[[YJCalendar alloc] initWithFrame:CGRectMake(0, 30, 320, 200) flagStr:@"calendar"];
    calendar.delegate=self;
    [calendar showYear:2013 month:10];
    calendar.selectDay=1;
    [self.view addSubview:calendar];
    [calendar release];
    
    UIButton *bu=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bu setTitle:@"刷新" forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(refCalendar) forControlEvents:UIControlEventTouchUpInside];
    bu.frame=CGRectMake(0, 0, 80, 30);
    bu.center=CGPointMake(160, 260);
    [self.view addSubview:bu];
}
-(void)refCalendar
{
    [calendar reloadData];
    la.text=[NSString stringWithFormat:@"%d-%d-%d",calendar.year,calendar.month,calendar.selectDay];
}
-(void)calendarView:(YJCalendar *)calenderView selectDay:(int)day
{
    la.text=[NSString stringWithFormat:@"%d-%d-%d",calendar.year,calendar.month,calendar.selectDay];
}
-(void)calendarView:(YJCalendar *)calenderView drawDayRectFinish:(int)day rect:(CGRect)rect ctx:(CGContextRef)ctx
{
    NSArray *colors=@[[UIColor brownColor],[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor]];
    int count=arc4random()%6;
    float arcWidth=4;
    float span =4;
    float beginX=(rect.size.width-span*(count-1)-arcWidth*count)/2;
    for (int i=0; i<count; i++)
    {
        CGContextSaveGState(ctx);
        [(UIColor *)[colors objectAtIndex:i] setFill];
        CGContextAddEllipseInRect(ctx, CGRectMake(beginX+(arcWidth+span)*i+rect.origin.x, rect.size.height-8, arcWidth, arcWidth));
        CGContextDrawPath(ctx, kCGPathFill);
        CGContextRestoreGState(ctx);
    }
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
@end

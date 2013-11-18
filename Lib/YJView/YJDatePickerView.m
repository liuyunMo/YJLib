//
//  YJDatePickerView.m
//  YJSwear
//
//  Created by zhongyy on 13-8-26.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJDatePickerView.h"
#define MIN_YEAR 2013
#define YEAR_COUNT 20
@interface YJDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,YJNavBarDelegate>
{
    YJFlagView *flagView;
    NSMutableArray *dataArr;
}
@property(nonatomic,copy)NSString *yearStr;
@property(nonatomic,copy)NSString *monthStr;
@property(nonatomic,copy)NSString *dayStr;
@property(nonatomic,copy)NSString *hourStr;
@property(nonatomic,copy)NSString *minuteStr;
@end
@implementation YJDatePickerView
-(void)showInView:(UIView *)view aniamtion:(BOOL)animation
{
    [self retain];
    dataArr=[[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *years=[NSMutableArray array];
    for (int i=0; i<YEAR_COUNT; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d年",MIN_YEAR+i]];
    }
    [years addObject:@"一辈子"];
    [years addObject:@"一万年"];
    [dataArr addObject:years];
    self.yearStr=[NSString stringWithFormat:@"%d",MIN_YEAR];
    
    
    NSMutableArray *months=[NSMutableArray array];
    for (int i=0; i<12; i++)
    {
        [months addObject:[NSString stringWithFormat:@"%d月",1+i]];
    }
    [dataArr addObject:months];
    self.monthStr=@"1";
    
    
    NSMutableArray *days=[NSMutableArray array];
    for (int i=0; i<31; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%d日",i+1]];
    }
    [dataArr addObject:days];
    self.dayStr=@"1";
    
    NSMutableArray *hours=[NSMutableArray array];
    for (int i=0; i<24; i++) {
        NSString *str=[NSString stringWithFormat:@"00%d",i];
        [hours addObject:[str substringWithRange:NSMakeRange(str.length-2, 2)]];
    }
    [dataArr addObject:hours];
    self.hourStr=@"00";
    
    NSMutableArray *minutes=[NSMutableArray array];
    for (int i=0; i<60; i++) {
        NSString *str=[NSString stringWithFormat:@"00%d",i];
        [minutes addObject:[str substringWithRange:NSMakeRange(str.length-2, 2)]];
    }
    [dataArr addObject:minutes];
    self.minuteStr=@"00";
    
    flagView=[[YJFlagView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, 320, 220) flagStr:@"YJDatePickerView"];
    [view addSubview:flagView];
    [flagView release];
    
    YJNavBar *nav=[[YJNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) flagStr:@"YJDatePicker_nav"];
    nav.delegate_navBar=self;
    nav.backgroundImage=[UIImage imageNamed:@"picker_nav.png"];
    //nav.showLeftItem=YES;
    nav.showRightItem=YES;
    //[nav setUpLeftItemTitle:@"取消"];
    [nav setUpRightItemTitle:@"确定"];
    [flagView addSubview:nav];
    [nav release];
    
    
    UIPickerView *picker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 176)];
    picker.delegate=self;
    picker.dataSource=self;
    picker.backgroundColor=[UIColor redColor];
    picker.showsSelectionIndicator=YES;
    [flagView addSubview:picker];
    [picker release];
    
    [UIView animateWithDuration:animation*.25 animations:^{
        CGRect rect=flagView.frame;
        rect.origin.y=view.frame.size.height-200;
        flagView.frame=rect;
    }];
    
    if (self.date) {
        NSDateComponents *com=[[NSCalendar currentCalendar] components:kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute fromDate:self.date];
        [picker selectRow:com.year-MIN_YEAR inComponent:0 animated:YES];
        NSString *yearStr=[years objectAtIndex:com.year-MIN_YEAR];
        self.yearStr=[yearStr substringToIndex:yearStr.length-1];
        [picker selectRow:com.month-1 inComponent:1 animated:YES];
        NSString *monthStr=[months objectAtIndex:com.month-1];
        self.monthStr=[monthStr substringToIndex:monthStr.length-1];
        [picker selectRow:com.day-1 inComponent:2 animated:YES];
        NSString *dayStr=[days objectAtIndex:com.day-1];
        self.dayStr=[dayStr substringToIndex:dayStr.length-1];
        [picker selectRow:com.hour inComponent:3 animated:YES];
        self.hourStr=[hours objectAtIndex:com.hour];
        [picker selectRow:com.minute inComponent:4 animated:YES];
        self.minuteStr=[minutes objectAtIndex:com.minute];
    }
}
-(void)dissmissAnimation:(BOOL)animation
{
    __block typeof(self)bSelf=self;
    [UIView animateWithDuration:animation*.25 animations:^{
        CGRect rect=flagView.frame;
        rect.origin.y=flagView.superview.frame.size.height;
        flagView.frame=rect;
    } completion:^(BOOL finish){
        if (finish) {
            [flagView removeFromSuperview];
            [bSelf release];
        }
    }];
}
-(void)setFinishBlock:(YJResBlock)finishBlock
{
    SET_BLOCK(_finishBlock, finishBlock);
}
-(void)setSelectTime:(TimeSelect)selectTime
{
    SET_BLOCK(_selectTime, selectTime);
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_finishBlock);
    SAFE_BLOCK_RELEASE(_selectTime);
    [_yearStr release];
    [_monthStr release];
    [_dayStr release];
    [_hourStr release];
    [_minuteStr release];
    [dataArr release];
    [super dealloc];
}
-(void)leftItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    [self dissmissAnimation:YES];
}
-(void)rightItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    __block typeof(self)bSelf=self;
    [self dissmissAnimation:YES];
    if (_finishBlock) {
        _finishBlock(bSelf,nil);
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return dataArr.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[dataArr objectAtIndex:component] count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *currArr=[dataArr objectAtIndex:component];
    switch (component) {
        case 0:
        {
            switch (row) {
                case YEAR_COUNT:
                    self.yearStr=@"一辈子";
                    if (self.selectTime) _selectTime(self.yearStr);
                    return;
                case YEAR_COUNT+1:
                    self.yearStr=@"一万年";
                    if (self.selectTime) _selectTime(self.yearStr);
                    return;
                default:
                {
                    int year=MIN_YEAR+row;
                    self.yearStr=[NSString stringWithFormat:@"%d",year];
                    if ([self.monthStr intValue]!=2) break;
                    NSMutableArray *arr=[dataArr objectAtIndex:2];//日期
                    [arr removeAllObjects];
                    int dayCount=(year%100!=0&&year%4==0)?29:28;
                    for (int i=0; i<dayCount; i++)
                    {
                        [arr addObject:[NSString stringWithFormat:@"%d日",i+1]];
                    }
                    [pickerView reloadComponent:2];
                    [pickerView selectRow:0 inComponent:2 animated:YES];
                    self.dayStr=@"1";
                }
                    break;
            }
        }
            break;
        case 1:
        {
            self.monthStr=[NSString stringWithFormat:@"%d",row+1];
            int year=[self.yearStr intValue];
            if (year-MIN_YEAR>=YEAR_COUNT) break;//坑爹的一万年和一辈子
            NSMutableArray *arr=[dataArr objectAtIndex:2];//日期
            [arr removeAllObjects];
            int dayCount=0;
            switch (row) {
                    /* 小月*/
                case 3:
                case 5:
                case 8:
                case 10:
                {
                    dayCount=30;
                }
                    break;
                    /*二月*/
                case 1:
                {
                    dayCount=(year%100!=0&&year%4==0)?29:28;
                }
                    break;
                    
                default:
                {
                    dayCount=31;
                }
                    break;
            }
            for (int i=0; i<dayCount; i++)
            {
                [arr addObject:[NSString stringWithFormat:@"%d日",i+1]];
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            self.dayStr=@"1";
        }
            break;
        case 2:
            self.dayStr=[NSString stringWithFormat:@"%d",row+1];
            break;
        case 3:
            self.hourStr=[currArr objectAtIndex:row];
            break;
        case 4:
            self.minuteStr=[currArr objectAtIndex:row];
            break;
            
        default:
            break;
    }
    NSString *timeStr=nil;
    if ([self.yearStr isEqualToString:@"一辈子"]||[self.yearStr isEqualToString:@"一万年"]) {
        timeStr=self.yearStr;
    }else{
        timeStr=[NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.yearStr,self.monthStr,self.dayStr,self.hourStr,self.minuteStr];
    }
    if (self.selectTime) {
        _selectTime(timeStr);
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *la=(UILabel *)view;
    if(!la)
    {
        la=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
        la.font=[UIFont systemFontOfSize:13];
        la.textAlignment=UITextAlignmentCenter;
        la.backgroundColor=[UIColor clearColor];
    }
    NSArray *titles=[dataArr objectAtIndex:component];
    la.text=[titles objectAtIndex:row];
    return la;
}
@end

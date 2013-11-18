//
//  YJCalendarCell.h
//  YJSwear
//
//  Created by zhongyy on 13-9-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
enum {
    kCalendarCellTypeNormal = 0,
    kCalendarCellTypeFirstWeek = 1,
    kCalendarCellTypeLastWeek = 2
    };
typedef NSUInteger YJCalendarCellType;
#import "YJFlagView.h"
@protocol YJCalendarCellDelegate;
@interface YJCalendarCell : YJFlagView
@property(nonatomic,assign)int index;
@property(nonatomic,retain)NSArray *titils;
@property(nonatomic,assign)YJCalendarCellType type;
@property(nonatomic,assign)id<YJCalendarCellDelegate>delegate;
@end
@protocol YJCalendarCellDelegate <NSObject>
@optional
-(void)selectCalendarCell:(YJCalendarCell *)cell atLocation:(int)location;
-(void)drawEnd:(YJCalendarCell *)cell atLocation:(int)location withRect:(CGRect)rect ctx:(CGContextRef)ctx;
@end
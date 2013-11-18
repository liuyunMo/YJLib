//
//  YJCalendarCell.m
//  YJSwear
//
//  Created by zhongyy on 13-9-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCalendarCell.h"
#define FORN_FOR_TITLE [UIFont systemFontOfSize:15]
@interface YJCalendarCell ()
{
    float itemWidth;
    BOOL isMove;
}
@end
@implementation YJCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        itemWidth=frame.size.width/7;
    }
    return self;
}
-(void)setTitils:(NSArray *)titils
{
    if (titils.count<7) {
        [_titils release];
        _titils=nil;
    }
    SET_PAR(_titils, titils);
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_titils release];
    [super dealloc];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    if (self.titils.count>=7) {
        for (int i=0; i<7; i++) {
            CGContextSaveGState(ctx);
            NSString *title=[self.titils objectAtIndex:i];
            CGSize size=[title sizeWithFont:FORN_FOR_TITLE];
            float centerWidth=itemWidth/2+itemWidth*i;
            
            switch (self.type) {
                case kCalendarCellTypeNormal:
                    [[UIColor blackColor] setFill];
                    break;
                case kCalendarCellTypeFirstWeek:
                    if ([title intValue]>8) {
                        [[UIColor grayColor] setFill];
                    }else{
                        [[UIColor blackColor] setFill];
                    }
                    break;
                case kCalendarCellTypeLastWeek:
                    if ([title intValue]<8) {
                        [[UIColor grayColor] setFill];
                    }else{
                        [[UIColor blackColor] setFill];
                    }
                    break;
                default:
                    break;
            }
            CGRect titleRect=CGRectMake(centerWidth-size.width/2, 0, size.width, size.height-5);
            [title drawInRect:titleRect withFont:FORN_FOR_TITLE];
            CGContextRestoreGState(ctx);
            if ([self.delegate respondsToSelector:@selector(drawEnd:atLocation:withRect:ctx:)]) {
                [self.delegate drawEnd:self atLocation:i withRect:CGRectMake(itemWidth*i, 0, itemWidth, self.frame.size.height) ctx:ctx];
            }
        }
    }
    UIGraphicsPopContext();
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMove=NO;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isMove=YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isMove) {
        UITouch *touch=[touches anyObject];
        CGPoint p=[touch locationInView:self];
        if ([self.delegate respondsToSelector:@selector(selectCalendarCell:atLocation:)]) {
            [self.delegate selectCalendarCell:self atLocation:p.x/itemWidth];
        }
    }
}
@end

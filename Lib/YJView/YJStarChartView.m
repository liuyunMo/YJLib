//
//  YJStarChartView.m
//  YJLib
//
//  Created by zhongyy on 13-12-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJStarChartView.h"


#define B_WIDTH 4
#define N_WIDTH 1
@implementation YJStarChartView

- (void)drawRect:(CGRect)rect33
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGRect rect=CGRectMake(100, 100, 100, 100);
    CGRect rect1=CGRectMake(100+B_WIDTH/2, 100+B_WIDTH/2, 100-B_WIDTH, 100-B_WIDTH);
    CGRect rect2=CGRectMake(100+B_WIDTH/2+N_WIDTH/2, 100+B_WIDTH/2+N_WIDTH/2, 100-B_WIDTH-N_WIDTH, 100-B_WIDTH-N_WIDTH);
    
    CGContextSaveGState(ctx);
    [COLOR_WITH_RGBA(50, 50, 255, 127.5) setStroke];
    CGContextSetLineWidth(ctx, B_WIDTH);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, N_WIDTH);
    CGContextAddEllipseInRect(ctx, rect1);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    [[UIColor colorWithRed:0.161 green:0.604 blue:1.000 alpha:0.700] setFill];
    CGContextAddEllipseInRect(ctx, rect2);
    CGContextDrawPath(ctx, kCGPathFill);
    CGContextRestoreGState(ctx);
}


@end

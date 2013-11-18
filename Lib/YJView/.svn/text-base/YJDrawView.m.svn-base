//
//  YJDrawView.m
//  TestYJFramework
//
//  Created by szfore on 13-7-18.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJDrawView.h"
@interface YJDrawView()
{
    NSMutableArray *dots;
}
@end
@implementation YJDrawView
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if(self=[super initWithFrame:frame flagStr:flagStr])
    {
        dots=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [dots release];
    [super dealloc];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    for (NSArray *line in dots)
    {
        if (line.count<2) continue;
        CGPoint begin=[[line objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(ctx, begin.x, begin.y);
        for (int i=1; i<line.count; i++)
        {
            CGPoint point=[[line objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextRestoreGState(ctx);
}
-(NSArray *)getLines
{
    return dots;
}
#pragma mark -- touch event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dots)dots=[[NSMutableArray alloc] init];
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    NSMutableArray *line=[[NSMutableArray alloc] init];
    [line addObject:[NSValue valueWithCGPoint:point]];
    [dots addObject:line];
    [line release];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *line=[dots lastObject];
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    [line addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *line=[dots lastObject];
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    [line addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}
@end

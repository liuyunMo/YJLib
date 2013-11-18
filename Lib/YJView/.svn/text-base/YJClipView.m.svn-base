//
//  YJClipView.m
//  TestYJFramework
//
//  Created by szfore on 13-7-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJClipView.h"
struct YJClipPoint
{
    CGPoint leftTop,centerTop,rightTop;
    CGPoint leftCenter,       rightCenter;
    CGPoint leftBottom,centerBottom,rightBottom;
};
@interface YJClipView ()
{
    BOOL move;
}
@end
@implementation YJClipView
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame flagStr:flagStr])
    {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(UIBezierPath *)path
{
    return nil;
}
-(void)setClipRect:(CGRect)clipRect
{
    float x=clipRect.origin.x;
    float y=clipRect.origin.y;
    float width=clipRect.size.width;
    float height=clipRect.size.height;
    
    SAFE_FREE(points);
    
    points=(struct YJClipPoint*)malloc(sizeof(struct YJClipPoint));
    
    points->leftTop=CGPointMake(x, y);
    points->centerTop=CGPointMake(x+width/2, y);
    points->rightTop=CGPointMake(x+width, y);
    
    points->leftCenter=CGPointMake(x, y+height/2);
    points->rightCenter=CGPointMake(x+width, y+height/2);
    
    points->leftBottom=CGPointMake(x, y+height);
    points->centerBottom=CGPointMake(x+width/2, y+height);
    points->rightBottom=CGPointMake(x+width, y+height);
    [self setNeedsDisplay];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_FREE(points);
    [super dealloc];
}
- (void)drawRect:(CGRect)rect
{
    if (!points) return;
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, CLIP_LINE_COLOR.CGColor);
    CGContextSetLineWidth(ctx, CLIP_LINE_WIDTH);
    CGContextMoveToPoint(ctx, points->leftTop.x, points->leftTop.y);
    CGContextAddLineToPoint(ctx, points->rightTop.x, points->rightTop.y);
    CGContextAddLineToPoint(ctx, points->rightBottom.x, points->rightBottom.y);
    CGContextAddLineToPoint(ctx, points->leftBottom.x, points->leftBottom.y);
    CGContextAddLineToPoint(ctx, points->leftTop.x, points->leftTop.y);
    CGContextDrawPath(ctx, kCGPathStroke);
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [[self nextResponder] touchesBegan:touches withEvent:event];
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [[self nextResponder] touchesMoved:touches withEvent:event];
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [[self nextResponder] touchesEnded:touches withEvent:event];
//}
@end

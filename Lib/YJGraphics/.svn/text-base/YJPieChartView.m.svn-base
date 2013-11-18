//
//  YJPieChartView.m
//  TestYJFramework
//
//  Created by szfore on 13-6-26.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJPieChartView.h"
@interface YJPieChartView()
@end
@implementation YJPieChartView

-(void)setDefaultValue
{
    _radius=120;
    _thickness=40;
    _yScale=.4;
    _drawMode=kCGPathEOFillStroke;
    _font=[[UIFont systemFontOfSize:13] retain];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setDefaultValue];
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_font release];
    [_modelArr release];
    [super dealloc];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    float angle=2*M_PI;
    for (int i=_modelArr.count-1; i>=0; i--) {
        YJGraphicsModel *model=[_modelArr objectAtIndex:i];
    
        
        CGContextSaveGState(ctx);
        CGContextScaleCTM(ctx, 1, _yScale);
        [[UIColor whiteColor] setStroke];
        CGContextSetFillColorWithColor(ctx, model.color.CGColor);
        CGContextTranslateCTM(ctx,model.span*sinf(angle/2-model.scale*M_PI),model.span*cosf(angle/2-model.scale*M_PI) );
        CGContextSetLineWidth(ctx, 1);
        CGContextMoveToPoint(ctx, _radius, _radius);
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(angle)), _radius*(1+sinf(angle)));
        CGContextAddArc(ctx, _radius, _radius, _radius, angle, angle-model.scale*2*M_PI, 1);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, _drawMode);
        
        CGContextMoveToPoint(ctx, _radius, _radius+_thickness);
        CGContextAddLineToPoint(ctx, _radius, _radius);
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(angle)), _radius*(1+sinf(angle)));
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(angle)), _radius*(1+sinf(angle))+_thickness);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, _drawMode);
        
        CGContextMoveToPoint(ctx, _radius, _radius);
        CGContextAddLineToPoint(ctx, _radius, _radius+_thickness);
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(-model.scale*2*M_PI+angle)), _radius*(1+sinf(-model.scale*2*M_PI+angle))+_thickness);
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(-model.scale*2*M_PI+angle)), _radius*(1+sinf(-model.scale*2*M_PI+angle)));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, _drawMode);
        
        CGContextMoveToPoint(ctx, _radius*(1+cosf(angle)), _radius*(1+sinf(angle)));
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(angle)), _radius*(1+sinf(angle))+_thickness);
        float endAngel=angle-model.scale*2*M_PI;
        CGContextAddArc(ctx, _radius, _radius+_thickness, _radius, angle, endAngel, 1);
        CGContextAddLineToPoint(ctx, _radius*(1+cosf(endAngel)), _radius*(1+sinf(endAngel)));
        CGContextAddArc(ctx, _radius, _radius, _radius, endAngel, angle, 0);
        CGContextDrawPath(ctx, _drawMode);
        CGContextRestoreGState(ctx);
        angle-=model.scale*2*M_PI;
    }
    UIGraphicsPopContext();
}
@end

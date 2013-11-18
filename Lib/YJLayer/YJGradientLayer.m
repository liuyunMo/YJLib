//
//  YJGradientLayer.m
//  TestYJFramework
//
//  Created by szfore on 13-5-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJGradientLayer.h"

@implementation YJGradientLayer
-(id)init
{
    if (self=[super init])
    {
        _startPoint=CGPointZero;
        _endPoint=CGPointMake(1, 1);
        self.colorRefArray=[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, nil];
        self.locationArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:.7],[NSNumber numberWithFloat:1], nil];
        self.drawType=kLinear;
        self.startRadius=10;
        self.endRadius=50;
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_colorRefArray release];
    [_locationArray release];
    [super dealloc];
}
-(void)setColorRefArray:(NSArray *)arr
{
    [arr retain];
    [_colorRefArray release];
    _colorRefArray=arr;
    [self setNeedsDisplay];
}
-(void)setLocationArray:(NSArray *)arr
{
    [arr retain];
    [_locationArray release];
    _locationArray=arr;
    [self setNeedsDisplay];
}
- (void)drawInContext:(CGContextRef)ctx
{
    CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    const int count=[_locationArray count];
    float locations[count];
    for (int i=0; i<count; i++)
    {
        locations[i]=[[_locationArray objectAtIndex:i] floatValue];
    }
    CGGradientRef gradientRef=CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)_colorRefArray, locations);
    CGSize size=self.bounds.size;
    switch (_drawType)
    {
        case kLinear:
            CGContextDrawLinearGradient(ctx, gradientRef, CGPointMake(size.width*_startPoint.x, size.height*_startPoint.y), CGPointMake(size.width*_endPoint.x, size.height*_endPoint.y), _drawingOptions);
            break;
        case kRadial:
            CGContextDrawRadialGradient(ctx, gradientRef, CGPointMake(size.width/2, size.height/2), _startRadius, CGPointMake(size.width/2, size.height/2), _endRadius, _drawingOptions);
            break;
            
        default:
            break;
    }
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
}
@end

//
//  YJQuartz2DFunction.m
//  testYJView
//
//  Created by szfore on 13-5-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
#import "YJQuartz2DFunction.h"
CGGradientRef createGradientWithColors(NSArray *colors, NSArray *locationArr)
{
    CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    const int count=[locationArr count];
    float locations[count];
    for (int i=0; i<count; i++)
    {
        locations[i]=[[locationArr objectAtIndex:i] floatValue];
    }
    CGGradientRef gradientRef=CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(colorSpaceRef);
    return gradientRef;
}
void setUpNavBackground(CGContextRef context)
{
    NSArray *colorArr=@[
                        (id)[UIColor colorWithRed:210/255.0 green:218/255.0 blue:230/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:100/255.0 green:125/255.0 blue:160/255.0 alpha:1].CGColor,
                        ];
    NSArray *locationArr=@[
                           @(.0),
                           @(.8),
                           ];
    CGGradientRef gradientRef=createGradientWithColors(colorArr, locationArr);
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0, 0), CGPointMake(0, 44), kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradientRef);
}
UIImage* getNavBarItemDefaultBackgroupImage(void)
{
    NSArray *colorArr=@[
                        (id)[UIColor colorWithRed:171/255.0 green:185/255.0 blue:201/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:100/255.0 green:125/255.0 blue:160/255.0 alpha:1].CGColor,
                        ];
    NSArray *locationArr=@[
                           @(.0),
                           @(.8),
                           ];
    CGGradientRef gradientRef=createGradientWithColors(colorArr, locationArr);
    UIImage *image=imageWithLinearGradient(gradientRef, CGSizeMake(50, 30));
    CGGradientRelease(gradientRef);
    return image;
}
UIImage* getNavBarItemSelectedBackgroupImage(void)
{
    NSArray *colorArr=@[
                        (id)[UIColor colorWithRed:135/255.0 green:155/255.0 blue:182/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:63/255.0 green:92/255.0 blue:128/255.0 alpha:1].CGColor,
                        ];
    NSArray *locationArr=@[
                           @(.0),
                           @(.8),
                           ];
    CGGradientRef gradientRef=createGradientWithColors(colorArr, locationArr);
    UIImage *image=imageWithLinearGradient(gradientRef, CGSizeMake(50, 30));
    CGGradientRelease(gradientRef);
    return image;
}
UIImage *getCardCellAccessImage(CGSize size)
{
    float width=size.width/3;
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:135/255.0 green:155/255.0 blue:182/255.0 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:135/255.0 green:155/255.0 blue:182/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, size.width, size.height/2);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0, size.height-width);
    CGContextAddLineToPoint(context, size.width-width, size.height/2);
    CGContextAddLineToPoint(context, 0, width);
    CGContextClosePath(context);
    CGContextEOFillPath(context);
    UIImage *accessImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return accessImage;
}
UIImage *imageWithLinearGradient(CGGradientRef gradient,CGSize size)
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
UIImage *imageWithRadialGradient(CGGradientRef gradient,CGSize size)
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width/2, size.width/2), 0, CGPointMake(size.width/2, size.width/2), size.width/2, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
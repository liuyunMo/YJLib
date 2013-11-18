//
//  YJLayoutHandle.m
//  TestYJFramework
//
//  Created by szfore on 13-7-24.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJLayoutHandle.h"
CGSize getApplicationSize(void)
{
    return [[UIScreen mainScreen] applicationFrame].size;
}
float getFrameValue(NSString *str,float max)
{
    if ([str hasPrefix:@"-"]) {
        return max+[str floatValue];
    }
    return [str floatValue];
}
CGRect getFrameFromLayoutWithFrameString(NSString *frameStr)
{
    CGRect rect={0,0,0,0};
    if (!frameStr) return rect;
    NSArray *frameArr=[frameStr componentsSeparatedByString:@","];
    if (!frameArr||frameArr.count!=4) return rect;
    CGSize size=getApplicationSize();
    rect.origin.x      = getFrameValue([frameArr objectAtIndex:0],size.width);
    rect.origin.y      = getFrameValue([frameArr objectAtIndex:1],size.width);
    rect.size.width    = getFrameValue([frameArr objectAtIndex:2],size.height);
    rect.size.height   = getFrameValue([frameArr objectAtIndex:3],size.height);
    return rect;
}
UIColor *getColorFromLayoutWithColorString(NSString *colorStr)
{
    NSArray *colorArr=[colorStr componentsSeparatedByString:@","];
    if (!colorArr||colorArr.count<3) return [UIColor clearColor];
    float r=SAFE_COLOR([[colorArr objectAtIndex:0] floatValue]);
    float g=SAFE_COLOR([[colorArr objectAtIndex:1] floatValue]);
    float b=SAFE_COLOR([[colorArr objectAtIndex:2] floatValue]);
    float a=SAFE_COLOR(colorArr.count>3?[[colorArr objectAtIndex:3] floatValue]:255);
    return  COLOR_WITH_RGBA(r, g, b, a);
}
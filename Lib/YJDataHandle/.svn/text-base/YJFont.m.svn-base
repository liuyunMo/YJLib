//
//  YJFont.m
//  TestYJFramework
//
//  Created by szfore on 13-5-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFont.h"

@implementation YJFont

@end
@implementation UIFont (YJFont)
+(UIFont*)getFontWithTTTName:(NSString *)ttfName size:(float)size
{
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:ttfName ofType:@"ttf"];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef font_ref =CGFontCreateWithDataProvider(fontDataProvider);
    NSString *fontName = (NSString *)CGFontCopyFullName(font_ref);
    CGFontRelease(font_ref);
    CGDataProviderRelease(fontDataProvider);
    UIFont *font=[UIFont fontWithName:fontName size:size];
    [fontName release];
    return font;
}
@end
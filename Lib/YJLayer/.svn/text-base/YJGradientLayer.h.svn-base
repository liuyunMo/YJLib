//
//  YJGradientLayer.h
//  TestYJFramework
//
//  Created by szfore on 13-5-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/* 渐变层 */

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/QuartzCore.h>
enum {
    kLinear = 0,
    kRadial
};
typedef NSUInteger CGGradientDrawingType;
@interface YJGradientLayer : CALayer
//颜色数组  元素是CGColorRef
@property (nonatomic,retain) NSArray *colorRefArray;
//每个颜色对应的location  范围是（0.0-1.0）;元素个数与colorRefArray元素个数保持一致
@property (nonatomic,retain) NSArray *locationArray;
//线形渐变起始点 （0.0-1.0）;
@property (nonatomic,assign) CGPoint startPoint;
//线形渐变结束点 （0.0-1.0）;
@property (nonatomic,assign) CGPoint endPoint;
//
@property (nonatomic,assign) float startRadius;
//
@property (nonatomic,assign) float endRadius;
@property (nonatomic,assign) CGGradientDrawingOptions drawingOptions;
@property (nonatomic,assign) CGGradientDrawingType drawType;
@end

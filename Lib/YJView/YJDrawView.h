//
//  YJDrawView.h
//  TestYJFramework
//
//  Created by szfore on 13-7-18.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

//使用opengl绘制才是正确。。。。

@interface YJDrawView : YJFlagView

@property(nonatomic,retain)UIColor *lineColor;
@property(nonatomic,assign)float lineWidth;
-(NSArray *)getLines;
@end

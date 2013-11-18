//
//  YJPieChartView.h
//  TestYJFramework
//
//  Created by szfore on 13-6-26.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/* 饼图 */
#import "YJGraphicsModel.h"
@interface YJPieChartView : YJFlagView
@property(nonatomic,assign)CGPathDrawingMode drawMode;
@property(nonatomic,assign)float radius;
@property(nonatomic,assign)float thickness;
@property(nonatomic,assign)float yScale;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,retain)NSArray *modelArr;//YJGraphicsModel array
-(void)setDefaultValue;
@end

//
//  YJClipView.h
//  TestYJFramework
//
//  Created by szfore on 13-7-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#define CLIP_LINE_COLOR COLOR_WITH_RGB(100,100,100)
#define CLIP_LINE_WIDTH 1.0F
typedef struct YJClipPoint YJClipPoint;
@interface YJClipView : YJFlagView
{
    YJClipPoint *points;
}
@property(nonatomic,assign)CGRect clipRect;
@property(nonatomic,readonly)UIBezierPath *path;
@end

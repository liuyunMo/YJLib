//
//  YJImageHandleView.h
//  TestYJFramework
//
//  Created by szfore on 13-7-18.
//  Copyright (c) 2013年 szfore. All rights reserved.
//



@interface YJImageHandleView : YJFlagView
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,readonly)UIImage *currentImage;
@property(nonatomic,readonly)float scale;

@end

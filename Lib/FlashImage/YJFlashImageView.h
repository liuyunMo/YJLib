//
//  YJFlashImageView.h
//  YJHealth
//
//  Created by szfore on 13-7-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//


/*
 闪图加载
 
 1、关键字链接
 2、热点响应（指定正确的 tapPlistPath）
 */

#import "YJView.h"
#import "YJViewDelegate.h"
@interface YJFlashImageView : YJFlagView<YJTouchViewDelegate>
{
    void(^touchBlock)(NSString *name,NSString *type,YJFlashImageView *flashImage);
}
@property(nonatomic,copy)NSString *tapPlistPath;
@property(nonatomic,retain)NSArray *keywords;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,assign)float scale;//0.0f-1.0f;

@property(nonatomic,assign)id<YJFlashImageViewDelegate>delegate_flash;
-(id)initWithFrame:(CGRect)frame touchBlock:(void(^)(NSString *name,NSString *type,YJFlashImageView *flashImage))block;
@end
@protocol YJFlashImageViewDelegate <NSObject>

@optional
-(void)touchHotAreaWithName:(NSString *)name type:(NSString *)type flashImage:(YJFlashImageView *)flashImage;
-(void)selectKeyword:(NSString *)keyword flashImage:(YJFlashImageView *)flashImage;
@end
//
//  YJAlertInputView.h
//  YJSwear
//
//  Created by zhongyy on 13-9-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
//  心碎    。。。。。以后再改
#import "YJFlagView.h"

@interface YJAlertInputView : YJFlagView
@property(nonatomic,copy)YJResBlock resultBlock;
-(id)initWithTitle:(NSString *)title;
-(void)showInView:(UIView *)view;
@end

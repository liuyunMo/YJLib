//
//  YJOptionView.h
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-21.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

/* 选项 */

#import <UIKit/UIKit.h>
#import "YJContentView.h"
#import "YJTestDefine.h"
#import "YJImageManager.h"

@protocol YJOptionViewDelegate;
@interface YJOptionView : YJContentView
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)id<YJOptionViewDelegate>delegate;
@property(nonatomic,retain)UIColor *textColor;
@end
@protocol YJOptionViewDelegate <NSObject>
@optional
-(void)selectOptionView:(YJOptionView *)optionView;
-(void)deselectOptionView:(YJOptionView *)optionView;
@end
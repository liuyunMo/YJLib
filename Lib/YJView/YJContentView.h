//
//  YJContentView.h
//  YJAnswerViewDemo
//
//  Created by admin123 on 13-3-25.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//
/* 文本展示 */

#import <UIKit/UIKit.h>
#import "YJFlagView.h"
@interface YJContentView : YJFlagView
@property(nonatomic,retain)NSString *optionString;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,assign)CGSize contentOffSet;
-(id)initWithString:(NSString *)string frame:(CGRect)frame;
-(UITextView *)getContentView;
-(void)createView;
@end
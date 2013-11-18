//
//  YJFlagView.h
//  iTest
//
//  Created by szfore on 13-4-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YJView.h"
#define YJLAYOUT_YJVIEW_FLAG @"flag"
@interface YJFlagView : YJView<YJFlagViewDelegate>
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr;

@end

@interface UIView (YJFlagView)
-(YJFlagView *)getYJFlagViewWithFlag:(NSString *)flag;
-(void)setUpShadowWithOffset:(CGSize)offSize;
@end


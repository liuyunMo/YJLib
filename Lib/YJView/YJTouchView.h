//
//  YJTouchView.h
//  testYJGridView
//
//  Created by szfore on 13-4-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//


#import "YJFlagView.h"
@interface YJTouchView : YJFlagView
@property(nonatomic,assign)id<YJTouchViewDelegate>delegate_touch;
@property(nonatomic,assign)BOOL passTouch;
-(void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)handleTouchesCancel:(NSSet *)touches withEvent:(UIEvent *)event;
@end

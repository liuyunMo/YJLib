//
//  YJMainView.h
//  YJHealth
//
//  Created by szfore on 13-7-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
 本类负责 与主控制器的交互  ～～～
 
 */
#import "YJFlagView.h"
@interface YJMainView : YJFlagView
@property(nonatomic,assign)id<YJMainViewDelegate>delegate;
-(void)postUseInfoToMain:(NSDictionary *)userInfo finish:(void(^)(id))block;
-(void)reloadData;
@end
@protocol YJMainViewDelegate <NSObject>
@optional
-(void)mainView:(YJMainView *)mainView wantToDoWithUserInfo:(NSDictionary *)userInfo finish:(void(^)(id))block;
@end
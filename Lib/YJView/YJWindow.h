//
//  YJWindow.h
//  YJExam
//
//  Created by szfore on 13-4-16.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//
/*
#define INFO_VIEW_FLAG_YJWINDOW @"YJWindowInfoView"
#define NAV_FLAG_YJWINDOW @"YJWindowNav"
 */

/*
 YJWindow
 1、设置是否crash记录，默认记录
 2、展示readme
 3、状态栏提示（暂不支持）
 
 version : 2013.11.19
 
 增加 info按钮处理事件的指定
 */

#define YJLAYOUT_YJWINDOW_CRASH           @"crashRecord"
#define YJLAYOUT_YJWINDOW_INFOBUT_HIDDEN  @"hiddenInfoBut"

#import "YJCrashRecorder.h"
#import "YJNavBar.h"
typedef void(^InfoButPreHandle)(void);
@interface YJWindow : UIWindow<YJNavBarDelegate,YJFlagViewDelegate>
{
    UIButton *infoBu;
    YJFlagView *infoView;
}
@property(nonatomic,assign)BOOL hiddenInfoButton;
@property(nonatomic,copy)InfoButPreHandle handle;
+(NSString *)getReadmeFilePath;
-(void)setupWindow;
-(void)resignCrashRecorder;
-(void)setCrashRecorder;
@end
@interface UIApplication (YJWindow)
-(void)hiddenInfoButtonInWindow:(BOOL)hidden;
@end

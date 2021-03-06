//
//  YJWindow.m
//  YJExam
//
//  Created by szfore on 13-4-16.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJWindow.h"
#define INFO_VIEW_FLAG_YJWINDOW @"YJWindowInfoView"
#define NAV_FLAG_YJWINDOW @"YJWindowNav"
@implementation YJWindow
@synthesize flagStr=_flagStr;
-(void)resignCrashRecorder
{
    [YJCrashRecorder resignDefaultCrashRecord];
}
-(void)setCrashRecorder
{
    [YJCrashRecorder setDefaultCrashRecord];
}
-(void)setHandle:(InfoButPreHandle)handle
{
    SET_BLOCK(_handle, handle);
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_handle);
    [_flagStr release];
    [super dealloc];
}
-(void)setupWindow
{
    [self setCrashRecorder];
    self.frame=[[UIScreen mainScreen] bounds];
    //self.windowLevel=UIWindowLevelStatusBar+1;
    self.backgroundColor=[UIColor clearColor];
    if (!infoBu&&!self.hiddenInfoButton) {
        infoBu=[UIButton buttonWithType:UIButtonTypeInfoDark];
        infoBu.frame=CGRectMake(280, [UIApplication sharedApplication].statusBarFrame.size.height+2, 40, 40);
        [infoBu addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:infoBu];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        [self setupWindow];
    }
    return self;
}
-(void)didAddSubview:(UIView *)subview
{
    [self bringSubviewToFront:infoBu];
}
-(void)showInfoView
{
    if (_handle) {
        _handle();
        return;
    }
    float statusHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    infoBu.hidden=YES;
    if (!infoView)
    {
        infoView=[[YJFlagView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height-statusHeight)];
        infoView.flagStr=INFO_VIEW_FLAG_YJWINDOW;
        infoView.backgroundColor=[UIColor whiteColor];
        [self addSubview:infoView];
        [infoView release];
        
        YJNavBar *nav=[[YJNavBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44) flagStr:NAV_FLAG_YJWINDOW];
        nav.showLeftItem=YES;
        nav.showRightItem=YES;
        nav.delegate_navBar=self;
        [nav setUpLeftItemTitle:@"done"];
        [nav setUpRightItemTitle:@"crash"];
        nav.title=@"readme";
        [infoView addSubview:nav];
        [nav release];
        
        
        UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, infoView.bounds.size.height-44)];
        textView.textColor=[UIColor blackColor];
        textView.editable=NO;
        textView.tag=TAG_START+10;
        textView.backgroundColor=[UIColor clearColor];
        [infoView addSubview:textView];
        [textView release];
    }
    UITextView *textView=(UITextView *)[infoView viewWithTag:TAG_START+10];
    textView.text=[NSString stringWithContentsOfFile:[YJWindow getReadmeFilePath] encoding:4 error:nil];
    __block typeof(self)bSelf=self;
    [UIView animateWithDuration:.5 animations:^{
        infoView.frame=CGRectMake(0, statusHeight, bSelf.bounds.size.width, bSelf.bounds.size.height);
    }];
}
+(NSString *)getReadmeFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"txt"];
}
-(void)removeShowView
{
    if (!self.hiddenInfoButton)
    {
        infoBu.hidden=NO;
    }
    float statusHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    __block typeof(self)bSelf=self;
    [UIView animateWithDuration:.5 animations:^{
        infoView.frame=CGRectMake(0, bSelf.bounds.size.height+statusHeight, bSelf.bounds.size.width, bSelf.bounds.size.height);
    } completion:^(BOOL finished){if(finished){[infoView removeFromSuperview];infoView=nil;}}];
}
-(void)setHiddenInfoButton:(BOOL)hiddenInfoButton
{
    _hiddenInfoButton=hiddenInfoButton;
    infoBu.hidden=_hiddenInfoButton;
}
#pragma YJNavBarDelegate 
-(void)leftItemPressed:(YJButton *)item nav:(YJNavBar *)nav 
{
    [self removeShowView];
}
-(void)rightItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    UITextView *textView=(UITextView *)[infoView viewWithTag:TAG_START+10];
    NSString *content=nil;
    YJNavBar *bar=(YJNavBar *)[infoView getYJFlagViewWithFlag:@"YJNavBar_windows"];
    if ([@"crash" isEqualToString:item.titleLabel.text])
    {
        NSData *data=[NSData dataWithContentsOfFile:[YJCrashRecorder getCrashFilePath]];
        content =[[NSString alloc] initWithData:[YJEncrypt encryptDataUseDefault:data] encoding:4];
        item.titleLabel.text=@"readme";
        bar.title=@"crashInfo";
        textView.textColor=[UIColor redColor];
    }else{
        content=[[NSString alloc] initWithContentsOfFile:[YJWindow getReadmeFilePath] encoding:4 error:nil];
        item.titleLabel.text=@"crash";
        bar.title=@"readme";
        textView.textColor=[UIColor blackColor];
    }
    if (content&&![@"" isEqualToString:content])
    {
        textView.text=content;
    }else{
        textView.text=@"暂无记录！";
    }
    [content release];
}
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    YJWindow *win=[super viewWithLayoutDict:dict];
    if (win&&[win isKindOfClass:[YJWindow class]]) {
        
        [win setupWindow];
        //flag
        NSString *flag=[dict objectForKey:YJLAYOUT_YJVIEW_FLAG];
        if (flag&&[flag isKindOfClass:[NSString class]]) {
            win.flagStr=flag;
        }
        
        //crash recorder
        
        BOOL crashRec=[[dict objectForKey:YJLAYOUT_YJWINDOW_CRASH] boolValue];
        crashRec?[win setCrashRecorder]:[win resignCrashRecorder];
        
        //info button hidden
        
        BOOL hidden=[[dict objectForKey:YJLAYOUT_YJWINDOW_INFOBUT_HIDDEN] boolValue];
        win.hiddenInfoButton=hidden;
    }
    return win;
}
@end
@implementation UIApplication (YJWindow)
-(void)hiddenInfoButtonInWindow:(BOOL)hidden
{
    [(YJWindow *)self.keyWindow setHiddenInfoButton:hidden];
}
@end

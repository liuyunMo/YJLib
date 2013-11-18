//
//  YJMainViewController.m
//  YJSwear
//
//  Created by zhongyy on 13-8-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJMainViewController.h"

@interface YJMainViewController ()
{
    BOOL create;//是否已经创建！
}
@end

@implementation YJMainViewController
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(self.login);
    [super dealloc];
}
-(void)setLoginModalTransitionStyle:(UIModalTransitionStyle *)style TransitionWithAnimation:(BOOL*)animation
{
    *style=UIModalTransitionStyleCoverVertical;
    *animation=YES;
}
-(void)tryToShowLogin
{
    if (self.login) {
        BOOL showLogin =NO;
        Class loginClass=nil;
        (self.login)(&showLogin,&loginClass);
        if (showLogin) {
            UIViewController *login=OBJ_CREATE(loginClass);
            if (login&&[login isKindOfClass:[UIViewController class]]) {
                UIModalTransitionStyle style=UIModalTransitionStyleCoverVertical;
                BOOL ani=YES;
                [self setLoginModalTransitionStyle:&style TransitionWithAnimation:&ani];
                login.modalTransitionStyle=style;
                [self presentModalViewController:login animated:ani];
            }else{
                NSString *errorStr=[NSString stringWithFormat:@"指定的login类（%@）不是UIViewController的子类",NSStringFromClass(loginClass)];
                ERROR_LOG([self class], errorStr);
            }
            [login release];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!create) {
        [self tryToShowLogin];
        create=YES;
    }
}
-(void)setLogin:(LoginBlock)login
{
    SET_BLOCK(_login, login);
}
-(void)mainView:(YJMainView *)mainView wantToDoWithUserInfo:(NSDictionary *)userInfo finish:(void(^)(id))block
{
    
}
@end

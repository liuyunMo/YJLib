//
//  YJMainViewController.h
//  YJSwear
//
//  Created by zhongyy on 13-8-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJViewController.h"
typedef void(^LoginBlock)(BOOL *showLogin,Class *login);

@interface YJMainViewController : YJViewController<YJMainViewDelegate>
@property(nonatomic,copy)LoginBlock login;
-(void)setLoginModalTransitionStyle:(UIModalTransitionStyle *)style TransitionWithAnimation:(BOOL*)animation;
-(void)mainView:(YJMainView *)mainView wantToDoWithUserInfo:(NSDictionary *)userInfo finish:(void(^)(id))block;
-(void)tryToShowLogin;
@end

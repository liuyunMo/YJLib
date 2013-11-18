//
//  YJLoginView.h
//  YJExam
//
//  Created by admin123 on 13-3-26.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJTouchView.h"
#import "YJButton.h"
#import "LYJsonCode.h"

/*
 #define LOGIN_BUTTON_FLAG @"YJLoginViewloginButton"
 #define USERNAME_TF_TAG TAG_START+1
 #define PASSWORD_TF_TAG TAG_START+2
 */
typedef id(^loginBlock)(NSString *jsonStr);
@interface YJLoginView : YJTouchView<UITextFieldDelegate>
{
    loginBlock login_block;
    UIActivityIndicatorView *indicator;
}
@property(nonatomic,readonly)UITextField *userNameTf;
@property(nonatomic,readonly)UITextField *passwordTf;
@property(nonatomic,readonly)YJButton *loginButton;
@property(nonatomic,assign)id<YJLoginViewDelegate>delegate_login;
@property(nonatomic,assign)BOOL showIndicator;
-(void)getUserName:(NSString **)userName password:(NSString **)password;
-(void)resignKeyboard;
-(void)setUpLoginHandle:(loginBlock)block;//已处理为子线程操作！
@end

@protocol YJLoginViewDelegate <NSObject>
-(NSDictionary *)getUserInfoDictWithUserName:(NSString *)userName password:(NSString *)password startCheck:(BOOL *)start;
-(void)checkUserWithNetworkFinish:(id)networkData loginView:(YJLoginView *)loginView;
@optional
-(void)loginViewWillCheckUserInfo:(YJLoginView *)loginView;
@end



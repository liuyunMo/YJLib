//
//  YJLoginView.m
//  YJExam
//
//  Created by admin123 on 13-3-26.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJLoginView.h"
#define LOGIN_BUTTON_FLAG @"YJLoginViewloginButton"
#define USERNAME_TF_TAG TAG_START+1
#define PASSWORD_TF_TAG USERNAME_TF_TAG+1
@implementation YJLoginView
@synthesize loginButton=_loginButton;
@synthesize userNameTf=_userNameTf;
@synthesize passwordTf=_passwordTf;
-(void)createDefaultView
{
    if (!self.userNameTf)
    {
        _userNameTf=[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        _userNameTf.placeholder=@"用户名";
        _userNameTf.tag=USERNAME_TF_TAG;
        _userNameTf.delegate=self;
        _userNameTf.borderStyle=UITextBorderStyleRoundedRect;
        _userNameTf.returnKeyType=UIReturnKeyNext;
        [self addSubview:_userNameTf];
        [_userNameTf release];
    }
    
    if (!self.passwordTf)
    {
        _passwordTf=[[UITextField alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
        _passwordTf.placeholder=@"密码";
        _passwordTf.secureTextEntry=YES;
        _passwordTf.delegate=self;
        _passwordTf.tag=PASSWORD_TF_TAG;
        _passwordTf.borderStyle=UITextBorderStyleRoundedRect;
        _passwordTf.returnKeyType=UIReturnKeyGo;
        [self addSubview:_passwordTf];
        [_passwordTf release];
    }
    
    if (!self.loginButton)
    {
        __block typeof(self) bSelf=self;
        _loginButton=[[YJButton alloc] initWithFrame:CGRectMake(60, 90, 200, 30) event:^(YJButton *bu)
        {
            [bSelf handleWithLoginPressed];
        }];
        _loginButton.flagStr=LOGIN_BUTTON_FLAG;
        _loginButton.titleLabel.text=@"登录";
        _loginButton.backgroundColor=[UIColor redColor];
        [self addSubview:_loginButton];
        [_loginButton release];
    }
}
-(void)handleWithLoginPressed
{
    [self resignKeyboard];
    NSString *userName=nil,*password=nil;
    [self getUserName:&userName password:&password];
    BOOL start=NO;
    NSDictionary *dict=[self.delegate_login getUserInfoDictWithUserName:userName password:password startCheck:&start];
    if (start)
    {
        if (!login_block)
        {
            NSLog(@"请指定登录事件！");
            return;
        }
        if ([self.delegate_login respondsToSelector:@selector(loginViewWillCheckUserInfo:)])
        {
            [self.delegate_login loginViewWillCheckUserInfo:self];
        }
        if (_showIndicator)
        {
            indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.center=self.loginButton.center;
            [indicator startAnimating];
            [self addSubview:indicator];
            [indicator release];
        }
        NSString *jsonStr=[LYJsonCode jsonCodeWithDictionary:dict];
        [NSThread detachNewThreadSelector:@selector(postDataToService:) toTarget:self withObject:jsonStr];
    }
}
-(void)getUserName:(NSString **)userName password:(NSString **)password
{
    *userName=stringDeleteWhitespaceAndNewline(self.userNameTf.text);
    *password=stringDeleteWhitespaceAndNewline(self.passwordTf.text);
}
-(void)setUpLoginHandle:(loginBlock)block
{
    if (login_block)Block_release(login_block);
    login_block=Block_copy(block);
}
-(void)postDataToService:(NSString *)jsonStr
{
    id value=login_block(jsonStr);
    [self performSelectorOnMainThread:@selector(postDataToServiceFinish:) withObject:value waitUntilDone:YES];
    [NSThread exit];
}
-(void)postDataToServiceFinish:(id)data
{
    if (_showIndicator)
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    [self.delegate_login checkUserWithNetworkFinish:data loginView:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createDefaultView];
    }
    return self;
}
-(void)resignKeyboard
{
    //[self endEditing:YES];
    [_userNameTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    Block_release(login_block);
    [super dealloc];
}

-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}
#pragma mark--  UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==USERNAME_TF_TAG)
    {
        UITextField *tf=(UITextField *)[self viewWithTag:PASSWORD_TF_TAG];
        [tf becomeFirstResponder];
    }else{
        [self handleWithLoginPressed];
    }
    return YES;
}
@end

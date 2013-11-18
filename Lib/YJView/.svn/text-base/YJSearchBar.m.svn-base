//
//  YJSearchBar.m
//  TestYJFramework
//
//  Created by szfore on 13-5-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJSearchBar.h"

@implementation YJSearchBar
-(void)createViewInYJSearchBar
{
    if (!_inputTf)
    {
        _inputTf=[[UITextField alloc] initWithFrame:CGRectMake(self.offset.width, self.offset.height, self.bounds.size.width-3*self.offset.width-45, self.bounds.size.height-2*self.offset.height)];
        _inputTf.borderStyle=UITextBorderStyleRoundedRect;
        _inputTf.delegate=self;
        _inputTf.returnKeyType=UIReturnKeySearch;
        [self addSubview:_inputTf];
        [_inputTf release];
        
        __block typeof(self) bSelf=self;
        YJButton *cancelButton=[[YJButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-45-self.offset.width,8, 45, 28) event:^(YJButton *bu)
                                {
                                    [bSelf handleWithCancelPressed];
                                }];
        cancelButton.titleLabel.text=@"取消";
        cancelButton.clipsToBounds=YES;
        [cancelButton setImage:getNavBarItemDefaultBackgroupImage() forYJButtonStatus:kYJButtonStatusDefault];
        [cancelButton setImage:getNavBarItemSelectedBackgroupImage() forYJButtonStatus:kYJButtonStatusSelected];
        cancelButton.layer.cornerRadius=3;
        [self addSubview:cancelButton];
        
        [cancelButton release];
    }
}
-(void)handleWithCancelPressed
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonPressed:)])
    {
        [self.delegate cancelButtonPressed:self];
    }
}
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    self = [super initWithFrame:frame flagStr:flagStr];
    if (self)
    {
        _offset=CGSizeMake(5, 8);
        self.backgroundColor=[UIColor colorWithPatternImage:getNavBarItemDefaultBackgroupImage()];
        [self createViewInYJSearchBar];
    }
    return self;
}
-(BOOL)resignFirstResponder
{
    return [_inputTf resignFirstResponder];
}
-(BOOL)becomeFirstResponder
{
    return [_inputTf becomeFirstResponder];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
#pragma mark-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(yjSearchBarShouldReturn:)])
    {
        return [self.delegate yjSearchBarShouldReturn:self];
    }
    return YES;
}
@end

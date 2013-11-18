//
//  YJAlertInputView.m
//  YJSwear
//
//  Created by zhongyy on 13-9-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJAlertInputView.h"
@interface YJAlertInputView()<UIAlertViewDelegate>
{
    UITextField *tf;
}
@end
@implementation YJAlertInputView
-(id)initWithTitle:(NSString *)title
{
    CGRect rect=CGRectMake((320-489/2.0)/2, [UIScreen mainScreen].applicationFrame.size.height-215, 489/2.0, 268/2);
    self=[super initWithFrame:rect];
    self.clipsToBounds=YES;
    self.layer.cornerRadius=5;
    UIImageView *bg=[[UIImageView alloc] initWithFrame:self.bounds];
    bg.image=[UIImage imageNamed:@"custom_bg.png"];
    [self addSubview:bg];
    [bg release];
    
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 489/2.0, 37)];
    la.text=title;
    la.backgroundColor=[UIColor clearColor];
    la.textAlignment=UITextAlignmentCenter;
    [self addSubview:la];
    [la release];
    tf=[[UITextField alloc] initWithFrame:CGRectMake(15, 50, 489/2.0-30, 25)];
    [self addSubview:tf];
    [tf release];
    
    float butHeight=34;
    float butWidth=86.5;
    float span=10;
    float height=128;
    float spanBu=(489/2.0-2*butWidth)/3;
    __block typeof(self)bSelf=self;
    NSArray *titles=@[@"new_cancle",@"new_ok"];
    for (int i=0; i<2; i++) {
        YJButton *but=[[YJButton alloc] initWithFrame:CGRectMake(spanBu+(spanBu+butWidth)*i, height-butHeight-span, butWidth, butHeight) event:^(YJButton *bu){
            [bSelf tapButton:bu];
        }];
        [but setImageWithKeyString:[titles objectAtIndex:i]];
        but.flagStr=[NSString stringWithFormat:@"%d",i];
        [self addSubview:but];
        [but release];
    }
    return self;
}
-(void)tapButton:(YJButton *)bu
{
    [tf resignFirstResponder];
    __block typeof(self)bSelf=self;
    __block typeof(tf)bTf=tf;
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect=bSelf.frame;
        rect.origin.y=[[UIScreen mainScreen] applicationFrame].size.height+20;
        bSelf.frame=rect;
    } completion:^(BOOL finished) {
        if (finished) {
            if (!stringDeleteWhitespaceAndNewline(bTf.text)&&[bu.flagStr intValue]==1)
            {
                UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您没有输入任何有关惩罚信息！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
                [al show];
                [al release];
            }else if([bu.flagStr intValue]==1){
                if (self.resultBlock) {
                    self.resultBlock(bSelf,bTf.text);
                }
                [bSelf removeFromSuperview];
            }else{
                if (self.resultBlock) {
                    self.resultBlock(bSelf,nil);
                }
                [bSelf removeFromSuperview];
            }
        }
    }];
}
-(void)setResultBlock:(YJResBlock)resultBlock
{
    SET_BLOCK(_resultBlock, resultBlock);
}
-(void)showInView:(UIView*)view
{
    [view addSubview:self];
    tf.returnKeyType=UIReturnKeyDone;
    [tf becomeFirstResponder];
    __block typeof(self)bSelf=self;
    [UIView animateWithDuration:.25 animations:^{
        CGRect rect=bSelf.frame;
        rect.origin.y=(view.frame.size.height-rect.size.height-215)/2;
        bSelf.frame=rect;
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __block typeof(self)bSelf=self;
    if (buttonIndex==1) {
        tf.returnKeyType=UIReturnKeyDone;
        [tf becomeFirstResponder];
        
        [UIView animateWithDuration:.5 animations:^{
            CGRect rect=bSelf.frame;
            rect.origin.y=(KEY_WINDOW.frame.size.height-rect.size.height-215)/2;
            bSelf.frame=rect;
        }];
    }else{
        if (self.resultBlock) {
            self.resultBlock(bSelf,nil);
        }
        [self removeFromSuperview];
    }
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_resultBlock);
    [super dealloc];
}
@end

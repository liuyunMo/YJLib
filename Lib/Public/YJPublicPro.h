//
//  YJPublicPro.h
//  TestYJFramework
//
//  Created by szfore on 13-7-16.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJView,YJButton;

struct YJPublicFun
{
    void(*const touchEvent)(YJView *view,NSSet *touches,UIEvent *event,YJTouchEvent eventType);
    void (*const buttonPressed_function)(YJButton *bu);
};
struct YJPublicPro {
    int userId;
    char *userName;
    YJTargetList *targetList;
    struct YJPublicFun *fun;
};
typedef struct YJPublicPro YJPublicPro,*YJPublicProRef;
YJPublicProRef getPublicPro(void);
void setUserName(const char *userName);
NSString *getUserName();
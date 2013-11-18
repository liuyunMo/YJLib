//
//  YJPublicPro.m
//  TestYJFramework
//
//  Created by szfore on 13-7-16.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJPublicPro.h"

YJPublicProRef getPublicPro(void)
{
    static dispatch_once_t onceToken;
    static YJPublicProRef public_pro=NULL;
    dispatch_once(&onceToken, ^{
        public_pro=(YJPublicProRef)malloc(sizeof(YJPublicPro));
        public_pro->userId=-1;
        public_pro->userName=NULL;
        struct YJPublicFun fun={touchHandleFun,buttonPressedHandle};
        public_pro->fun=(struct YJPublicFun *)malloc(sizeof(struct YJPublicFun));
        memcpy(public_pro->fun, &fun, sizeof(fun));
        public_pro->targetList=getCurrentTarget();
    });
   return public_pro;
}
void setUserName(const char *userName)
{
    if (userName) {
        SAFE_FREE(getPublicPro()->userName);
        getPublicPro()->userName=(char *)malloc(strlen(userName)+1);
        strcpy(getPublicPro()->userName, userName);
    }
}
NSString *getUserName()
{
    return [NSString stringWithUTF8String:getPublicPro()->userName];
}
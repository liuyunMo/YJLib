//
//  YJString.h
//  TestYJFramework
//
//  Created by szfore on 13-7-17.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
 有问题啊啊啊啊啊啊啊
 
 */
#import <Foundation/Foundation.h>

struct YJString {
    char *value;
    struct YJString *next;
};
typedef struct YJString YJString,*YJStringRef;
YJStringRef createYJString(const char *value);
YJStatus addString(YJStringRef const string,const char *value);
YJStatus getLastYJString(YJStringRef const string,YJStringRef *last);
int getValueCount(YJStringRef const string,YJStatus *status);
YJStatus freeYJString(YJStringRef);
void printYJString(YJStringRef);
//
//  YJString.m
//  TestYJFramework
//
//  Created by szfore on 13-7-17.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJString.h"
YJStringRef createYJString(const char *value)
{
    if (!value) return NULL;
    YJStringRef string=(YJStringRef)malloc(sizeof(YJString));
    string->value=(char *)malloc(strlen(value)+1);
    strcpy(string->value, value);
    string->next=NULL;
    return string;
}
YJStatus addString(YJStringRef const string,const char *value)
{
    if (!string||!value) return YJStatusFail;
    YJStringRef lastStr=nil;
    getLastYJString(string, &lastStr);
    lastStr->next=createYJString(value);
    return YJStatusOK;
}
YJStatus getLastYJString(YJStringRef const string,YJStringRef *last)
{
    if (!string||!last) return YJStatusFail;
    if (!string->next) {
        *last=string;
        return YJStatusOK;
    }
    YJStringRef tmpStr=(YJStringRef)string;
    while (tmpStr->next)tmpStr=tmpStr->next;
    *last=tmpStr;
    return YJStatusOK;
}
int getValueCount(YJStringRef const string,YJStatus *status)
{
    if(!string)
    {
        if(status)*status=YJStatusFail;
        return 0;
    }
    int count=0;
    YJStringRef tmpStr=(YJStringRef)string;
    while (tmpStr)
    {
        count++;
        tmpStr=tmpStr->next;
    }
    if(status)*status=YJStatusOK;
    return count;
}
YJStatus freeYJString(YJStringRef string)
{
    if (!string) return YJStatusFail;
    while (string->next)
    {
        YJStringRef tmpStr=string->next;
        printf("free:%s\n",string->value);
        SAFE_FREE(string->value);
        string->next=NULL;
        SAFE_FREE(string);
        string=tmpStr;
    }
    printf("free:%s\n",string->value);
    SAFE_FREE(string->value);
    string->next=NULL;
    SAFE_FREE(string);
    return YJStatusOK;
}
void printYJString(YJStringRef string)
{
    if (!string) return;
    printf("count:%d\n",getValueCount(string, NULL));
    while (string->next)
    {
        YJStringRef tmpStr=string->next;
        printf("%s\n",string->value);
        string=tmpStr;
    }
    printf("%s\n",string->value);
}

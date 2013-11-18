//
//  YJTargetList.m
//  TestYJFramework
//
//  Created by zhongyy on 13-8-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTargetList.h"

struct YJTargetList {
    const void * target;
    char *key;
    struct YJTargetList *pre;
    struct YJTargetList *next;
};
static YJTargetList *target_public=NULL;
YJTargetList * createTargetList(const char *key,const void *const target)
{
    YJTargetList *targetList=(YJTargetList *)malloc(sizeof(YJTargetList));
    targetList->target=target;
    targetList->key=(char *)malloc(strlen(key)+1);
    strcpy(targetList->key, key);
    targetList->pre=NULL;
    targetList->next=NULL;
    return targetList;
}
YJTargetList *getLastTarget(YJTargetList *const target)
{
    YJTargetList *p=target;
    while (p->next)p=p->next;
    return p;
}
YJTargetList *getCurrentTarget(void)
{
    return target_public;
}
void freeTargetList(YJTargetList *const target)
{
    YJTargetList *p=target;
    while (p) {
        YJTargetList *next=p->next;
        free(p);
        p=next;
    }
}
void printTargetList(YJTargetList * target)
{
    YJTargetList *p=target;
    while (p)
    {
        printf("\ntarget :%p\nkey:%s\npre:%s\nnext:%s\n",p->target,p->key,p->pre?p->pre->key:NULL,p->next?p->next->key:NULL);
        p=p->next;
    }
}
YJTargetList *getTargetWithKey(const char *key)
{
    YJTargetList *p=target_public;
    while (p)
    {
        if (strcmp(p->key, key)==0) return p;
        p=p->next;
    }
    return NULL;
}
const void *getTargetWithList(YJTargetList *list)
{
    return list->target;
}
void addTargetWithKey(const void *const target,const char *key)
{
    if(!target_public)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            target_public=createTargetList(key, target);
        });
    }else{
        YJTargetList *curTarList=createTargetList(key, target);
        YJTargetList *lastTarget=getLastTarget(target_public);
        lastTarget->next=curTarList;
        curTarList->pre=lastTarget;
    }
}
void deleteTargetWithKey(const char *key)
{
    YJTargetList *target=getTargetWithKey(key);
    YJTargetList *preTar=target->pre;
    YJTargetList *nextTar=target->next;
    if (preTar)
    {
        preTar->next=nextTar;
        nextTar->pre=preTar;
    }else{
        if (nextTar)nextTar->pre=NULL;
    }
    target->pre=NULL;
    target->next=NULL;
    free(target);
}

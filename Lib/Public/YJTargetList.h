//
//  YJTargetList.h
//  TestYJFramework
//
//  Created by zhongyy on 13-8-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct YJTargetList YJTargetList;
const void *getTargetWithList(YJTargetList *list);
YJTargetList *getTargetWithKey(const char *key);
void addTargetWithKey(const void *const target,const char *key);
void deleteTargetWithKey(const char *key);
void printTargetList(YJTargetList * target);
void freeTargetList(YJTargetList *const target);
YJTargetList *getCurrentTarget(void);
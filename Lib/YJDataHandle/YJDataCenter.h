//
//  YJDataCenter.h
//  TestYJFramework
//
//  Created by szfore on 13-6-24.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
 
 数据中心   计划所有数据的获取通过这里   急需完善～～
 
 关于释放  可定有问题～～～～～～。。。。。。。
 
 */
#import "LYJsonCode.h"


struct YJNetworkInfoStruct
{
    void *context;
    NSURL *url;
    BOOL shouldFromNet;//是否从网络加载
    NSDictionary *infoDict;//参数以及其他信息
    NSString *flag;//标示
    id (*handleWithLocal)(NSDictionary *infoDict,NSError **error);//无网络链接，加载本地数据,如果不加载本地，赋值为空
    NSData *(*willPostData)(NSString *jsonStr);//json 编码之后上传数据之前 可用于数据 譬如加密～
};
struct YJNetworkInfoStruct *initNetworkInfoStuct(struct YJNetworkInfoStruct *);
struct YJNetworkResultStruct {
    id data;
    struct YJNetworkInfoStruct *context;
    BOOL fromNetwork;//是否为网络加载
    NSError *error;
};

typedef  void (^GetDataFinish)(struct YJNetworkResultStruct *result);
typedef  void (*GetDataFinishFun)(struct YJNetworkResultStruct *result);


@interface YJDataCenter : NSObject

+(void)handleWithNetworkStruct:(struct YJNetworkInfoStruct *)dataRef finish:(GetDataFinish)finish;
+(void)handleWithNetworkStruct:(struct YJNetworkInfoStruct *)dataRef finishFun:(GetDataFinishFun)finish;
@end

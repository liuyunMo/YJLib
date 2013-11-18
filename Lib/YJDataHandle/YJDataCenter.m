//
//  YJDataCenter.m
//  TestYJFramework
//
//  Created by szfore on 13-6-24.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
#import "SZNetwork.h"
#import "YJDataCenter.h"
struct YJNetworkInfoStruct *initNetworkInfoStuct(struct YJNetworkInfoStruct *info)
{
    info->context=NULL;
    info->url=NULL;
    info->shouldFromNet=YES;
    info->flag=NULL;
    info->handleWithLocal=NULL;
    info->willPostData=NULL;
    return info;
}
@implementation YJDataCenter
+(void)handleWithNetworkStruct:(struct YJNetworkInfoStruct *)dataRef finish:(GetDataFinish)finish
{
    struct YJNetworkResultStruct result;
    NSError *error=NULL;
    result.context=dataRef;
    if (dataRef->shouldFromNet) {
        if ([SZNetwork networkExist])
        {
            NSString *jsonStr=[LYJsonCode jsonCodeWithDictionary:dataRef->infoDict];
            NSData *postData=dataRef->willPostData?dataRef->willPostData(jsonStr):[jsonStr dataUsingEncoding:4];
            result.data=[SZNetwork postDataWithURL:dataRef->url data:postData];
            result.fromNetwork=YES;
        }else{
            result.fromNetwork=YES;
            result.data=nil;
            result.context=dataRef;
            error=[NSError errorWithDomain:nil code:kYJErrorNoNetworkExist userInfo:nil];
            result.error=error;
        }
    }else{
        result.data=dataRef->handleWithLocal?dataRef->handleWithLocal(dataRef->infoDict,&error):NULL;
        result.fromNetwork=NO;
    }
    result.error=error;
    
    if (finish) finish(&result);
}
+(void)handleWithNetworkStruct:(struct YJNetworkInfoStruct *)dataRef finishFun:(GetDataFinishFun)finish
{
    struct YJNetworkResultStruct result;
    NSError *error=NULL;
    result.context=dataRef;
    if (dataRef->shouldFromNet) {
        if ([SZNetwork networkExist])
        {
            NSString *jsonStr=[LYJsonCode jsonCodeWithDictionary:dataRef->infoDict];
            NSData *postData=dataRef->willPostData?dataRef->willPostData(jsonStr):[jsonStr dataUsingEncoding:4];
            result.data=[SZNetwork postDataWithURL:dataRef->url data:postData];
            result.fromNetwork=YES;
        }else{
            result.fromNetwork=YES;
            result.data=nil;
            result.context=dataRef;
            error=[NSError errorWithDomain:nil code:kYJErrorNoNetworkExist userInfo:nil];
            result.error=error;
        }
    }else{
        result.data=dataRef->handleWithLocal?dataRef->handleWithLocal(dataRef->infoDict,&error):NULL;
        result.fromNetwork=NO;
    }
    result.error=error;
    if (finish) finish(&result);
}
@end

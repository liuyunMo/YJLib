//
//  LoginPopedomManager.h
//  YJFlash
//
//  Created by zhongyy on 13-8-15.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/*
 登录限制
 由于对于通过系统时间的判断来限制用户的登录，无法避免用户修改系统时间来达到获取权限的问题，依靠网络又不太可取，但这种方式不可抛弃，可为判断条件之一，在此基础上，额外增加如下条件，若均满足，则拥有登录的权限：
 
 1、登录次数的限制
 每次登录的时候对登录次数进行累加，达到指定数目，则提示登录被限制
 
 2、运行总时间的限制
 对于每次项目的运行时间进行统计，累计达到指定时间，则提示登录被限制
 
 
 
 另：以上信息均依靠本地文件的记录，若用户修改或者删除关联文件，则会提示登录被限制
 
 以上判断的触发会在用户每次与app交互中
 
 
 
 有关实现存在的问题
 
 1、以上信息依靠本地文件的记录，目前暂不知如何区分用户是第一次安装应用，还是用户把指定文件删除了
 
 暂定的解决方案是：对于文件的首次安装，另加判断机制，区分第一次安装和删除文件操作，判断机制  暂无
 */
#import <Foundation/Foundation.h>

#define YJCHECK_MAX_LOGIN_COUNT  5
#define YJCHECK_MAX_RUN_TIME     (8*3600)
#define YJCHECK_DEADLINE


enum
{
    kLoginTimeOut  =  1<<0,   //系统时间
    kLoginCountOut =  1<<1,   //登陆次数
    kRunTimeOut    =  1<<2,   //运行时间
    kOther         =  1<<3    //其他
};
typedef NSInteger LYCheckType;

@interface LoginPopedomManager : NSObject
+(BOOL)isFirstRun;
@end

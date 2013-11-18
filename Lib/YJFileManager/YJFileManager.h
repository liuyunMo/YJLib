//
//  YJFileManager.h
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/* 展示本地沙盒文件管理 */
#import <Foundation/Foundation.h>

@interface YJFileManager : NSObject
+(void)presentFileManagerViewControllerAt:(UIViewController *)viewContrller animation:(BOOL)animation;
@end

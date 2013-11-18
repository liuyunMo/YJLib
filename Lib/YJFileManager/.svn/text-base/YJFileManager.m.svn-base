//
//  YJFileManager.m
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFileManager.h"
#import "YJFileManagerViewController.h"
@implementation YJFileManager
+(void)presentFileManagerViewControllerAt:(UIViewController *)viewContrller animation:(BOOL)animation
{
    YJFileManagerViewController *rootVC=[[YJFileManagerViewController alloc] init];
    rootVC.folderPath=NSHomeDirectory();
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:rootVC];
    [viewContrller presentModalViewController:nav animated:animation];
    [rootVC release];
    [nav release];
}
@end

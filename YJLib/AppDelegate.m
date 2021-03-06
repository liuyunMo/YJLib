//
//  AppDelegate.m
//  YJLib
//
//  Created by zhongyy on 13-10-12.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "YJNavViewController.h"
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}
-(void)test
{
//    [YJTeleManager addTeleObserver];
//    [self showAlertWithMessage:[[YJTeleManager getCarrierInfo] description]];
//    [YJTeleManager observeTeleStatusWithBlock:^(NSString *statusDesc) {
//        NSLog(@"%@",statusDesc);
//    }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window=[YJWindow viewWithLayoutFileName:@"YJWindow"];
    
    ListViewController *list=OBJ_CREATE(ListViewController);
    YJNavViewController *nav=[[YJNavViewController alloc] initWithRootViewController:list];
   // nav.panActive=YES;
    self.window.rootViewController=nav;
    [list release];
    [nav release];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self test];
    return YES;
}

@end

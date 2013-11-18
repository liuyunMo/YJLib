//
//  YJViewController.h
//  YJSwear
//
//  Created by zhongyy on 13-8-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
 version : 2013.11.18
 
 增加初始化和传出数据的block
 增加flag标示
 */


#import <UIKit/UIKit.h>
typedef NSDictionary *(^InitProBlock)(void);
@interface YJViewController : UIViewController<YJFlagViewDelegate>
{
    @protected
    InitProBlock _initBlock;
    YJResBlock   _resBlock;
}
@property(nonatomic,copy)InitProBlock initBlock;
@property(nonatomic,copy)YJResBlock   resBlock;
@end

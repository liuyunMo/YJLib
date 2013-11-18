//
//  YJViewController.m
//  YJSwear
//
//  Created by zhongyy on 13-8-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJViewController.h"

@interface YJViewController ()

@end

@implementation YJViewController
@synthesize flagStr=_flagStr;
@synthesize initBlock=_initBlock;
@synthesize resBlock=_resBlock;
-(NSString *)flagStr
{
    if (!_flagStr)
    {
        self.flagStr=NSStringFromClass([self class]);
    }
    return _flagStr;
}
-(void)setInitBlock:(InitProBlock)initBlock
{
    SET_BLOCK(_initBlock, initBlock);
}
-(void)setResBlock:(YJResBlock)resBlock
{
    SET_BLOCK(_resBlock, resBlock);
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_initBlock);
    SAFE_BLOCK_RELEASE(_resBlock);
    [_flagStr release];
    [super dealloc];
}
@end

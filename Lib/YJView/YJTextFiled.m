//
//  YJTextFiled.m
//  YJHealth
//
//  Created by szfore on 13-7-10.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTextFiled.h"

@implementation YJTextFiled
@synthesize flagStr=_flagStr;
-(NSString*)flagStr
{
    if (!_flagStr) {
        return @"YJTextFiled";
    }
    return _flagStr;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_flagStr release];
    [super dealloc];
}
@end

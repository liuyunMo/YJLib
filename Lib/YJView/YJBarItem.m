//
//  YJBarItem.m
//  YJHealth
//
//  Created by szfore on 13-7-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJBarItem.h"
@implementation YJBarItem
-(void)setImageWithKey:(NSString *)key
{
    self.defaultImage=[YJImageManager getImageWithKeyString:key status:kYJImageStatusDefault];
    self.selectImage=[YJImageManager getImageWithKeyString:key status:kYJImageStatusSelected];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_selectColor release];
    [_defaultColor release];
    [_title release];
    [_defaultImage release];
    [_selectImage release];
    [super dealloc];
}
@end

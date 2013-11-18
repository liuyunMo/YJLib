//
//  NSArray+typeCheck.m
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "NSArray+typeCheck.h"

@implementation NSArray (typeCheck)
-(id)objectAtIndex:(NSUInteger)index classType:(Class)classType
{
    if (index>=self.count)return nil;
    id object=[self objectAtIndex:index];
    if (object&&[object isKindOfClass:classType]) return object;
    return nil;
}
@end

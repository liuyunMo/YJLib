//
//  NSDictionary+typeCheck.m
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "NSDictionary+typeCheck.h"

@implementation NSDictionary (typeCheck)
-(id)objectForKey:(id)aKey classType:(Class)classType
{
    id object=[self objectForKey:aKey];
    if (object&&[object isKindOfClass:classType]) return object;
    return nil;
}
@end

//
//  NSDictionary+typeCheck.h
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (typeCheck)
-(id)objectForKey:(id)aKey classType:(Class)classType;
@end

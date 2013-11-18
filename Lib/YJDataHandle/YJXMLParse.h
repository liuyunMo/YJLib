//
//  YJXMLParse.h
//  iTest
//
//  Created by szfore on 13-4-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/*2004 excel xml data only*/

#import <Foundation/Foundation.h>
#import "YJTestDefine.h"
@interface YJXMLParse : NSObject<NSXMLParserDelegate>
@property(nonatomic,retain)NSMutableString *str;
@property(nonatomic,retain)NSMutableArray *contentArr;
-(id)initWithFilePath:(NSString *)filePath;
@end

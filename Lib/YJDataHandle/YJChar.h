//
//  YJChar.h
//  TestYJFramework
//
//  Created by szfore on 13-5-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/* 字符处理  为文本展示搜索服务～ */
#import <Foundation/Foundation.h>

@interface YJChar : NSObject<NSCoding>
{
    char *aChar;
}
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGRect frame;
@property(nonatomic,assign)BOOL isReturnKey;
@property(nonatomic,assign)int location;
-(NSString *)description;
-(NSData *)data;
-(NSString *)aChar;
-(void)setAChar:(NSString *)charStr;
@end
@interface NSString (YJChar)
-(NSMutableArray *)getYJCharArrWithWidth:(float)contentWidth withFont:(UIFont *)font height:(void(^)(float height))block startX:(float)startX;
@end
@interface UIFont (YJChar)<NSCoding>
-(NSString *)description;
@end
//
//  YJEncrypt.m
//  TestYJFramework
//
//  Created by szfore on 13-5-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJEncrypt.h"
#define DEFAULT_SZFORE_KEY @"Szfore68638"
@implementation YJEncrypt
+(NSString *)md5:(NSString *)oriString
{
    const char *original_str = [oriString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return hash;
}
+(NSData *)encryptStringUseDefault:(NSString *)str
{
    NSString *key=[self md5:DEFAULT_SZFORE_KEY];
    const char *charStr=[str UTF8String];
    unsigned char *enChar=exclusiveORDataWithKey((unsigned char *)charStr,str.length, (unsigned char*)[key UTF8String]);
    NSData *data=[NSData dataWithBytes:enChar length:str.length];
    free(enChar);
    return data;
}
+(NSData *)encryptDataUseDefault:(NSData *)data
{
    CHECK_PAR_AND_RETURN_NULL(data);
    NSString *key=[self md5:DEFAULT_SZFORE_KEY];
    const char *charStr=[data bytes];
    unsigned char *enChar=exclusiveORDataWithKey((unsigned char *)charStr, data.length, (unsigned char*)[key UTF8String]);
    NSData *en_data=[NSData dataWithBytes:enChar length:data.length];
    free(enChar);
    return en_data;
}
@end
//
//  Function.m
//  TestYJFramework
//
//  Created by szfore on 13-6-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "Function.h"
#include <execinfo.h>
double distanceBetweenPoint(CGPoint p1,CGPoint p2)
{
    return sqrt(pow(p1.x-p2.x, 2)+pow(p1.y-p2.y, 2));
}
double getCurrentTimeSince1970(void)
{
    return [[NSDate date] timeIntervalSince1970];
}
NSString *getTimeStringWithIntSince1970(double time)
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    return [[NSString stringWithFormat:@"%@",date] substringToIndex:16];
}
NSString *getCurrentTimeString(void)
{
    return getTimeStringWithIntSince1970(getCurrentTimeSince1970());
}
unsigned char *exclusiveORDataWithKey(const unsigned char*data,int length,const unsigned char*key)
{
    unsigned char *encryptStr =(unsigned char *)malloc(length);
    unsigned char *p=encryptStr;
    
    for (int i=0; i<length; i++)
    {
        p[i]=data[i]^key[i%32];
        
    }
    return p;
}
id obj_create(NSString *classStr)
{
    NSLog(@"创建 %@ 对象",classStr);
    Class c=NSClassFromString(classStr);
    id obj=[[c alloc] init];
    return obj;      
}

YJEntironment currentEntironment(void)
{
#ifdef I5_SCREEN_SUPPORT
    if ([UIScreen mainScreen].bounds.size.height*[[UIScreen mainScreen] scale]==1136.0) return kEntironmentIPhone5;
    return kEntironmentIPhone4;
#else
    return kEntironmentIPhone4;
#endif
}
BOOL isRetina(void)
{
    return [[UIScreen mainScreen] scale]==2.0f;
}
id getSettingsBundleValueForTitle(NSString *title)
{
    CHECK_PAR_AND_RETURN_NULL(title);
    NSString *settingsBundle=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *arr=[dict objectForKey:@"PreferenceSpecifiers"];
    id value=nil;
    for(NSDictionary *subDict in arr)
    {
        NSString *key=[subDict objectForKey:@"Key"];
        if (key&&[[subDict objectForKey:@"Title"] isEqualToString:title])
        {
            value=[[NSUserDefaults standardUserDefaults] valueForKey:key];
            if (!value)
            {
                value=[subDict objectForKey:@"DefaultValue"];
            }
            break;
        }
    }
    return value;
}
id getSettingsBundleValueForId(NSString *idStr)
{
    CHECK_PAR_AND_RETURN_NULL(idStr);
    NSString *settingsBundle=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *arr=[dict objectForKey:@"PreferenceSpecifiers"];
    id value=nil;
    for(NSDictionary *subDict in arr)
    {
        NSLog(@"%@",subDict);
        NSString *key=[subDict objectForKey:@"Key"];
        if ([key isEqualToString:idStr])
        {
            value=[[NSUserDefaults standardUserDefaults] valueForKey:key];
            if (!value)
            {
                value=[subDict objectForKey:@"DefaultValue"];
            }
            break;
        }
    }
    return value;
}
NSString *stringDeleteWhitespaceAndNewline(NSString *str)
{
    CHECK_PAR_AND_RETURN_NULL(str);
    NSMutableString *mutableStr=[NSMutableString stringWithString:str];
    
    [mutableStr replaceOccurrencesOfString:@"\r\n" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, mutableStr.length)];
    
    [mutableStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mutableStr.length)];
    
    [mutableStr replaceOccurrencesOfString:@" " withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mutableStr.length)];
    
    if (mutableStr.length>0)return mutableStr;
    
    return nil;
}

NSString *phonetic(NSString *str)
{
    
    NSMutableString *source = [str mutableCopy];
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [source autorelease];
}


NSDictionary * getAppInfo(void)
{
    NSBundle *mainBundle=[NSBundle mainBundle];
    UIDevice *device=[UIDevice currentDevice];
    return @{
             @"appName":[mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"],
             @"version":[mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"],
             @"Device":device.model,
             @"system":[NSString stringWithFormat:@"%@ %@",device.systemName,device.systemVersion]
             };
}
NSDictionary * getDeviceInfo(void)
{
    return nil;
}
NSArray *getBacktrace()
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0; i<frames; i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

BOOL shouldUseNet(void)
{
    if ([SZNetwork currentNetworkType]==kNotReachable) return NO;
    id value=getSettingsBundleValueForTitle(@"离线浏览");
    if (value&&[value respondsToSelector:@selector(boolValue)]&&[value boolValue])return NO;
    return YES;
}
BOOL writhToFFPG(NSString *content,NSString *path)
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
    NSData *data=[content dataUsingEncoding:4];
    NSData *enData=[YJEncrypt encryptDataUseDefault:data];
    return [enData writeToFile:path atomically:YES];
}
NSString *readFromFFPG(NSString *path)
{
    CHECK_PAR_AND_RETURN_NULL(path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *enData=[NSData dataWithContentsOfFile:path];
        NSData *data=[YJEncrypt encryptDataUseDefault:enData];
        if (data) {
            NSString *str=[[NSString alloc] initWithData:data encoding:4];
            return [str autorelease];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
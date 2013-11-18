//
//  YJCrashRecorder.m
//  testCrashRecord
//
//  Created by szfore on 13-4-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCrashRecorder.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
const int32_t UncaughtExceptionMaximum=10;
@implementation YJCrashRecorder
void szfore_uncaughtExceptionHandler(NSException *exception)
{
    NSString *name=[exception name];
    NSString *reason=[exception reason];
    NSDictionary *userInfoDict=[exception userInfo];
    NSMutableString *userInfoStr=[NSMutableString stringWithString:@"{\n"];
    if (userInfoDict&&userInfoDict.count>0)
    {
        for (id str in [userInfoDict allKeys])
        {
            [userInfoStr appendFormat:@"     %@:%@\n",str,[userInfoDict objectForKey:str]];
        }
    }
    [userInfoStr appendFormat:@"}"];
    NSArray *addresses=[exception callStackReturnAddresses];
    NSArray *symbols=[exception callStackSymbols];
    NSMutableString *writeString=[NSMutableString stringWithFormat:@"异常崩溃记录\n=============%@==============\n\n",getCurrentTimeString()];
    [writeString appendFormat:@"*****name*****\n%@\n*****name*****\n\n",name];
    [writeString appendFormat:@"*****reason*****\n%@\n*****reason*****\n\n",reason];
    [writeString appendFormat:@"*****userInfoDict*****\n%@\n*****userInfoDict*****\n",userInfoStr];
    [writeString appendFormat:@"*****addresses*****\n%@\n*****addresses*****\n",[addresses description]];
    [writeString appendFormat:@"*****symbols*****\n%@\n*****symbols*****\n\n",[symbols componentsJoinedByString:@"\n"]];
    writeToFile(writeString);
    
    [[[[YJCrashRecorder alloc] init] autorelease] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}
-(void)handleException:(NSException *)exception
{
    UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"Crash！" message:[NSString stringWithFormat:@"You can try to continue but the application may be unstable.\nreason:%@",[exception reason]] delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Continue", nil];
    [al show];
    [al release];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed)
    {
        for (NSString *mode in (NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    
    signal(SIGILL, SIG_DFL);
    
    signal(SIGSEGV, SIG_DFL);
    
    signal(SIGFPE, SIG_DFL);
    
    signal(SIGBUS, SIG_DFL);
    
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqualToString:@"UncaughtExceptionHandlerSignalExceptionName"])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:@"UncaughtExceptionHandlerSignalKey"] intValue]);
    }else{
        exit(0);
        //[exception raise];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dismissed= buttonIndex==0;
}
+(NSString *)getCrashFilePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/crashInfo.ffpg"];
}
NSData * adjustDataToEncrypt(NSData *data)
{
    NSMutableData *valueData=[NSMutableData dataWithData:data];
    while (valueData.length%32!=0)
    {
        [valueData appendData:[@" " dataUsingEncoding:4]];
    }
    return valueData;
}
void writeToFile(NSString *content)
{
    NSString *path=[YJCrashRecorder getCrashFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *str=[NSString stringWithFormat:@"远界咨询\nprojectName:%@\nversion:%@\n\n\n",executableFile,version];
        NSData *data=adjustDataToEncrypt([str dataUsingEncoding:4]);
        [[NSFileManager defaultManager] createFileAtPath:path contents:[YJEncrypt encryptDataUseDefault:data] attributes:nil];
    }
    NSData *data=adjustDataToEncrypt([content dataUsingEncoding:4]);
    NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:path];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[YJEncrypt encryptDataUseDefault:adjustDataToEncrypt(data)]];
    [fileHandle closeFile];
}
+(void)setDefaultCrashRecord
{
    NSSetUncaughtExceptionHandler(&szfore_uncaughtExceptionHandler);
    YJSetUncaughtExceptionHandler();
}
+(void)resignDefaultCrashRecord
{
    NSSetUncaughtExceptionHandler(NULL);
    YJResignUncaughtExceptionHandler();
}
+(void)writeExceptionToFile:(NSException *)exception
{
    ((void(*)(NSException*))&szfore_uncaughtExceptionHandler)(exception);//嘎嘎......
}
void YJResignUncaughtExceptionHandler()
{
    signal(SIGABRT, NULL);
    signal(SIGILL, NULL);
    signal(SIGSEGV, NULL);
    signal(SIGFPE, NULL);
    signal(SIGBUS, NULL);
    signal(SIGPIPE, NULL);
}
void YJSetUncaughtExceptionHandler()
{
    signal(SIGABRT, YJSignalHandler);
    signal(SIGILL, YJSignalHandler);
    signal(SIGSEGV, YJSignalHandler);
    signal(SIGFPE, YJSignalHandler);
    signal(SIGBUS, YJSignalHandler);
    signal(SIGPIPE, YJSignalHandler);
}
void YJSignalHandler(int signal)
{
    volatile int UncaughtExceptionCount=0;
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount>UncaughtExceptionMaximum) return;
    NSDictionary *dict=@{
                         @"UncaughtExceptionHandlerSignalKey":@(signal),
                         @"callStack":getBacktrace()
                         };
    NSException *exception=[NSException exceptionWithName:@"UncaughtExceptionHandlerSignalExceptionName" reason:[NSString stringWithFormat:@"Signal %d was raised.",signal] userInfo:dict];
    
    szfore_uncaughtExceptionHandler(exception);
}
@end

//
//  YJCrashRecorder.h
//  testCrashRecord
//
//  Created by szfore on 13-4-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/* 异常捕获 */

#import "YJEncrypt.h"
@interface YJCrashRecorder : NSObject<UIAlertViewDelegate>
{
    BOOL dismissed;
}
+(void)setDefaultCrashRecord;
+(void)resignDefaultCrashRecord;
+(void)writeExceptionToFile:(NSException *)exception;
+(NSString *)getCrashFilePath;
@end

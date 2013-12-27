//
//  Function.h
//  TestYJFramework
//
//  Created by szfore on 13-6-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <UIKit/UIKit.h>

double distanceBetweenPoint(CGPoint p1,CGPoint p2);

double getCurrentTimeSince1970();
NSString *getTimeStringWithIntSince1970(double time);
NSString *getCurrentTimeString();

id obj_create(NSString *classStr);

unsigned char *exclusiveORDataWithKey(const unsigned char*data,int length,const unsigned char*key);


YJEntironment currentEntironment(void);
BOOL isRetina(void);
id getSettingsBundleValueForTitle(NSString *title);
id getSettingsBundleValueForId(NSString *idStr);
NSString *stringDeleteWhitespaceAndNewline(NSString *str);
NSString *phonetic(NSString *str);


NSDictionary * getAppInfo(void);
NSDictionary * getDeviceInfo(void);
NSArray *getBacktrace();

BOOL shouldUseNet(void);

BOOL writhToFFPG(NSString *content,NSString *path);
NSString *readFromFFPG(NSString *path);


UIImage *getScreenShot();

typedef void*(^iterBlock)();
typedef void(^iterHandleBlock)(id item);
void iterArray(NSArray *arr,iterHandleBlock handle);

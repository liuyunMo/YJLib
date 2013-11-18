//
//  YJView.h
//  TestYJFramework
//
//  Created by szfore on 13-5-23.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/*  
 version : 2013.11.18
 
 修改内容：
 
 说明
 有关文件中加载:
 
 初步设想：

 类从文件中加载，优先考虑，本地文件系统缓存的布局文件，本地布局文件保存在~Library/Caches/Layout_szfore
 图片资源缓存在~Library/Caches/Image_szfore
 
 */
#define YJLAYOUT_CLASS @"class"


#define YJLAYOUT_YJVIEW_FRAME @"frame"
#define YJLAYOUT_YJVIEW_BACKGROUND_COLOR @"backgroundColor"
#define YJLAYOUT_YJVIEW_TAG @"tag"


#import <UIKit/UIKit.h>
#import "YJViewDelegate.h"
@interface YJView : UIView

@end
//  2013-07-10;
@interface UIView (YJLayoutDelegate)<YJLayoutDelegate>
+(id)viewWithPlistFilePath:(NSString *)filePath;
+(id)viewWithLayoutDict:(NSDictionary *)dict;
-(void)addSubViewFromLayoutArray:(NSArray*)plistPaths;
@end
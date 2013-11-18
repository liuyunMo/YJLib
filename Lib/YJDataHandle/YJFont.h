//
//  YJFont.h
//  TestYJFramework
//
//  Created by szfore on 13-5-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJFont : UIFont

@end
@interface UIFont (YJFont)
+(UIFont*)getFontWithTTTName:(NSString *)ttfName size:(float)size;
@end
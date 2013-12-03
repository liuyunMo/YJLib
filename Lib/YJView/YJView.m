//
//  YJView.m
//  TestYJFramework
//
//  Created by szfore on 13-5-23.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJView.h"

@implementation YJView

- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
+(id)viewWithDefaultFile
{
    return nil;
}

@end

@implementation UIView (YJLayoutDelegate)
+(id)viewWithLayoutFileName:(NSString *)fileName
{
    if (!fileName) return nil;
    
    NSString *docPath=[LAYOUT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath]) {
        return [self viewWithPlistFilePath:docPath];
    }
    NSString *bunPath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bunPath])
    {
        return [self viewWithPlistFilePath:bunPath];
    }
     
    return nil;
}
+(id)viewWithPlistFilePath:(NSString *)filePath
{
    do {
        if (!filePath) break;
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])break;
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        if (!dict||![dict isKindOfClass:[NSDictionary class]]) break;
        return [self viewWithLayoutDict:dict];
    } while (0);
    return nil;
}
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    NSString *classStr=nil;
    if ([dict objectForKey:YJLAYOUT_CLASS]) {
        classStr=[dict objectForKey:YJLAYOUT_CLASS];
    }
    UIView *view=obj_create(classStr?classStr:NSStringFromClass([self class]));
    do {
        if (![view isKindOfClass:[UIView class]]) break;
        //frame
        NSString *frameStr=[dict objectForKey:YJLAYOUT_YJVIEW_FRAME];
        if (!frameStr) break;
        view.frame=getFrameFromLayoutWithFrameString(frameStr);
        
        //backgrounColor
        NSString *backgroundColorStr=[dict objectForKey:YJLAYOUT_YJVIEW_BACKGROUND_COLOR];
        if (backgroundColorStr)
        {
            view.backgroundColor=getColorFromLayoutWithColorString(backgroundColorStr);
        }
        
        //tag 
        NSString *tagStr=[dict objectForKey:YJLAYOUT_YJVIEW_TAG];
        if (tagStr)
        {
            view.tag=[tagStr intValue];
        }
        
        
        return [view autorelease];
        
    } while (0);
    NSLog(@"文件初始化失败！！！");
    SAFE_RELEASE(view);
    return nil;
}
-(void)addSubViewFromLayoutArray:(NSArray*)plistPaths;
{
    for (NSString *plistPath in plistPaths)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:plistPath];
            NSString *classStr=[dict objectForKey:YJLAYOUT_CLASS];
            UIView *view=[NSClassFromString(classStr) viewWithLayoutDict:dict];
            if(view)[self addSubview:view];
        }
    }
}
@end

@implementation UIView (ScreenShot)
-(UIImage *)getScreenShot
{
    UIGraphicsBeginImageContextWithOptions([self bounds].size, NO, 0.0f);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
@implementation UIView (ges)
-(void)removeGesWithGesClass:(Class)gesClass
{
    for (UIGestureRecognizer *ges in self.gestureRecognizers)
    {
        if ([ges isKindOfClass:gesClass]) {
            [self removeGestureRecognizer:ges];
        }
    }
}
@end

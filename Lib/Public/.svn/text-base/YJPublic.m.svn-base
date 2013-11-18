//
//  YJPublic.m
//  TestYJFramework
//
//  Created by szfore on 13-5-17.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJPublic.h"

@implementation YJPublic
+(YJEntironment)currentEntironment
{
#ifdef I5_SCREEN_SUPPORT
    if ([UIScreen mainScreen].bounds.size.height*[[UIScreen mainScreen] scale]==1136.0) return kEntironmentIPhone5;
    return kEntironmentIPhone4;
#else
    return kEntironmentIPhone4;
#endif
}
+(BOOL)isRetina
{
    return [[UIScreen mainScreen] scale]==2.0f;
}
+(id)getSettingsBundleValueForTitile:(NSString *)title
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
@end
@implementation UIImage (selectedStatus)
-(UIImage *)getSelectedStatusImage
{
    CGImageRef inImage = self.CGImage;
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 *m_PixelBuf = (UInt8 *)CFDataGetBytePtr(m_DataRef);
    
    int length = CFDataGetLength(m_DataRef);
    
    for (int i=0; i<length; i+=4) {
        int r = i;
        int g = i+1;
        int b = i+2;
        
        int red = m_PixelBuf[r];
        int green = m_PixelBuf[g];
        int blue = m_PixelBuf[b];
        
        m_PixelBuf[r] = red*.7;
        m_PixelBuf[g] = green*.7;
        m_PixelBuf[b] = blue*.7;
    }
    
    CGColorSpaceRef colorSpace=CGImageGetColorSpace(inImage);
    if (CGColorSpaceGetModel(colorSpace)!=kCGColorSpaceModelRGB)
    {
        printf("\n不支持的色彩空间:%d\n",CGColorSpaceGetModel(colorSpace));
    }
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(m_DataRef);
    
    return finalImage;
}
@end
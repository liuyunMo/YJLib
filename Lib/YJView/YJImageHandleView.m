//
//  YJImageHandleView.m
//  TestYJFramework
//
//  Created by szfore on 13-7-18.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJImageHandleView.h"
#import "YJDrawView.h"
#import "YJClipView.h"
#define YJIMGHV_DV_FLAG @"YJImageHandleView_YJDrawView"
#define YJIMGHV_CV_FLAG @"YJImageHandleView_YJClipView"
@interface YJImageHandleView()
{
    YJDrawView *drawView;
}
@end


@implementation YJImageHandleView
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame flagStr:flagStr])
    {
        drawView=[[YJDrawView alloc] initWithFrame:self.bounds flagStr:YJIMGHV_DV_FLAG];
        drawView.layer.borderWidth=1;
        drawView.layer.borderColor=[UIColor grayColor].CGColor;
        drawView.backgroundColor=[UIColor clearColor];
        drawView.lineColor=[UIColor redColor];
        drawView.lineWidth=1;
        [self addSubview:drawView];
        [drawView release];
        
        YJClipView *clipView=[[YJClipView alloc] initWithFrame:drawView.bounds flagStr:YJIMGHV_CV_FLAG];
        clipView.clipRect=CGRectMake(100, 100, 200, 200);
        [drawView addSubview:clipView];
        [clipView release];
    }
    return self;
}
-(void)setImage:(UIImage *)image
{
    SET_PAR(_image, image);
    
}
-(UIImage *)currentImage
{
    if (!_image) return nil;
    CGImageRef inImage = _image.CGImage;
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 *m_PixelBuf = (UInt8 *)CFDataGetBytePtr(m_DataRef);
    CGContextRef bitmapCtx = CGBitmapContextCreate(m_PixelBuf,
                                      CGImageGetWidth(inImage),
                                      CGImageGetHeight(inImage),
                                      CGImageGetBitsPerComponent(inImage),
                                      CGImageGetBytesPerRow(inImage),
                                      CGImageGetColorSpace(inImage),
                                      CGImageGetBitmapInfo(inImage)
                                      );
    float imageHeight=CGImageGetHeight(inImage);
    CGContextSaveGState(bitmapCtx);
    CGContextSetStrokeColorWithColor(bitmapCtx, drawView.lineColor.CGColor);
    CGContextSetLineWidth(bitmapCtx, drawView.lineWidth/_scale);
    CGContextScaleCTM(bitmapCtx, 1, -1);
    CGContextTranslateCTM(bitmapCtx, 0, -imageHeight);
    for (NSArray *line in [drawView getLines])
    {
        if (line.count<2) continue;
        CGPoint begin=[[line objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(bitmapCtx, begin.x/_scale, begin.y/_scale);
        for (int i=1; i<line.count; i++)
        {
            CGPoint point=[[line objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(bitmapCtx, point.x/_scale, point.y/_scale);
        }
        CGContextDrawPath(bitmapCtx, kCGPathStroke);
    }
    CGContextRestoreGState(bitmapCtx);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(bitmapCtx);
    UIImage *image=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(bitmapCtx);
    CFRelease(m_DataRef);
    return image;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGImageRef imageRef=self.image.CGImage;
    float width=rect.size.width;
    float imageWidth=CGImageGetWidth(imageRef);
    _scale=width/imageWidth;
    float imageHeight=CGImageGetHeight(imageRef)*width/imageWidth;
    CGRect imageRect=CGRectMake(0, 0, width, imageHeight);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -imageHeight);
    CGContextDrawImage(ctx, imageRect, imageRef);
    CGContextRestoreGState(ctx);
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_image release];
    [super dealloc];
}
@end

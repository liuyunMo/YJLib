//
//  YJLoadImageView.m
//  YJSwear
//
//  Created by zhongyy on 13-10-9.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJLoadImageView.h"
@interface YJLoadImageView()
@property(nonatomic,retain)NSURL *url;
@property(nonatomic,copy)NSString *savePath;
@property(nonatomic,retain)UIImage *defaultImage;
@end
@implementation YJLoadImageView

-(id)initWithUrl:(NSURL *)url savePath:(NSString *)savePath defaultImage:(UIImage *)defaultImage
{
    if (self=[super initWithImage:defaultImage])
    {
        self.url=url;
        self.savePath=savePath;
        self.defaultImage=defaultImage;
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self changeForUrl:self.url savePath:self.savePath];
    }
}
-(void)changeForUrl:(NSURL *)url savePath:(NSString *)savePath;
{
    self.url=url;
    self.savePath=savePath;
    [self addNetTmpView];
    [NSThread detachNewThreadSelector:@selector(downloadData) toTarget:self withObject:nil];
}
-(void)downloadDataFinished:(UIImage *)image
{
    [self removeNetTmpView];
    if (image) {
        self.image=image;
    }
}
-(void)downloadData
{
    UIImage *image=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.savePath]) {
        image=[UIImage imageWithContentsOfFile:self.savePath];
        if (!image) {
            image=DEFAULT_PPT;
            [[NSFileManager defaultManager] removeItemAtPath:self.savePath error:nil];
        }
    }else{
        NSData *data=[NSData dataWithContentsOfURL:self.url];
        image=[UIImage imageWithData:data];
        if (image) {
            [data writeToFile:self.savePath atomically:YES];
        }
    }
    
    [self performSelectorOnMainThread:@selector(downloadDataFinished:) withObject:image waitUntilDone:YES];
    [NSThread exit];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_url release];
    [_savePath release];
    [_defaultImage release];
    [super dealloc];
}
@end

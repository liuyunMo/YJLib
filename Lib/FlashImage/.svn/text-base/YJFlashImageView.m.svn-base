//
//  YJFlashImageView.m
//  YJHealth
//
//  Created by szfore on 13-7-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlashImageView.h"
@interface YJFlashImageView()
{
    UIScrollView *contentView;
    YJImageView *imageView;
}
@end
@implementation YJFlashImageView
-(id)initWithFrame:(CGRect)frame touchBlock:(void(^)(NSString *name,NSString *type,YJFlashImageView *flashImage))block
{
    if (self=[super initWithFrame:frame])
    {
        if (block)
        {
            SET_BLOCK(touchBlock, block);
        }
    }
    return self;
}
-(void)createFlashImageView
{
    if (!contentView)
    {
        contentView=[[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        [contentView release];
        
        if (!imageView)
        {
            imageView=[[YJImageView alloc] initWithFrame:self.bounds];
            imageView.userInteractionEnabled=YES;
            imageView.delegate_touch=self;
            [contentView addSubview:imageView];
            [imageView release];
        }
        [contentView setContentSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    }
}
-(void)addKeywordToView
{
    if (self.keywords.count<1) return;
    for (UILabel *la in contentView.subviews)
    {
        if ([la isKindOfClass:[UILabel class]]) [la removeFromSuperview];
    }
    
    float beginY=imageView.frame.size.height+10;
    float width=90;
    float height=20;
    float span=(self.bounds.size.width-3*90)/4;
    NSMutableArray *colorMuArr=[NSMutableArray array];
    for (int i=0; i<self.keywords.count; i++)
    {
        NSString *keyword=[self.keywords objectAtIndex:i];
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(span+(span+width)*(i%3),(height+5)*(i/3)+beginY,width, height)];
        la.text=keyword;
        la.userInteractionEnabled=YES;
        la.font=[UIFont boldSystemFontOfSize:15];
        la.textAlignment=UITextAlignmentCenter;
        [contentView addSubview:la];
        
        if (colorMuArr.count<1) {
            NSArray *colorArr=@[
                                COLOR_WITH_RGB(113,70,141),
                                COLOR_WITH_RGB(206,99,143),
                                COLOR_WITH_RGB(235,137,26),
                                COLOR_WITH_RGB(253,237,139),
                                COLOR_WITH_RGB(89,93,157),
                                COLOR_WITH_RGB(217,235,177)
                                ];
            [colorMuArr addObjectsFromArray:colorArr];
        }
        UIColor *color=[colorMuArr objectAtIndex:arc4random()%[colorMuArr count]];
        la.backgroundColor=color;
        [colorMuArr removeObject:color];
        la.textColor=[UIColor whiteColor];
        
        [la release];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithKeywordSelect:)];
        [la addGestureRecognizer:tap];
        [tap release];
    }
    float contentHeight=beginY+(height+5)*(self.keywords.count/3)+height;
    if (contentHeight>self.bounds.size.height)
    {
        [contentView setContentSize:CGSizeMake(self.bounds.size.width, contentHeight)];
    }
}
-(void)setUpImageToImageView
{
    [self createFlashImageView];
    CGImageRef imageRef=_image.CGImage;
    float imageWidth=CGImageGetWidth(imageRef);
    _scale=self.scale==0.0f?self.bounds.size.width/imageWidth:_scale;
    float width=imageWidth*self.scale;
    float height=CGImageGetHeight(imageRef)*self.scale;
    
    imageView.image=_image;
    
    CGRect rect=imageView.frame;
    rect.size.width=width;
    rect.size.height=height;
    imageView.frame=rect;
    
    
    
    if (height>self.bounds.size.height)
    {
        [contentView setContentSize:CGSizeMake(self.bounds.size.width, height)];
    }
    
    [self addKeywordToView];
}
-(void)handleWithKeywordSelect:(UITapGestureRecognizer *)tap
{
    if ([self.delegate_flash respondsToSelector:@selector(selectKeyword:flashImage:)])
    {
        [self.delegate_flash selectKeyword:[(UILabel *)tap.view text] flashImage:self];
    }
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    if (touchBlock) Block_release(touchBlock);
    [_image release];
    [_tapPlistPath release];
    [_keywords release];
    [super dealloc];
}
-(void)setImage:(UIImage *)image
{
    SET_PAR(_image, image);
    [self setUpImageToImageView];
}
-(void)setScale:(float)scale
{
    _scale=scale>0.0f?(scale>1.0?1.0f:scale):0.0f;
    [self setUpImageToImageView];
}
-(void)setTapPlistPath:(NSString *)tapPlistPath
{
    if (!imageView.image) return;
    SET_PAR(_tapPlistPath, tapPlistPath);
    [self createFlashImageView];
}
-(void)setKeywords:(NSArray *)keywords
{
    SET_PAR(_keywords, keywords);
    [self addKeywordToView];
}

#pragma mark-- YJTouchViewDelegate
-(void)viewToucheBegan:(UIView *)view touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate_flash respondsToSelector:@selector(touchHotAreaWithName:type:flashImage:)])
    {
        UITouch *to=[touches anyObject];
        CGPoint point=[to locationInView:view];
        NSMutableArray *tapAreas=[[NSMutableArray alloc] initWithContentsOfFile:self.tapPlistPath];
        for (NSDictionary *dict in tapAreas)
        {
            CGRect rect;
            rect.origin.x=[[dict objectForKey:@"x"] floatValue]*self.scale;
            rect.origin.y=[[dict objectForKey:@"y"] floatValue]*self.scale;
            rect.size.width=[[dict objectForKey:@"width"] floatValue]*self.scale;
            rect.size.height=[[dict objectForKey:@"height"] floatValue]*self.scale;
            if (CGRectContainsPoint(rect, point))
            {
                NSString *name=[dict objectForKey:@"name"];
                NSString *type=[dict objectForKey:@"type"];
                [self.delegate_flash touchHotAreaWithName:name type:type flashImage:self];
                break;
            }
        }
        [tapAreas release];
    }
}
@end

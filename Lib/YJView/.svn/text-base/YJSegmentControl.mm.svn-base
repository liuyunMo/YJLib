//
//  YJSegmentControl.m
//  iService
//
//  Created by szfore on 13-5-13.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJSegmentControl.h"

@implementation YJSegmentControl
-(void)setDefaultInYJSegmentControl
{
    self.backgroundColor=[UIColor whiteColor];
    self.defaultColor=[UIColor whiteColor];
    self.selectedColor=[UIColor orangeColor];
    self.lineColor=[UIColor lightGrayColor];
    self.textColor=[UIColor blackColor];
    self.selectIndex=0;
    self.clipsToBounds=YES;
}
-(id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titles
{
    if (self=[super initWithFrame:frame])
    {
        titleArr=[titles retain];
        itemCount=[titleArr count];
        itemWidth=frame.size.width/itemCount;
        [self setDefaultInYJSegmentControl];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr
{
    if (self=[super initWithFrame:frame])
    {
        self.imageArr=imageArr;
        itemWidth=frame.size.width/itemCount;
        [self setDefaultInYJSegmentControl];
    }
    return self;
}
-(void)setImageArr:(NSArray *)imageArr
{
    SET_PAR(_imageArr, imageArr);
    if (_imageArr)
    {
        isImageItem=YES;
        itemCount=[_imageArr count];
        [self setNeedsDisplay];
    }else{
        isImageItem=NO;
    }
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    itemWidth=frame.size.width/itemCount;
    self.layer.cornerRadius=frame.size.height/6;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_textColor release];
    [_imageArr release];
    [_lineColor release];
    [_defaultColor release];
    [_selectedColor release];
    [titleArr release];
    [super dealloc];
}
-(void)addTarget:(id)target action:(SEL)action
{
    target_seg=target;
    action_seg=action;
}
-(void)setSelectIndex:(int)selectIndex
{
    [self drawViewWithIndex:selectIndex];
}
-(void)drawViewWithIndex:(int)index
{
    float height=self.frame.size.height;
    CGRect lastRect=CGRectMake(itemWidth*self.selectIndex, 0, itemWidth, height);
    CGRect rect_now=CGRectMake(itemWidth*index, 0, itemWidth, height);
    _selectIndex=index;
    [self setNeedsDisplayInRect:lastRect];
    [self setNeedsDisplayInRect:rect_now];
    
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    
    
    for (int i=0; i<itemCount; i++)
    {
        CGRect itemRect=CGRectMake(i*itemWidth, 0, itemWidth, self.bounds.size.height);
        if (!isImageItem)
        {
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, (self.selectIndex==i?self.selectedColor:self.defaultColor).CGColor);
            CGContextFillRect(context, itemRect);
            CGContextRestoreGState(context);
        }
        if (titleArr)
        {
            [self.textColor setFill];
            NSString *title=[titleArr objectAtIndex:i];
            CGSize size=[title sizeWithFont:[UIFont systemFontOfSize:13]];
            CGRect titleRect=CGRectMake(i*itemWidth, (self.bounds.size.height-size.height)/2, itemWidth, size.height);
            CGContextSaveGState(context);
            [title drawInRect:titleRect withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
        }
        if (isImageItem)
        {
            UIImage *image=[self.imageArr objectAtIndex:i];
            if (i==self.selectIndex)
            {
                image=[image getSelectedStatusImage];
            }
            [image drawInRect:itemRect];
        }
    }
    
    
    if (!isImageItem)
    {
        CGContextSaveGState(context);
        for (int i=0; i<itemCount-1; i++)
        {
            CGContextMoveToPoint(context, (i+1)*itemWidth, 0);
            CGContextAddLineToPoint(context, (i+1)*itemWidth, self.bounds.size.height);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
    
    UIGraphicsPopContext();
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchesEnded:touches withEvent:event];
    UITouch *to=[touches anyObject];
    CGPoint point=[to locationInView:self];
    int index=getSelectIndexWith(itemWidth, point.x);
    if (index!=self.selectIndex)
    {
        [self drawViewWithIndex:index];
        [target_seg performSelector:action_seg withObject:self];
    }
}
int getSelectIndexWith(float itemWidth,float x)
{
    float itemIndex=x/itemWidth;
    return isInt(itemIndex)?(int)itemIndex-1:(int)itemIndex;
}
inline bool isInt(float f)
{
    return f-(int)f==0.0f;
}
@end

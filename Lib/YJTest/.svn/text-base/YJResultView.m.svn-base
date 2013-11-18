//
//  YJResultView.m
//  iTest
//
//  Created by szfore on 13-4-15.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJResultView.h"
@interface YJResultView()
{
    float height;
    BOOL tap;
}
@end
@implementation YJResultView


-(id)initWithFrame:(CGRect)frame count:(int)count
{
    int rowCount=count/5;
    rowCount=count%5==0?rowCount:rowCount+1;
    float frame_height=frame.size.height;
    float height_=rowCount*40+10;
    CGRect rect=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height_>frame_height?height_:frame_height);
    if (self=[super initWithFrame:rect])
    {
        self.count=count;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int rowCount=self.count/5;
    rowCount=self.count%5==0?rowCount:rowCount+1;
    float rowWidth=60,rowHeight=40;
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 1);
    for (int i=0; i<rowCount+1; i++)
    {
        CGContextMoveToPoint(context, 10, 5+i*rowHeight);
        CGContextAddLineToPoint(context, 310, 5+i*rowHeight);
        CGContextDrawPath(context, kCGPathStroke);
    }
    height=rowCount*60;
    for (int i=0; i<6; i++)
    {
        CGContextMoveToPoint(context, 10+i*rowWidth, 5);
        CGContextAddLineToPoint(context, 10+i*rowWidth, 5+rowHeight*rowCount);
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    for (int i=0; i<self.count; i++)
    {
        CGRect rect=CGRectMake(10+(i%5)*rowWidth+1, 5+(i/5)*rowHeight+1, rowWidth-2, rowHeight-2);
        [[self.datasource getBackgroundColorToShowWithIndex:i] set];
        CGContextFillRect(context, rect);
    }
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    for (int i=0; i<self.count; i++)
    {
        
        NSString *str=[self.datasource getStringToShowWithIndex:i];
        CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:15]];
        CGRect rect=CGRectMake(10+(i%5)*rowWidth+(rowWidth-size.width)/2, 5+(i/5)*rowHeight+(rowHeight-size.height)/2, size.width, size.height);
        
        [[self.datasource getTextColorToShowWithIndex:i] set];
        [str drawInRect:rect withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByTruncatingTail];
    }
    CGContextRestoreGState(context);
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    tap=YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    tap=NO;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!tap)return;
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    float x=point.x,y=point.y;
    int rowCount=[self getMaxIntFromFloat:(y-5)/40],column=[self getMaxIntFromFloat:(x-10)/60];
    int index=(rowCount-1)*5+column-1;
    if (index>self.count-1)return;
    if ([self.delegate respondsToSelector:@selector(selectItemAtIndex:)])
    {
        [self.delegate selectItemAtIndex:index];
    }
}
-(void)dealloc
{
    [super dealloc];
}
-(int)getMaxIntFromFloat:(float)a
{
    return a-(int)a!=0.0f?(int)a+1:(int)a;
}
@end

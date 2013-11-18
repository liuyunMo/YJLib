//
//  YJTouchView.m
//  testYJGridView
//
//  Created by szfore on 13-4-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTouchView.h"

@implementation YJTouchView
-(void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}

-(void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)handleTouchesCancel:(NSSet *)touches withEvent:(UIEvent *)event{}

-(void)handleWithTouchType:(YJTouchEvent)type touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (getPublicPro()->fun->touchEvent)
    {
        (*getPublicPro()->fun->touchEvent)(self,touches,event,type);
    }
}
#pragma mark-- Touch Event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleWithTouchType:kTouchEventBegan touches:touches withEvent:event];
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheBegan:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheBegan:self touches:touches withEvent:event];
    }
    [self handleTouchesBegan:touches withEvent:event];
    if(_passTouch)[self.nextResponder touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleWithTouchType:kTouchEventMoved touches:touches withEvent:event];
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheMove:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheMove:self touches:touches withEvent:event];
    }
    [self handleTouchesMoved:touches withEvent:event];
    if(_passTouch)[self.nextResponder touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleWithTouchType:kTouchEventEnded touches:touches withEvent:event];
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheEnd:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheEnd:self touches:touches withEvent:event];
    }
    [self handleTouchesEnded:touches withEvent:event];
    if(_passTouch)[self.nextResponder touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleWithTouchType:kTouchEventCancel touches:touches withEvent:event];
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheCancel:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheCancel:self touches:touches withEvent:event];
    }
    [self handleTouchesEnded:touches withEvent:event];
    if(_passTouch)[self.nextResponder touchesCancelled:touches withEvent:event];
}
@end

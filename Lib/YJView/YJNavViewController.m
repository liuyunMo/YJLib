//
//  YJNavViewController.m
//  TestYJFramework
//
//  Created by szfore on 13-6-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJNavViewController.h"
#define VALUE_TO_REMOVE 50
@interface YJNavViewController ()
{
    CGPoint lastTouchPoint;
    UIImageView *lastScreenShotView;
    UIImageView *currScreenShotView;
    
    NSMutableArray *screenShotList;
    UIPanGestureRecognizer *panGes;
}
@end

@implementation YJNavViewController
- (void)dealloc
{
    DEALLOC_PRINTF;
    [screenShotList release];
    [super dealloc];
}
-(UIImage *)getScreenShot
{
    return getScreenShot();
}
-(void)leftGesActive
{
    
}
-(void)rightGesActive
{
    [self popViewControllerAnimated:YES];
}

//pan ges handle
-(void)setPanActive:(BOOL)panActive
{
    _panActive=panActive;
    if (_panActive)
    {
        if (!panGes)
        {
            panGes=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesActive:)];
            [self.view addGestureRecognizer:panGes];
            [panGes release];
        }
        if (!screenShotList) {
            screenShotList=OBJ_CREATE(NSMutableArray);
        }
    }else{
        [self.view removeGestureRecognizer:panGes];
        panGes=nil;
    }
}
-(void)panGesActive:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan velocityInView:self.view];
    CGPoint touchPoint=[pan locationInView:self.view];
    float width=self.view.bounds.size.width;
    float height=self.view.bounds.size.height;
    NSLog(@"%@",[NSValue valueWithCGPoint:touchPoint]);
//    if (point.x>2000)
//    {
//        [self rightGesActive];
//    }
//    if (point.x<-2000) {
//        [self leftGesActive];
//    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            
            if (!currScreenShotView) {
                currScreenShotView=[[UIImageView alloc] initWithFrame:self.view.bounds];
                currScreenShotView.image=[self getScreenShot];
                [self.view.superview addSubview:currScreenShotView];
                [currScreenShotView release];
            }
            
            if (!lastScreenShotView) {
                lastScreenShotView=[[UIImageView alloc] initWithFrame:self.view.bounds];
                lastScreenShotView.image=[screenShotList lastObject];
                [self.view.superview insertSubview:lastScreenShotView belowSubview:currScreenShotView];
                [lastScreenShotView release];
            }
            lastScreenShotView.transform=CGAffineTransformMakeScale(.9, .9);
            lastScreenShotView.alpha=.5;
            
            self.view.hidden=YES;
            lastTouchPoint=[pan locationInView:self.view];
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (currScreenShotView.frame.origin.x>self.view.bounds.size.width/2)
            {
                [self popViewControllerAnimated:NO];
                
                [UIView animateWithDuration:.25 animations:^{
                    lastScreenShotView.transform=CGAffineTransformIdentity;
                    currScreenShotView.frame=CGRectMake(width, 0, width, height);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [currScreenShotView removeFromSuperview];
                        [lastScreenShotView removeFromSuperview];
                        currScreenShotView=nil;
                        lastScreenShotView=nil;
                        self.view.hidden=NO;
                    }
                }];
                
            }else{
                [UIView animateWithDuration:.25 animations:^{
                    lastScreenShotView.transform=CGAffineTransformMakeScale(.9, .9);
                    currScreenShotView.frame=self.view.bounds;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [currScreenShotView removeFromSuperview];
                        [lastScreenShotView removeFromSuperview];
                        currScreenShotView=nil;
                        lastScreenShotView=nil;
                        self.view.hidden=NO;
                    }
                }];
            }
        }
            break;
            
        default:
            break;
    }
    lastScreenShotView.transform=CGAffineTransformMakeScale(.9+touchPoint.x/(width*10), .9+touchPoint.x/(width*10));
    lastScreenShotView.alpha=touchPoint.x/width;
    
    CGRect rect=currScreenShotView.frame;
    rect.origin.x+=touchPoint.x-lastTouchPoint.x;
    currScreenShotView.frame=rect;
    
    lastTouchPoint=touchPoint;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_panActive)[screenShotList addObject:[self getScreenShot]];
    [super pushViewController:viewController animated:YES];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (_panActive)[screenShotList removeLastObject];
    return [super popViewControllerAnimated:YES];
}
@end

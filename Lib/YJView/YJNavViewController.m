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
    CGPoint touchBegin;
    UIImageView *lastScreenShotView;
    NSMutableArray *screenShotList;
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
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)initToMovePop
{
    screenShotList=[[NSMutableArray alloc] init];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithPanGesture:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}
-(void)handleWithPanGesture:(UIPanGestureRecognizer*)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!lastScreenShotView) {
                lastScreenShotView=[[UIImageView alloc] initWithFrame:self.view.bounds];
                lastScreenShotView.image=[screenShotList lastObject];
                [self.view.superview insertSubview:lastScreenShotView belowSubview:self.view];
                [lastScreenShotView release];
            }
            lastScreenShotView.transform=CGAffineTransformMakeScale(.9, .9);
            touchBegin=[pan locationInView:KEY_WINDOW];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint touchEnd=[pan locationInView:KEY_WINDOW];
            if (touchEnd.x-touchBegin.x>VALUE_TO_REMOVE)
            {
                [UIView animateWithDuration:.3 animations:^{
                    lastScreenShotView.transform=CGAffineTransformIdentity;
                    CGRect rect=self.view.bounds;
                    rect.origin.x=320;
                    self.view.frame=rect;
                } completion:^(BOOL finish){
                    [self popToRootViewControllerAnimated:NO];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                }];
            }
        }
            break;
        default:
            break;
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    if (_allowMoveToPop) [self initToMovePop];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_allowMoveToPop)[screenShotList addObject:[self getScreenShot]];
    [super pushViewController:viewController animated:YES];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (_allowMoveToPop)[screenShotList removeLastObject];
    return [super popViewControllerAnimated:YES];
}
@end

//
//  QDAlertView.m
//  QDAlertView
//
//  Created by zhongyuanyuan on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QDAlertView.h"
#define SHOW_TIME 1.5F

@implementation NSObject(UIAlertView_QD)
-(void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
    [al release];
}
@end
@implementation UIView(QDAlertView) 
-(QDAlertView *)getQDAlertViewOnSelf
{
    for(QDAlertView *alertView in self.subviews)
    {
        if ([alertView isKindOfClass:[QDAlertView class]])
        {
            return alertView;
        }
    }
    return nil;
}
-(void)showQDAlertViewWithMessage:(NSString *)message
{
    QDAlertView *al=[[QDAlertView alloc] initWithMessage:message];
    al.backgroundColor=[UIColor clearColor];
    [self addSubview:al];
    al.layer.cornerRadius=8.0f;
    [al release];
}
-(void)removeQDAlertView
{
    QDAlertView *al=[self getQDAlertViewOnSelf];
    [al removeFromSuperview];
}
@end
@interface QDAlertView()
{
    BOOL init;
    BOOL createSuccess;
    float animationTime;
    NSString *viewID;
}
@end
@implementation QDAlertView
@synthesize message;
@synthesize spanToBounds,textSpan,radius,borderWidth;
@synthesize bgColor,textColor,borderColor;
@synthesize font;
@synthesize position,animationType;
@synthesize dismissAnimation;
-(void)dealloc
{
    DEALLOC_PRINTF;
    [borderColor release];
    [textColor release];
    [font release];
    [bgColor release];
    [message release];
    [super dealloc];
}
-(void)setDefault
{
    self.font=[UIFont systemFontOfSize:10];
    self.borderWidth=2.0f;
    self.radius=8.0f;
    self.borderColor=[UIColor colorWithRed:35.3/255 green:34.9/255 blue:35.3/255 alpha:1.0f];
    self.bgColor=[UIColor colorWithRed:25.9/255 green:27.1/255 blue:25.9/255 alpha:1.0f];
    self.textSpan=8.0f;
    self.spanToBounds=50.0f;
    self.textColor=[UIColor whiteColor];
    self.position=kBottom;
    self.dismissAnimation=YES;
    self.animationType=kFade;
    init=YES;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (!init)
        {
            [self setDefault];
        }
    }
    return self;
}

-(id)initWithPosition:(QDAlertViewPosition)aPosition message:(NSString *)meg
{
    if (!init)
    {
        [self setDefault];
    }
    self.position=aPosition;
    self.message=meg;
    CGSize size=[self.message sizeWithFont:self.font];
    return [self initWithFrame:CGRectMake(0, 0, size.width+textSpan*2, size.height+textSpan*2)];
}
-(id)initWithMessage:(NSString *)meg
{
    if (!init)
    {
        [self setDefault];
    }
    self.message=meg;
    CGSize size=[self.message sizeWithFont:self.font];
    return [self initWithFrame:CGRectMake(0, 0, size.width+textSpan*2, size.height+textSpan*2)];
}
- (void)drawRect:(CGRect)rect
{
    float width=rect.size.width;
    float height=rect.size.height;
    
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextMoveToPoint(context, radius, 0);
    CGContextAddLineToPoint(context, width-radius, 0);
    CGContextAddArc(context, width-radius, radius, radius, -M_PI/2, 0, 0);
    CGContextAddLineToPoint(context, width, height-radius);
    CGContextAddArc(context, width-radius, height-radius, radius,0 , M_PI/2, 0);
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, M_PI*3/2, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    if (message)
    {
        [textColor set];
        [message drawAtPoint:CGPointMake(textSpan, textSpan) withFont:self.font];
    }
    
    UIGraphicsPopContext();
}
-(void)setupCenter:(CGSize)size
{
    switch (position) 
    {
        case kBottom:
            self.center=CGPointMake(size.width/2, size.height-spanToBounds-self.frame.size.height/2);
            break;
        case kTop:
            self.center=CGPointMake(size.width/2,spanToBounds+self.frame.size.height/2);
            break;
        case kCenter:
            self.center=CGPointMake(size.width/2, size.height/2);
            break;
        default:
            break;
    }
}
-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)postNotificationByName:(const NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)name object:object];
}
-(void)deviceOrientationDidChange:(NSNotification *)notification
{
    CGSize size=CGSizeZero;
    UIDevice *device=[notification object];
    switch (device.orientation)
    {
        case UIDeviceOrientationPortrait:
            size=self.superview.frame.size;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            size=self.superview.frame.size;
            break;
        case UIDeviceOrientationLandscapeLeft:
            size=CGSizeMake(self.superview.frame.size.height, self.superview.frame.size.width);
            break;
        case UIDeviceOrientationLandscapeRight:
            size=CGSizeMake(self.superview.frame.size.height, self.superview.frame.size.width);
            break;
            
        default:
            break;
    }
    [self setupCenter:size];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview!=nil) 
    {
        QDAlertView *vi=[newSuperview getQDAlertViewOnSelf];
        if (vi)
        {
            [vi removeFromSuperview];
        }
        //self.backgroundColor=newSuperview.backgroundColor;
        CGSize size=newSuperview.frame.size;
        [self setupCenter:size];
        [self addObservers];
        [self postNotificationByName:QDAlertViewWillMoveToSuperViewNotification object:newSuperview];
    }
    else
    {
        [self removeObservers];
        [self postNotificationByName:QDAlertViewRemoveFromSuperViewNotification object:nil];
    }
}
-(void)didMoveToSuperview
{
    //self.backgroundColor=[UIColor clearColor];
    [self performSelector:@selector(removeAnimation) withObject:nil afterDelay:1];
    [self postNotificationByName:QDAlertViewDidMoveToSuperViewNotification object:self];
}
-(void)removeAnimation
{
    if (dismissAnimation||!message) 
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationTime];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        switch (animationType) 
        {
            case kFade:
                self.alpha=0.0f;
                break;
                
            case kPush:
            {
                CGSize size=self.superview.frame.size;
                switch (position)
                {
                    case kBottom:
                        self.center=CGPointMake(size.width/2, size.height+self.frame.size.height/2);
                        break;
                    case kTop:
                        self.center=CGPointMake(size.width/2, 0-self.frame.size.height/2);
                        break;
                    case kCenter:
                        self.center=CGPointMake(0-size.width, self.center.y);
                        break;
                    default:
                        break;
                }
            }
                break;
                
            case kClose:
                self.frame=CGRectMake(self.frame.origin.x, self.center.y, self.frame.size.width, 0);
                break;
                
                
            default:
                break;
        }
        [UIView commitAnimations];
        [self performSelector:@selector(animationFinished) withObject:nil afterDelay:animationTime];
    }
    if (!message)
    {
        NSError *error=[NSError errorWithDomain:@"提示不能为空" code:1 userInfo:nil];
        [self postNotificationByName:QDAlertViewErrorNotification object:error];
    }
}
-(void)animationFinished
{
    [self removeFromSuperview];
}
-(void)setAnimationType:(QDAlertViewAnimationType)type
{
    animationType=type;
    switch (animationType) 
    {
        case kFade:
            animationTime=0.5f;
            break;
        case kPush:
            animationTime=0.2f;
            break;
        case kClose:
            animationTime=0.1f;
            break;
        default:
            break;
    }
}
-(void)setPosition:(QDAlertViewPosition)aPosition
{
    position=aPosition;
    [self setupCenter:self.superview.frame.size];
}
-(void)setFont:(UIFont *)aFont
{
    [font release];
    font=aFont;
    [font retain];
    self.message=self.message;
    [self setupCenter:self.superview.frame.size];
}
-(void)setMessage:(NSString *)aMessage
{
    [message release];
    message=aMessage;
    [message retain];
    CGSize size=[self.message sizeWithFont:self.font];
    CGRect rect=self.frame;
    rect.size=CGSizeMake(size.width+textSpan*2, size.height+textSpan*2);
    self.frame=rect;
    [self setupCenter:self.superview.frame.size];
}
-(void)setTextSpan:(float)span
{
    textSpan=span;
    self.message=self.message;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.superview)
    {
        super.backgroundColor=self.superview.backgroundColor;
    }
}
-(void)setSpanToBounds:(float)span
{
    spanToBounds=span;
    [self setupCenter:self.superview.frame.size];
}
-(void)setDismissAnimation:(BOOL)dismiss
{
    dismissAnimation=dismiss;
    if (self.superview)
    {
        [self performSelector:@selector(removeAnimation) withObject:nil afterDelay:SHOW_TIME];
    }
}
@end
const NSString *QDAlertViewErrorNotification=@"QDAlertViewErrorNotification";
const NSString *QDAlertViewWillMoveToSuperViewNotification=@"QDAlertViewWillMoveToSuperViewNotification";
const NSString *QDAlertViewDidMoveToSuperViewNotification=@"QDAlertViewDidMoveToSuperViewNotification";
const NSString *QDAlertViewRemoveFromSuperViewNotification=@"QDAlertViewRemoveFromSuperViewNotification";
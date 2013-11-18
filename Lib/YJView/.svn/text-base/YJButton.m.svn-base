//
//  YJButton.m
//  testYJGridView
//
//  Created by szfore on 13-4-28.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJButton.h"
#define key_image_default_button @"defaultImageKey_but"
#define key_image_moving_button @"movingImageKey_but"
#define key_image_selected_button @"selectedImageKey_but"
#define title_default_button @"title_but"

#define BACKGROUNDIMAGE_FLAG @"YJButtonBackgroundYJButton"
@interface YJButton()
{
    BOOL tapEvent;
    CGPoint beginPoint;
}
@property(nonatomic,retain)UIImage *defaultImage;
@property(nonatomic,retain)UIImage *selectImage;
@property(nonatomic,retain)UIImage *movingImage;
@end
@implementation YJButton
-(void)createViewYJButton
{
    if (!backgroundImageView)
    {
        backgroundImageView=[[YJImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.flagStr=BACKGROUNDIMAGE_FLAG;
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
    }
    if (!titleLable)
    {
        titleLable=[[UILabel alloc] initWithFrame:self.bounds];
        titleLable.textAlignment=UITextAlignmentCenter;
        titleLable.font=[UIFont systemFontOfSize:12];
        titleLable.textColor=[UIColor whiteColor];
        titleLable.lineBreakMode=NSLineBreakByTruncatingMiddle;
        titleLable.backgroundColor=[UIColor clearColor];
        [self addSubview:titleLable];
        [titleLable release];
    }
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    backgroundImageView.frame=self.bounds;
    titleLable.frame=self.bounds;
}
-(void)setDefault
{
    self.status=kYJButtonStatusDefault;
    self.event=kYJButtonEventTouchUpInside;
    [self createViewYJButton];
}
+(id)buttonWithFrame:(CGRect)frame event:(ButtonPressed_block)block
{
    YJButton *bu=[[YJButton alloc] initWithFrame:frame];
    if (bu)
    {
        [bu setButtonPressed_block:block forYJButtonEvent:kYJButtonEventTouchUpInside];
        [bu setDefault];
    }
    return [bu autorelease];
}
-(id)initWithFrame:(CGRect)frame event:(ButtonPressed_block)block
{
    if(self=[super initWithFrame:frame])
    {
        eventBlock=Block_copy(block);
        [self setDefault];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setDefault];
    }
    return self;
}
-(void)setUpSelectImageWithDefaultImage
{
    self.selectImage=[self.defaultImage getSelectedStatusImage];
}
-(UILabel *)titleLabel
{
    [self createViewYJButton];
    return titleLable;
}
-(void)setImage:(UIImage *)image forYJButtonStatus:(YJButtonStatus)status
{
    switch (status)
    {
        case kYJButtonStatusDefault:
            self.defaultImage=image;
            break;
        case kYJButtonStatusMove:
            self.movingImage=image;
            break;
        case kYJButtonStatusSelected:
            self.selectImage=image;
            break;
        default:
            break;
    }
    [self setUpBackgroupImage];
}
-(void)setImageWithKeyString:(NSString *)keyString
{
    self.defaultImage=[YJImageManager getImageWithKeyString:keyString status:kYJImageStatusDefault];
    self.movingImage=[YJImageManager getImageWithKeyString:keyString status:kYJImageStatusMoving];
    self.selectImage=[YJImageManager getImageWithKeyString:keyString status:kYJImageStatusSelected];
    [self setUpBackgroupImage];
}
-(void)setButtonPressed_block:(ButtonPressed_block)block forYJButtonEvent:(YJButtonEvent)event
{
    if (eventBlock)
    {
        Block_release(eventBlock);
    }
    eventBlock=Block_copy(block);
    self.event=event;
}
-(void)setStatus:(YJButtonStatus)status
{
    _status=status;
    [self setUpBackgroupImage];
}
-(void)setUpBackgroupImage
{
    [self createViewYJButton];
    switch (_status)
    {
        case kYJButtonStatusDefault:
            
            backgroundImageView.image=self.defaultImage;
            break;
        case kYJButtonStatusMove:
            
            backgroundImageView.image=self.movingImage?self.movingImage:self.defaultImage;
            break;
        case kYJButtonStatusSelected:
            
            backgroundImageView.image=self.selectImage?self.selectImage:self.defaultImage;
            break;
        default:
            break;
    }
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    Block_release(eventBlock);
    [_defaultImage release];
    [_selectImage release];
    [_movingImage release];
    [super dealloc];
}
-(void)respondsToButtonEvent
{
    if (eventBlock){
        eventBlock(self);
    }else{
        if (getPublicPro()->fun->buttonPressed_function)
        {
            (*getPublicPro()->fun->buttonPressed_function)(self);
        }else{
            printf("\n请指定按钮的click事件！！！\n");
        }
    }
}
-(void)handleWithMoved:(CGPoint)point
{
    CGPoint center=self.center;
    center.x+=point.x;
    center.y+=point.y;
    if (center.x>self.superview.bounds.size.width-self.bounds.size.width/2||center.x<self.bounds.size.width/2) return;
    if (center.y>self.superview.bounds.size.height-self.bounds.size.height/2||center.y<self.bounds.size.height/2) return;
    self.center=center;
}
-(void)handleEventBegin
{
    self.status=kYJButtonStatusSelected;
}
-(void)handleEventEnd
{
    self.status=kYJButtonStatusDefault;
}
#pragma mark--  YJTouchViewDelegate Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchesBegan:touches withEvent:event];
    tapEvent=YES;
    [self handleEventBegin];
    if (self.event==kYJButtonEventTouchDown)
    {
        [self performSelector:@selector(respondsToButtonEvent) withObject:nil afterDelay:self.moveAble?.2:0];
    }
    UITouch *touch=[touches anyObject];
    beginPoint=[touch locationInView:self.superview];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchesMoved:touches withEvent:event];
    if (self.moveAble)
    {
        tapEvent=NO;
        self.status=kYJButtonStatusMove;
        [YJButton cancelPreviousPerformRequestsWithTarget:self selector:@selector(respondsToButtonEvent) object:nil];
        UITouch *touch=[touches anyObject];
        CGPoint move=[touch locationInView:self.superview];
        [self handleWithMoved:CGPointMake(move.x-beginPoint.x, move.y-beginPoint.y)];
        beginPoint=move;
    }else{
        tapEvent=YES;
        self.status=kYJButtonStatusSelected;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchesEnded:touches withEvent:event];
    if (tapEvent&&self.event==kYJButtonEventTouchUpInside)
    {
        [self respondsToButtonEvent];
    }
    [self handleEventEnd];
}
#pragma mark--  YJLayoutDelegate Methods
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    YJButton *but=[super viewWithLayoutDict:dict];
    if (but&&[but isKindOfClass:[YJButton class]])
    {
        //imageKey
        NSString *imageKey=[dict objectForKey:YJLAYOUT_YJBUTTON_IMAGE_KEY];
        if (imageKey&&[imageKey isKindOfClass:[NSString class]]) {
            [but setImageWithKeyString:imageKey];
        }
        
        
        //title
        NSString *title=[dict objectForKey:YJLAYOUT_YJBUTTON_TITLE];
        if (title&&[title isKindOfClass:[NSString class]]) {
            but.titleLabel.text=title;
        }
        
        //moveAble
        BOOL moveAble=[dict objectForKey:YJLAYOUT_YJBUTTON_MOVE_ABLE]?[[dict objectForKey:YJLAYOUT_YJBUTTON_MOVE_ABLE] boolValue]:NO;
        but.moveAble=moveAble;
        
        //fontSize
        NSNumber *fontSize=[dict objectForKey:YJLAYOUT_YJBUTTON_FONT_SIZE];
        if (fontSize&&[fontSize isKindOfClass:[NSNumber class]]) {
            but.titleLabel.font=[UIFont systemFontOfSize:[fontSize floatValue]];
        }
    }
    return but;
}
@end
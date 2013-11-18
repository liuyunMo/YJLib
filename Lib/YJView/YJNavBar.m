

#define key_image_backgroud_nav @"backgroudImageKey_nav"
#define title_nav @"title_nav"
#define title_left_nav @"title_left_nav"
#define title_right_nav @"title_right_nav"

#define LEFT_ITEM_FLAG @"YJNavBarLeftItem"
#define RIGHT_ITEM_FLAG @"YJNavBarRightItem"
#import "YJNavBar.h"

@implementation YJNavBar

-(void)dealloc
{
    DEALLOC_PRINTF;
    [_title release];
    [_backgroundImage release];
    [super dealloc];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame flagStr:nil])
    {
        height=frame.size.height;
        [self setUpShadowWithOffset:CGSizeMake(0, 2)];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    height=frame.size.height;
}
-(void)setTitle:(NSString *)title
{
    SET_PAR(_title, title);
    if (!titleLa)
    {
        titleLa=[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 210, height)];
        titleLa.textAlignment=UITextAlignmentCenter;
        titleLa.backgroundColor=[UIColor clearColor];
        titleLa.textColor=[UIColor whiteColor];
        //titleLa.textColor=[UIColor blackColor];
        titleLa.font=[UIFont boldSystemFontOfSize:22];
        //[titleLa setUpShadowWithOffset:CGSizeMake(-1, -1)];
        [self addSubview:titleLa];
        [titleLa release];
        
        
    }
    titleLa.text=_title;
}
-(void)handleWithLeftItemPressed
{
    if ([self.delegate_navBar respondsToSelector:@selector(leftItemPressed:nav:)])
    {
        [self.delegate_navBar leftItemPressed:leftItem nav:self];
    }
}
-(void)createLeftItmWithDict:(NSDictionary *)dict
{
    if (leftItem)[leftItem removeFromSuperview];
    __block typeof(self) bSelf=self;
    if (!dict)
    {
        leftItem=[[YJButton alloc] initWithFrame:CGRectMake(5, (height-30)/2, 50, 30)];
        [leftItem setImage:getNavBarItemDefaultBackgroupImage() forYJButtonStatus:kYJButtonStatusDefault];
        [leftItem setImage:getNavBarItemSelectedBackgroupImage() forYJButtonStatus:kYJButtonStatusSelected];
    }else{
        leftItem=[[YJButton viewWithLayoutDict:dict] retain];
    }
    leftItem.layer.cornerRadius=4;
    leftItem.flagStr=LEFT_ITEM_FLAG;
    leftItem.clipsToBounds=YES;
    [leftItem setButtonPressed_block:^(YJButton *bu){[bSelf handleWithLeftItemPressed];} forYJButtonEvent:kYJButtonEventTouchUpInside];
    [self addSubview:leftItem];
}
-(void)createRightItmWithDict:(NSDictionary *)dict
{
    if (rightItem)[rightItem removeFromSuperview];
    __block typeof(self) bSelf=self;
    if (!dict)
    {
        rightItem=[[YJButton alloc] initWithFrame:CGRectMake(265, (height-30)/2, 50, 30)];
        [rightItem setImage:getNavBarItemDefaultBackgroupImage() forYJButtonStatus:kYJButtonStatusDefault];
        [rightItem setImage:getNavBarItemSelectedBackgroupImage() forYJButtonStatus:kYJButtonStatusSelected];
        
    }else{
        rightItem=[[YJButton viewWithLayoutDict:dict] retain];
    }
    [rightItem setButtonPressed_block:^(YJButton *bu){[bSelf handleWithRightItemPressed];} forYJButtonEvent:kYJButtonEventTouchUpInside];
    rightItem.layer.cornerRadius=4;
    rightItem.flagStr=RIGHT_ITEM_FLAG;
    rightItem.clipsToBounds=YES;
    [self addSubview:rightItem];
    [rightItem release];
}
-(void)setShowLeftItem:(BOOL)showLeftItem
{
    _showLeftItem=showLeftItem;
    if (_showLeftItem)
    {
        if (leftItem) return;
        [self createLeftItmWithDict:NULL];
    }else{
        if (leftItem)
        {
            [leftItem removeFromSuperview];
            leftItem=nil;
        }
    }
}

-(void)setShowRightItem:(BOOL)showRightItem
{
    _showRightItem=showRightItem;
    if (_showRightItem)
    {
        if (rightItem) return;
        [self createRightItmWithDict:NULL];
    }else{
        if (rightItem)
        {
            [rightItem removeFromSuperview];
            rightItem=nil;
        }
    }
}
-(void)handleWithRightItemPressed
{
    if ([self.delegate_navBar respondsToSelector:@selector(rightItemPressed:nav:)])
    {
        [self.delegate_navBar rightItemPressed:rightItem nav:self];
    }
}
-(void)setUpLeftItemTitle:(NSString *)leftTitle
{
    if (_showLeftItem&&leftItem)
    {
        leftItem.titleLabel.text=leftTitle;
    }
}
-(void)setUpRightItemTitle:(NSString *)rightTitle
{
    if (_showRightItem&&rightItem)
    {
        rightItem.titleLabel.text=rightTitle;
    }
}
-(void)setDelegate_navBar:(id<YJNavBarDelegate>)delegate_navBar
{
    _delegate_navBar=delegate_navBar;
    self.delegate_touch=_delegate_navBar;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    if (self.backgroundImage)
    {
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextDrawImage(context, self.bounds, self.backgroundImage.CGImage);
    }else{
        setUpNavBackground(context);
    }
}
#pragma mark--  YJLayoutDelegate Methods
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    YJNavBar *nav=[super viewWithLayoutDict:dict];
    if (nav&&[nav isKindOfClass:[YJNavBar class]])
    {
        NSDictionary *leftDict=[dict objectForKey:YJLAYOUT_YJNAVBAR_LEFT_ITEM];
        if (leftDict&&[leftDict isKindOfClass:[NSDictionary class]])
        {
            [nav createLeftItmWithDict:leftDict];
        }
        NSDictionary *rightDict=[dict objectForKey:YJLAYOUT_YJNAVBAR_RIGHT_ITEM];
        if (rightDict&&[rightDict isKindOfClass:[NSDictionary class]])
        {
            [nav createRightItmWithDict:rightDict];
        }
        
        NSString *bgImageKey=[dict objectForKey:YJLAYOUT_YJNAVBAR_BACKGROUNG_IMAGE ];
        if (bgImageKey&&[bgImageKey isKindOfClass:[NSString class]])
        {
            nav.backgroundImage=[YJImageManager getImageWithKeyString:bgImageKey];
        }
        
        NSString *title=[dict objectForKey:YJLAYOUT_YJNAVBAR_TITLE];
        if (title&&[title isKindOfClass:[NSString class]])
        {
            nav.title=title;
        }
    }
    return nav;
}
@end

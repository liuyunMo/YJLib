
#import "LYScrollView.h"
#define TRANSITION_TIME_MAX 0.5f
#define TRANSITION_TIME_MIN 0.15f
@interface LYScrollView()
{
    CGPoint beginPoint;
    UIImageView *currentImageView;
    UIImageView *nextImageView;
    UIView *currentView;
    UIView *nextView;
    NSTimer *timer;
    float timeCount;//计时
    BOOL countTime;//是否计时
    UIPageControl *pageControl;
    BOOL scrolling;//是否正在滚动
}
@property(nonatomic,retain)NSArray *items;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,retain)NSDate *beginDate;
@end
@implementation LYScrollView
@synthesize beginDate=_beginDate;
@synthesize items=_items;
@synthesize currentIndex=_currentIndex;
@synthesize dataSource=_dataSource;
@synthesize autoScroll=_autoScroll;
@synthesize showTime=_showTime;
@synthesize transitionTime=_transitionTime;
@synthesize criticalValueToResponse=_criticalValueToResponse;
@synthesize type=_type;
#pragma mark 初始化处理
-(void)createView
{
    self.clipsToBounds=YES;
    currentImageView=[[UIImageView alloc] initWithImage:[self.items objectAtIndex:0]];
    currentImageView.frame=self.bounds;
    [self addSubview:currentImageView];
    //[currentImageView release];
    
    nextImageView=[[UIImageView alloc] initWithImage:[self.items objectAtIndex:0]];
    nextImageView.frame=CGRectZero;
    [self addSubview:nextImageView];
    //[nextImageView release];
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    pageControl.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
    pageControl.numberOfPages=self.items.count;
    pageControl.userInteractionEnabled=NO;
    [self addSubview:pageControl];
    //[pageControl release];
}
-(void)setDefaultValue
{
    _showTime=5.0;
    _transitionTime=.5;
    _criticalValueToResponse=20;
    _type=kRight;
    scrolling=NO;
}

#pragma mark 初始化方法
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame dataSource:(id<LYScrollViewDataSource>) dataSource autoScroll:(BOOL)autoScroll
{
    if (self=[super initWithFrame:frame])
    {
        self.items=arr;
        [self createView];
        [self setDefaultValue];
        self.autoScroll=autoScroll;
        self.dataSource=dataSource;
    }
    return self;
}
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame autoScroll:(BOOL)autoScroll
{
    return [self initWithImageArray:arr withFrame:frame dataSource:nil autoScroll:autoScroll];
}
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame dataSource:(id<LYScrollViewDataSource>) dataSource
{
    return [self initWithImageArray:arr withFrame:frame dataSource:dataSource autoScroll:NO];
}
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame
{
    return [self initWithImageArray:arr withFrame:frame dataSource:nil autoScroll:NO];
}
-(id)initWithPathArray:(NSArray *)pathArr withFrame:(CGRect)frame
{
    return nil;
}
-(id)initWithFrame:(CGRect)frame
{
    return nil;
}
-(id)init
{
    return nil;
}

#pragma mark 属性设置
-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll=autoScroll;
    if (_autoScroll)
    {
        timer=[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timeCountToAnimation) userInfo:nil repeats:YES];
        countTime=YES;
        
    }else
    {
        if (timer)
        {
            [timer invalidate];
            timer=nil;
            countTime=NO;
        }
    }
}
-(void)setCurrentIndex:(int)currentIndex
{
    _currentIndex=currentIndex;
    if (currentIndex>=[self.items count])
    {
        _currentIndex=0;
    }
    if (currentIndex<0)
    {
        _currentIndex=[self.items count]-1;
    }
    pageControl.currentPage=_currentIndex;
}
-(void)setDataSource:(id<LYScrollViewDataSource>)dataSource
{
    _dataSource=dataSource;
    if ([self.dataSource respondsToSelector:@selector(viewForImageView:atIndex:)])
    {
        [currentView removeFromSuperview];
        [currentView release];
        currentView=nil;
        currentView=[self.dataSource viewForImageView:nextImageView atIndex:self.currentIndex];
        if (currentView)
        {
            [currentView retain];
            [self addSubview:currentView];
            [self bringSubviewToFront:currentView];
        }
    }
}
#pragma mark  定时器处理自动滚动
-(void)scrollAuto
{
    if (!countTime)
    {
        return;
    }
    self.transitionTime=TRANSITION_TIME_MAX;
    switch (_type)
    {
        case kRight:
            [self leftMoveToIndex:_currentIndex+1];
            break;
        case kLeft:
            [self rightMove];
            break;
            
        default:
            break;
    }
}
-(void)timeCountToAnimation
{
    if (countTime)
    {
        timeCount+=0.1;
        if (timeCount>=_showTime)
        {
            timeCount=0;
            [self scrollAuto];
        }
    }
}
#pragma mark 其他方法
-(void)hiddenPageControl:(BOOL)hidden
{
    pageControl.hidden=hidden;
}
-(void)setPageControlBackgroundColor:(UIColor *)color
{
    pageControl.backgroundColor=color;
}
-(void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
}
#pragma mark 动画处理
-(void)animationDidStop
{
    [currentView removeFromSuperview];
    currentView=nextView;
    nextView=nil;
    timeCount=0;
    countTime=YES;
    scrolling=NO;
}
-(void)leftMoveToIndex:(int)index
{
    _currentIndex=index-1;
    countTime=NO;
    scrolling=YES;
    self.currentIndex+=1;
    nextImageView.image=[self.items objectAtIndex:_currentIndex];
    nextImageView.frame=CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    if ([self.dataSource respondsToSelector:@selector(viewForImageView:atIndex:)])
    {
        nextView=[self.dataSource viewForImageView:nextImageView atIndex:self.currentIndex];
        if (nextView)
        {
            [nextView retain];
            CGRect rect_custom=nextView.frame;
            rect_custom.origin.x+=self.bounds.size.width;
            nextView.frame=rect_custom;
            [self insertSubview:nextView belowSubview:pageControl];
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:_transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    nextImageView.frame=self.bounds;
    CGRect rect=currentImageView.frame;
    rect.origin.x=-self.bounds.size.width;
    currentImageView.frame=rect;
    if (currentView)
    {
        CGRect rect_custom=currentView.frame;
        rect_custom.origin.x-=self.bounds.size.width;
        currentView.frame=rect_custom;
    }
    if (nextView)
    {
        CGRect rect_custom=nextView.frame;
        rect_custom.origin.x-=self.bounds.size.width;
        nextView.frame=rect_custom;
    }
    [UIView commitAnimations];
    UIImageView *tmp=currentImageView;
    currentImageView=nextImageView;
    nextImageView=tmp;
    
    if ([self.dataSource respondsToSelector:@selector(willScrollToWithAtIndex:scrollView:)])
    {
        [self.dataSource willScrollToWithAtIndex:_currentIndex scrollView:self];
    }
}
-(void)scrollToIndex:(int)index animation:(BOOL)animation
{
    if (scrolling)
    {
        return;
    }
    if (animation)
    {
        self.transitionTime=TRANSITION_TIME_MAX;
        [self leftMoveToIndex:index];
    }
    else {
        self.transitionTime=0;
        [self leftMoveToIndex:index];
    }
}
-(void)rightMove
{
    countTime=NO;
    scrolling=YES;
    self.currentIndex-=1;
    nextImageView.image=[self.items objectAtIndex:_currentIndex];
    nextImageView.frame=CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    if ([self.dataSource respondsToSelector:@selector(viewForImageView:atIndex:)])
    {
        nextView=[self.dataSource viewForImageView:nextImageView atIndex:self.currentIndex];
        if (nextView)
        {
            CGRect rect_custom=nextView.frame;
            rect_custom.origin.x-=self.bounds.size.width;
            nextView.frame=rect_custom;
            [self insertSubview:nextView belowSubview:pageControl];
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:_transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    nextImageView.frame=self.bounds;
    CGRect rect=currentImageView.frame;
    rect.origin.x=self.bounds.size.width;
    currentImageView.frame=rect;
    if (currentView)
    {
        CGRect rect_custom=currentView.frame;
        rect_custom.origin.x+=self.bounds.size.width;
        currentView.frame=rect_custom;
    }
    if (nextView)
    {
        CGRect rect_custom=nextView.frame;
        rect_custom.origin.x+=self.bounds.size.width;
        nextView.frame=rect_custom;
    }
    [UIView commitAnimations];
    UIImageView *tmp=currentImageView;
    currentImageView=nextImageView;
    nextImageView=tmp;
    
    if ([self.dataSource respondsToSelector:@selector(willScrollToWithAtIndex:scrollView:)])
    {
        [self.dataSource willScrollToWithAtIndex:_currentIndex scrollView:self];
    }
}
#pragma mark   释放相关
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview==nil)
    {
        //使不可滚动，注销定时器
        self.autoScroll=NO;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_beginDate release];
    [pageControl release];
    [currentView release];
    [nextView release];
    [currentImageView release];
    [nextImageView release];
    [_items release];
    [super dealloc];
}
#pragma mark touch 事件处理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    beginPoint=[touch locationInView:self];
    self.beginDate=[NSDate date];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (scrolling)
    {
        return;
    }
    UITouch *touch=[touches anyObject];
    CGPoint endPoint=[touch locationInView:self];
    self.transitionTime=[[NSDate date] timeIntervalSinceDate:self.beginDate]*2.5;
    self.transitionTime=self.transitionTime>TRANSITION_TIME_MAX?TRANSITION_TIME_MAX:self.transitionTime;
    self.transitionTime=self.transitionTime<TRANSITION_TIME_MIN?TRANSITION_TIME_MIN:self.transitionTime;
    if (endPoint.x-beginPoint.x>_criticalValueToResponse)
    {
        timeCount=0;
        [self rightMove];
    }
    if (beginPoint.x-endPoint.x>_criticalValueToResponse)
    {
        timeCount=0;
        [self leftMoveToIndex:_currentIndex+1];
    }
}
@end


#import "LYRoundProgressView.h"

#define PRO_STR_FONT [UIFont systemFontOfSize:10]
#define PRO_STR_COLOR [UIColor blackColor]
@interface LYRoundProgressView()
{
    NSString *proStr;
}
@property(nonatomic,assign)float radius;
@end
@implementation LYRoundProgressView
@synthesize loopWidth=_loopWidth;
@synthesize loopDefaultColor=_loopDefaultColor;
@synthesize loopHighlightedColor=_loopHighlightedColor;
@synthesize minValue=_minValue;
@synthesize maxValue=_maxValue;
@synthesize progress=_progress;
@synthesize radius=_radius;
@synthesize type=_type;
#pragma mark--  初始化
-(void)setDefaultValue
{
    _loopWidth=10;
    _maxValue=1.0f;
    self.progress=0.5f;
    _minValue=0.0f;
    _type=kRoundBound;
    self.loopDefaultColor=[UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1.0];
    self.loopHighlightedColor=[UIColor colorWithRed:29.0/255.0 green:99.0/255.0 blue:183.0/255.0 alpha:1.0];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaultValue];
    }
    return self;
}
-(id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 40, 40)];
}
-(id)initWithloopDefaultColor:(UIColor *)loopDefaultColor loopHighlightedColor:(UIColor *)loopHighlightedColor frame:(CGRect)frame
{
    if (self=[self initWithFrame:frame]) 
    {
        self.loopDefaultColor=loopDefaultColor;
        self.loopHighlightedColor=loopHighlightedColor;
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        float width=self.frame.size.width;
        float height=self.frame.size.height;
        self.radius=width>height?height:width;
    }
}
#pragma mark--释放
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_loopDefaultColor release];
    [_loopHighlightedColor release];
    [super dealloc];
}
#pragma mark--属性设置
-(void)setProgress:(float)value
{
    _progress=value>self.minValue?(value>self.maxValue?self.maxValue:value):self.minValue;
    [proStr release];
    proStr=[[NSString alloc] initWithFormat:@"%.1f%@",_progress*100,@"%"];
    [self setNeedsDisplay];
}
#pragma mark--绘图操作
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(_loopWidth, _loopWidth, self.radius-2*_loopWidth, self.radius-2*_loopWidth));
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.radius, self.radius));
    CGContextSetFillColorWithColor(context, self.loopDefaultColor.CGColor);
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextRestoreGState(context);
    
    float angle=self.progress*2*M_PI/(self.maxValue-self.minValue);
    float radius=self.radius/2-self.loopWidth/2;
    float x=self.radius/2+radius*cos(angle);
    float y=self.radius/2+radius*sin(angle);
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.loopHighlightedColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.loopHighlightedColor.CGColor);
    CGContextMoveToPoint(context, self.radius-self.loopWidth, self.radius/2);
    CGContextAddArc(context, self.radius/2, self.radius/2, self.radius/2-self.loopWidth, 0, angle, 0);
    switch (self.type)
    {
        case kRoundBound:
            CGContextAddArc(context, x, y, self.loopWidth/2, angle, angle+M_PI, 0);
            CGContextAddArc(context, self.radius/2, self.radius/2, self.radius/2, angle,0 , 1);
            CGContextAddArc(context, self.radius-self.loopWidth/2, self.radius/2, self.loopWidth/2, 2*M_PI, M_PI, 0);
            break;
        case kPlainBound:
            CGContextAddLineToPoint(context, self.radius/2+self.radius*cos(angle), self.radius/2+self.radius*sin(angle));
            CGContextAddArc(context, self.radius/2, self.radius/2, self.radius/2, angle,0 , 1);
            CGContextAddLineToPoint(context, self.radius-self.loopWidth, self.radius/2);
            break;
    }
    
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextRestoreGState(context);
    
    if (!_hiddenProStr) {
        CGContextSaveGState(context);
        CGSize size=[proStr sizeWithFont:PRO_STR_FONT];
        [PRO_STR_COLOR setFill];
        [proStr drawInRect:CGRectMake(self.loopWidth, self.radius/2-size.height/2, self.radius-self.loopWidth*2, size.height) withFont:PRO_STR_FONT lineBreakMode:NSLineBreakByTruncatingMiddle alignment:UITextAlignmentCenter];
        CGContextRestoreGState(context);
    }
    
    
    UIGraphicsPopContext();
}

@end

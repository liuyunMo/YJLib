


#import "YJFlagView.h"

@implementation YJFlagView

@synthesize flagStr=_flagStr;

-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame])
    {
        self.flagStr=flagStr;
    }
    return self;
}
-(NSString *)flagStr
{
    if (!_flagStr)
    {
        self.flagStr=NSStringFromClass([self class]);
    }
    return _flagStr;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_flagStr release];
    [super dealloc];
}
#pragma mark--  YJLayoutDelegate Methods
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    YJFlagView *view=[super viewWithLayoutDict:dict];
    if (view&&[view isKindOfClass:[YJFlagView class]])
    {
        //flag
        NSString *flag=[dict objectForKey:YJLAYOUT_YJVIEW_FLAG];
        if (flag&&[flag isKindOfClass:[NSString class]]) {
            view.flagStr=flag;
        }
    }
    return view;
}
@end
@implementation UIView (YJFlagView)
-(YJFlagView *)getYJFlagViewWithFlag:(NSString *)flag
{
    for (YJFlagView *vi in self.subviews)
    {
        if ([vi conformsToProtocol:NSProtocolFromString(@"YJFlagViewDelegate")]&&[vi.flagStr isEqualToString:flag])
        {
            return vi;
        }
    }
    return nil;
}
-(void)setUpShadowWithOffset:(CGSize)offSize
{
    self.layer.shadowOffset=offSize;
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    self.layer.shadowRadius=-M_PI/2.0;
    self.layer.shadowOpacity=.8;
    
}
@end
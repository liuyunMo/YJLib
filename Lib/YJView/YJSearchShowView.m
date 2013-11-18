


#import "YJSearchShowView.h"

@implementation YJSearchShowView
-(void)createViewInYJSearchShowView
{
    if (!_searchView)
    {
        _searchView=[[YJSearchView alloc] initWithString:self.contentString frame:CGRectMake(0, self.startHeight, self.bounds.size.width, self.bounds.size.height-self.startHeight)];
        _searchView.backgroundColor=[UIColor clearColor];
        _searchView.delegate=self;
        [self addSubview:_searchView];
        [_searchView release];
        
    }
    CGRect rect=_searchView.frame;
    rect.origin.y=self.startHeight;
    _searchView.frame=rect;
    float contentHeight=self.startHeight+_searchView.frame.size.height;
    self.contentSize=CGSizeMake(self.contentSize.width, contentHeight);
}
-(id)initWithString:(NSString *)string frame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.contentString=string;
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_contentString release];
    [super dealloc];
}
//
-(void)setContentString:(NSString *)contentString
{
    SET_PAR(_contentString, contentString);
    [self createViewInYJSearchShowView];
}
-(void)setStartHeight:(float)startHeight
{
    _startHeight=startHeight;
    [self createViewInYJSearchShowView];
}
#pragma mark--  YJSearchViewDelegate
-(void)frameChangedToRect:(CGRect)toRect searchView:(YJSearchView *)searchView
{
    [self createViewInYJSearchShowView];
}
-(void)tapCharString:(YJChar *)charStr inSearchVeiw:(YJSearchView *)searchView keyword:(NSString *)keyword keywordIndex:(int)index
{
    NSLog(@"%@_%@",charStr.aChar,[NSValue valueWithCGRect:charStr.frame]);
    NSLog(@"%@_%d",keyword,index);
}
@end

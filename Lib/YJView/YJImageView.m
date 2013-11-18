

#import "YJImageView.h"
#define image_key_imageView @"imageKey_imageView"
@implementation YJImageView
@synthesize flagStr=_flagStr;
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr
{
    if (self=[super initWithFrame:frame])
    {
        self.flagStr=flagStr;
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_flagStr release];
    [super dealloc];
}
#pragma YJLayoutDelegate methods
+(id)viewWithPlistFilePath:(NSString *)filePath
{
    return nil;
}
+(id)viewWithLayoutDict:(NSDictionary *)dict
{
    return nil;
}
-(void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}
#pragma mark-- Touch Event
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheBegan:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheBegan:self touches:touches withEvent:event];
    }
    [self handleTouchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheMove:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheMove:self touches:touches withEvent:event];
    }
    [self handleTouchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate_touch respondsToSelector:@selector(viewToucheEnd:touches:withEvent:)])
    {
        [self.delegate_touch viewToucheEnd:self touches:touches withEvent:event];
    }
    [self handleTouchesEnded:touches withEvent:event];
}
@end
@implementation UIView (YJImageView)
-(NSString *)addImageUseDefaultScale:(UIImage *)image origin:(CGPoint)point
{
    CGImageRef imageRef=image.CGImage;
    float width=CGImageGetWidth(imageRef)/2;
    float height=CGImageGetHeight(imageRef)/2;
    YJImageView *im=[[YJImageView alloc] initWithFrame:CGRectMake(point.x, point.y, width, height)];
    im.image=image;
    im.flagStr=[NSString stringWithFormat:@"default"];
    [self addSubview:im];
    [im release];
    return im.flagStr;
}
@end

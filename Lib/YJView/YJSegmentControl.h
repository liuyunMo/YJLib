



#import "YJTouchView.h"
#import <QuartzCore/QuartzCore.h>

@interface YJSegmentControl : YJTouchView
{
    id target_seg;
    SEL action_seg;
    NSArray *titleArr;
    int itemCount;
    float itemWidth;
    BOOL isImageItem;
}
@property(nonatomic,assign)int selectIndex;
@property(nonatomic,retain)UIColor *defaultColor;
@property(nonatomic,retain)UIColor *selectedColor;
@property(nonatomic,retain)UIColor *lineColor;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,retain)NSArray *imageArr;
-(id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titles;
-(id)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr;
-(void)addTarget:(id)target action:(SEL)action;
-(void)setDefaultInYJSegmentControl;
@end

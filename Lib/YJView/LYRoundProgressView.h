/*
 环形的进度条 分为平角和圆角两种类型 
 */

#import <UIKit/UIKit.h>
enum
{
    //圆角边界类型，圆角半径为环宽的一半
    kRoundBound=0,
    //平行边界类型
    kPlainBound
};
typedef NSInteger QDRoundProgressViewType;
@interface LYRoundProgressView : UIView
//环形宽度
@property(nonatomic,assign)float loopWidth;
//环背景颜色
@property(nonatomic,retain)UIColor *loopDefaultColor;
//环progress颜色
@property(nonatomic,retain)UIColor *loopHighlightedColor;
//最小值
@property(nonatomic,assign)float minValue;
//最大值
@property(nonatomic,assign)float maxValue;
//当前值
@property(nonatomic,assign)float progress;
//边界类型
@property(nonatomic,assign)QDRoundProgressViewType type;
@property(nonatomic,assign)BOOL hiddenProStr;
//初始化方法 
-(id)initWithloopDefaultColor:(UIColor *)loopDefaultColor loopHighlightedColor:(UIColor *)loopHighlightedColor frame:(CGRect)frame;
@end

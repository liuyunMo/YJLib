

#import <UIKit/UIKit.h>
@protocol LYScrollViewDataSource;
@interface LYScrollView : UIView
enum{
    kRight=0,
    kLeft
};
typedef NSInteger autoScrollType;
//是否自动滚动 默认为NO
@property(nonatomic,assign)BOOL autoScroll;
//每个界面的显示时间  默认为1.0s
@property(nonatomic,assign)NSTimeInterval showTime;
//过渡时间    0-0.5 默认为0.5s
@property(nonatomic,assign)NSTimeInterval transitionTime; 
//touch响应X轴临界值，默认为20
@property(nonatomic,assign)float criticalValueToResponse;
//自动滚动时  滚动的方向  自动滚动时有效
@property(nonatomic,assign)autoScrollType type;
@property(nonatomic,assign)id<LYScrollViewDataSource> dataSource;
//初始化方法  注意init方法回返回nil 数组元素为UIImage对象
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame;
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame autoScroll:(BOOL)autoScroll;
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame dataSource:(id<LYScrollViewDataSource>) dataSource;
-(id)initWithImageArray:(NSArray *)arr withFrame:(CGRect)frame dataSource:(id<LYScrollViewDataSource>) dataSource autoScroll:(BOOL)autoScroll;
-(id)initWithPathArray:(NSArray *)pathArr withFrame:(CGRect)frame;
//滚动到指定索引的位置 索引是元素在UIImage 数组的索引  如果正在滚动中，则调用此方法无效
-(void)scrollToIndex:(int)index animation:(BOOL)animation;
// 隐藏PageControl 对象（只是隐藏）
-(void)hiddenPageControl:(BOOL)hidden;
// 设置PageControl的背景色
-(void)setPageControlBackgroundColor:(UIColor *)color;
@end


@protocol LYScrollViewDataSource <NSObject>
@optional
//对应索引  自定义视图 
-(UIView *)viewForImageView:(UIImageView *)imageView atIndex:(int)index;
-(void)willScrollToWithAtIndex:(int)index scrollView:(LYScrollView *)scrollView;
@end
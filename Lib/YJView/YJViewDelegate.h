

@class UIEvent,YJFlagView,YJButton;

@protocol YJCardViewDelegate,YJCardViewDataSource;

@protocol YJGridViewDelegate,YJGridViewDataSource;

@protocol YJLoginViewDelegate;

@protocol YJTabBarDelegate;

@protocol YJMainViewDelegate;

@protocol YJFlashImageViewDelegate;

@protocol YJFlagViewDelegate <NSObject>
@property(nonatomic,copy)NSString *flagStr;
@end

@protocol YJTouchViewDelegate <NSObject>
@optional
-(void)viewToucheBegan:(UIView<YJFlagViewDelegate> *)view touches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)viewToucheMove:(UIView<YJFlagViewDelegate> *)view touches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)viewToucheEnd:(UIView<YJFlagViewDelegate> *)view touches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)viewToucheCancel:(UIView<YJFlagViewDelegate> *)view touches:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@protocol YJTouchDelegate <NSObject>

@optional
-(void)view:(UIView*)view singleTapDetected:(UITouch *)touch;
-(void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
-(void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;
@end

//定义如下  dict Keys


@protocol YJLayoutDelegate <NSObject>
+(id)viewWithPlistFilePath:(NSString *)filePath;
+(id)viewWithLayoutDict:(NSDictionary *)dict;
@end







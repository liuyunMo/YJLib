


/*
 定义如下：
 //YJImageView dictKeyDefines
 #define image_key_imageView @"imageKey_imageView"
 */
#import "YJViewDelegate.h"
#import "YJImageManager.h"
#import "YJFlagView.h"
@interface YJImageView : UIImageView<YJFlagViewDelegate,YJLayoutDelegate>
@property(nonatomic,assign)id<YJTouchViewDelegate>delegate_touch;
-(id)initWithFrame:(CGRect)frame flagStr:(NSString *)flagStr;
-(void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end
@interface UIView (YJImageView)
-(NSString *)addImageUseDefaultScale:(UIImage *)image origin:(CGPoint)point;
@end
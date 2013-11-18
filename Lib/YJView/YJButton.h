
/*
 定义如下：
 //YJButton dictKeyDefines
 #define key_image_default_button @"defaultImageKey_but"
 #define key_image_moving_button @"movingImageKey_but"
 #define key_image_selected_button @"selectedImageKey_but"
 #define title_default_button @"title_but"
 
 #define BACKGROUNDIMAGE_FLAG @"YJButtonBackgroundYJButton"
 */

#import "YJImageManager.h"
#import "YJImageView.h"
#import "YJTouchView.h"
#define YJLAYOUT_YJBUTTON_IMAGE_KEY @"imageKey"
#define YJLAYOUT_YJBUTTON_TITLE     @"title"
#define YJLAYOUT_YJBUTTON_MOVE_ABLE @"moveAble"
#define YJLAYOUT_YJBUTTON_FONT_SIZE @"fontSize"
@class YJButton;
enum  {
    kYJButtonEventDefault=0,
    kYJButtonEventTouchDown = 1,
    kYJButtonEventTouchUpInside = kYJButtonEventDefault
};
typedef NSInteger YJButtonEvent;
enum  {
    kYJButtonStatusDefault= 0,
    kYJButtonStatusSelected = 1,
    kYJButtonStatusMove=2
};
typedef NSInteger YJButtonStatus;
typedef void (^ButtonPressed_block)(YJButton*bu);
@interface YJButton : YJTouchView
{
    ButtonPressed_block eventBlock;
    YJImageView *backgroundImageView;
    UILabel *titleLable;
}
@property(nonatomic,assign)YJButtonEvent event;
@property(nonatomic,assign)BOOL moveAble;
@property(nonatomic,assign)YJButtonStatus status;
@property(nonatomic,readonly)UILabel *titleLabel;
-(void)setDefault;
+(id)buttonWithFrame:(CGRect)frame event:(ButtonPressed_block)block;
-(id)initWithFrame:(CGRect)frame event:(ButtonPressed_block)block;
-(void)setImage:(UIImage *)image forYJButtonStatus:(YJButtonStatus)status;
-(void)setImageWithKeyString:(NSString *)keyString;
-(void)setButtonPressed_block:(ButtonPressed_block)block forYJButtonEvent:(YJButtonEvent)event;
-(void)setUpSelectImageWithDefaultImage;

//
-(void)handleEventBegin;
-(void)handleEventEnd;
@end

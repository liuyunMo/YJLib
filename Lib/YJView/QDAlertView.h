//
//  QDAlertView.h
//  QDAlertView
//
//  Created by zhongyuanyuan on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
enum 
{
    kTop=1,
    kCenter,
    kBottom
};
typedef NSInteger QDAlertViewPosition;
enum 
{
    kFade=1,
    kPush,
    kClose,
};
typedef NSInteger QDAlertViewAnimationType;
@interface QDAlertView : UIView
@property (nonatomic,retain) UIColor *bgColor;//背景颜色
@property (nonatomic,retain) UIColor *textColor;//字体颜色；
@property (nonatomic,retain) UIColor *borderColor;//边框的颜色
@property (nonatomic,assign) float spanToBounds;//与窗口的间距
@property (nonatomic,assign) float textSpan;//文字与边框的间距
@property (nonatomic,assign) float radius;//圆角半径
@property (nonatomic,assign) float borderWidth;//边缘线宽
@property (nonatomic,retain) UIFont *font;//字体  默认13号字体
@property (nonatomic,copy) NSString *message;//消息提示；
@property (nonatomic,assign) QDAlertViewPosition position;//位置
@property (nonatomic,assign) BOOL dismissAnimation;//是否自动移出  默认自动移出
@property (nonatomic,assign) QDAlertViewAnimationType animationType;
-(id)initWithPosition:(QDAlertViewPosition)aPosition message:(NSString *)meg;
-(id)initWithMessage:(NSString *)meg;
-(void)setDefault;//恢复默认设置；
@end
@interface NSObject(UIAlertView_QD)
-(void)showAlertWithMessage:(NSString *)message;
@end
@interface UIView(QDAlertView) 
-(QDAlertView *)getQDAlertViewOnSelf;
-(void)showQDAlertViewWithMessage:(NSString *)message;
-(void)removeQDAlertView;
@end
extern const NSString *QDAlertViewErrorNotification;
extern const NSString *QDAlertViewWillMoveToSuperViewNotification;
extern const NSString *QDAlertViewDidMoveToSuperViewNotification;
extern const NSString *QDAlertViewRemoveFromSuperViewNotification;
//
//  YJDatePickerView.h
//  YJSwear
//
//  Created by zhongyy on 13-8-26.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

//初步检测   pick释放不掉  导致 YJDatePickerView释放不掉  我勒个擦  静态分析找不到，目测  block问题  有待进一步优化！！！
//我晕  这畸形的设计    释放不是本类问题  已确定


@interface YJDatePickerView : NSObject
typedef void(^TimeSelect)(NSString *timeStr);
@property(nonatomic,copy)YJResBlock finishBlock;
@property(nonatomic,copy)TimeSelect selectTime;
@property(nonatomic,retain)NSDate *date;
-(void)showInView:(UIView *)view aniamtion:(BOOL)animation;
-(void)dissmissAnimation:(BOOL)animation;
@end

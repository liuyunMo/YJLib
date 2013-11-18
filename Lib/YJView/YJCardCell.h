//
//  YJCardCell.h
//  iService
//
//  Created by szfore on 13-5-7.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTouchView.h"
#import "YJQuartz2DFunction.h"
/*
#define BACKGROUNDIMAGE_FLAG @"YJCardCellBackgroundImage"
#define CARDIMAGE_FLAG @"YJCardCellCardImage"
#define ACCESSIMAGE_FLAG @"YJCardCellAccessImage"
 */
@interface YJCardCell : YJTouchView
{
    UILabel *titleLabel;
    YJImageView *backgroudImageView;
    YJImageView *cardImageView;
    YJImageView *accessImageView;
}
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)UIImage*cardImage;
@property(nonatomic,retain)UIImage *backgroudImage;
@property(nonatomic,retain)UIImage *accessImage;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL selected;
@end
@interface UIView (YJCardCell)
-(YJCardCell *)getCardCellWithIndex:(int)index;
@end

//
//  YJCardView.h
//  iService
//
//  Created by szfore on 13-5-7.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlagView.h"
#import "YJViewDelegate.h"
#import "YJCardCell.h"
#import "YJContentView.h"

@interface YJCardView : YJFlagView<YJTouchViewDelegate>
{
    UIScrollView *contentView;
}
@property(nonatomic,assign)id<YJCardViewDelegate>delegate_cardView;
@property(nonatomic,assign)id<YJCardViewDataSource>dataSource_cardView;
@end

@protocol YJCardViewDelegate <NSObject>
@optional
-(void)cardView:(YJCardView *)cardView didSelectCell:(YJCardCell *)cardCell showContentView:(YJContentView *)contentVeiw;
-(void)cardView:(YJCardView *)cardView didDeselectCell:(YJCardCell *)cardCell removeContentView:(YJContentView *)contentVeiw;
@end

@protocol YJCardViewDataSource <NSObject>
-(int)getSectionCount:(YJCardView *)cardView;
-(NSString *)getSectionTitleWithSectionIndex:(YJCardView *)cardView index:(int)index;
-(UIImage *)getSectionImageWithSectionIndex:(YJCardView *)cardView index:(int)index;
-(NSString *)getContentWithSectionTitle:(YJCardView *)cardView sectionTitle:(NSString *)title index:(int)index;
@optional
-(UIColor *)getContentBackgroundColor:(int)index cardView:(YJCardView *)cardView;
-(UIColor *)getContentTextColor:(int)index cardView:(YJCardView *)cardView;
-(UIFont *)getContentFont:(int)index cardView:(YJCardView *)cardView;
@end
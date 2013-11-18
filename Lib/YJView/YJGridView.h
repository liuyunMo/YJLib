//
//  YJGirdView.h
//  iService
//
//  Created by szfore on 13-5-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlagView.h"
#import "YJButton.h"
@interface YJGridView : YJFlagView
{
    UIScrollView *contentView;
}
@property(nonatomic,assign)id<YJGridViewDelegate>delegate_grid;
@property(nonatomic,assign)id<YJGridViewDataSource>dataSource_grid;
@end


@protocol YJGridViewDelegate <NSObject>
@optional
-(void)selectGridItemAtIndex:(int)index gridView:(YJGridView*)gridView;
@end
@protocol YJGridViewDataSource <NSObject>
-(int)getGridItemCount:(YJGridView*)gridView;
-(CGRect)getFrameWithIndex:(int)index gridView:(YJGridView*)gridView;
-(void)getImageWithIndex:(int)index gridView:(YJGridView*)gridView defaultImage:(UIImage **)defaultImage selectedImage:(UIImage **)selectedImage;
@optional
@end
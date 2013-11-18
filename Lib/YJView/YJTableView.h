//
//  YJTableView.h
//  YJSwear
//
//  Created by zhongyy on 13-10-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
 
   version :  2013.11.04

*/

#import "YJView.h"
#define SPAN_TO_PULL_DOWN_REF  80
@protocol YJTableViewDelegate;
@protocol YJTableViewDataSource;
@class YJTableView;
typedef void(^RefHandle)(void);
//define block for YJTableView
/***************************/
typedef NSUInteger (^numberOfRowsInSection)(UITableView *tableView,NSInteger section);
typedef NSUInteger (^numberOfSectionsInTableView)(UITableView *tableView);
typedef UITableViewCell* (^cellForRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);
typedef void (^didSelectRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);
typedef CGFloat (^heightForRowAtIndexPath)(UITableView *tableView,NSIndexPath *indexPath);
typedef CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);
typedef CGFloat (^heightForFooterInSection)(UITableView *tableView,NSInteger section);
typedef UIView * (^viewForHeaderInSection)(UITableView *tableView,NSInteger section);
/***************************/
@interface YJTableView : YJView
@property(nonatomic,assign)   float rowHeight;
@property(nonatomic,assign)   UITableViewCellSeparatorStyle separatorStyle;
@property(nonatomic,assign)   BOOL pullDownToR;//是否触发下拉刷新
@property(nonatomic,assign)   BOOL pullUpToR;//是否触发下拉刷新
@property(nonatomic,assign)   int  numLeftToR;//剩余几条数据时触发刷新
@property(nonatomic,readonly) BOOL loading;//是否正在加载

@property(nonatomic,assign)id<YJTableViewDelegate>   delegate;
@property(nonatomic,assign)id<YJTableViewDataSource> dataSource;
@property(nonatomic,copy)numberOfRowsInSection       numberOfRowsInSection;
@property(nonatomic,copy)numberOfSectionsInTableView numberOfSectionsInTableView;
@property(nonatomic,copy)cellForRowAtIndexPath       cellForRowAtIndexPath;
@property(nonatomic,copy)didSelectRowAtIndexPath     didSelectRowAtIndexPath;
@property(nonatomic,copy)heightForRowAtIndexPath     heightForRowAtIndexPath;
@property(nonatomic,copy)heightForHeaderInSection    heightForHeaderInSection;
@property(nonatomic,copy)heightForFooterInSection    heightForFooterInSection;
@property(nonatomic,copy)viewForHeaderInSection      viewForHeaderInSection;

-(void)reloadData;
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;

-(void)handleWithPullDownRef;
@end

@protocol YJTableViewDelegate <UITableViewDelegate>
@optional
-(RefHandle)tableViewPullDown:(YJTableView *)tableView shouldRef:(BOOL *)ref;
-(RefHandle)tableViewPullUp:(YJTableView *)tableView shouldRef:(BOOL *)ref;
-(void)tableViewLoadDataFinished:(YJTableView *)tableView;
@end
@protocol YJTableViewDataSource <UITableViewDataSource>
@end

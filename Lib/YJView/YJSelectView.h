//
//  YJSelectView.h
//  YJSwear
//
//  Created by zhongyy on 13-8-23.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlagView.h"

@interface YJSelectView : YJFlagView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)YJResBlock resultBlock;
@property(nonatomic,retain)NSArray *items;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,retain)UIView *customView;
@property(nonatomic,assign)int selectIndex;
-(void)showInView:(UIView *)view;
@end

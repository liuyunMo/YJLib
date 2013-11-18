//
//  YJResultView.h
//  iTest
//
//  Created by szfore on 13-4-15.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlagView.h"
@protocol YJResultViewDatasource;
@protocol YJResultViewDelegate;
@interface YJResultView : YJFlagView
@property(nonatomic,assign)int count;
@property(nonatomic,assign)id<YJResultViewDatasource>datasource;
@property(nonatomic,assign)id<YJResultViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame count:(int)count;
@end
@protocol YJResultViewDelegate <NSObject>
@optional
-(void)selectItemAtIndex:(int)index;
@end
@protocol YJResultViewDatasource <NSObject>
-(NSString *)getStringToShowWithIndex:(int)index;
-(UIColor *)getTextColorToShowWithIndex:(int)index;
-(UIColor *)getBackgroundColorToShowWithIndex:(int)index;
@end
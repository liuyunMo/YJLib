//
//  YJResultViewController.h
//  iTest
//
//  Created by szfore on 13-4-12.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTestResultHandle.h"
#import "YJResultView.h"
#import "YJImageManager.h"
@protocol YJResultViewControllerDelegate;
@interface YJResultViewController : UIViewController<YJResultViewDatasource,YJResultViewDelegate>
@property(nonatomic,retain)YJTestResultHandle *resultHandle;
@property(nonatomic,assign)BOOL showPostBut;
@property(nonatomic,assign)id<YJResultViewControllerDelegate>delegate;
-(id)initWithResult:(YJTestResultHandle *)resultHandle;
@end
@protocol YJResultViewControllerDelegate <NSObject>
@optional
-(void)selectQuestionWithIndex:(int)index;
-(void)postButPressed;
@end
//
//  YJFileScanViewController.h
//  TestYJFramework
//
//  Created by szfore on 13-5-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJSearchShowView.h"
#import "YJSearchBar.h"
@protocol YJFileScanViewControllerDelegate;
@interface YJFileScanViewController : UIViewController<YJTouchViewDelegate>
{
    YJSearchShowView *view;
    YJNavBar *nav;
}
@property(nonatomic,assign)id<YJFileScanViewControllerDelegate>delegate;
@end
@protocol YJFileScanViewControllerDelegate <NSObject>
@optional
-(void)fileScanViewControllerBackButtonPressed:(YJFileScanViewController *)scanVC;
@end
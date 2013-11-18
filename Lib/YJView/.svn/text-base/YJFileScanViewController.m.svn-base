//
//  YJFileScanViewController.m
//  TestYJFramework
//
//  Created by szfore on 13-5-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFileScanViewController.h"
#define NAV_FLAG @"YJFileScanViewControllerNav"
#define SEARCH_BAR_FLAG @"YJFileScanViewControllerSearcBar"
@interface YJFileScanViewController ()<YJNavBarDelegate,YJSearchBarDelegate>
{
    YJTouchView *touchControl;
}
@end

@implementation YJFileScanViewController
-(void)createViewInYJFileScanViewController
{
    NSString *content=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"] encoding:4 error:nil];
	view=[[YJSearchShowView alloc] initWithString:content frame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44)];
    view.searchView.keywords=@[@"人员",@"现金",@"2"];
    view.searchView.x_span=10;
    [self.view insertSubview:view atIndex:0];
    view.backgroundColor=[UIColor clearColor];
    [view release];
    
    
    nav=[[YJNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) flagStr:NAV_FLAG];
    nav.showLeftItem=YES;
    nav.showRightItem=YES;
    nav.title=self.title;
    [nav setUpRightItemTitle:@"搜索"];
    [nav setUpLeftItemTitle:@"返回"];
    nav.delegate_navBar=self;
    [self.view addSubview:nav];
    [nav release];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    [self createViewInYJFileScanViewController];
    [self addGesture];
}
-(void)addGesture
{
    UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [rightSwipe release];
    
    
    UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    [leftSwipe release];
}
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    if(view.searchView.keywords.count!=1)return;
    YJSearchResult *result=nil;
    switch (swipe.direction)
    {
        case UISwipeGestureRecognizerDirectionLeft:
            result=[view.searchView gotoPreviousSearchResult];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            result=[view.searchView gotoNextSearchResult];
            break;
        default:
            break;
    }
    if (result.charStrArr.count>0)
    {
        YJChar *charStr=[result.charStrArr objectAtIndex:0];
        float height=charStr.frame.origin.y;
        float offsetY=height-view.bounds.size.height/2;
        offsetY=offsetY<0?0:offsetY;
        offsetY=offsetY>(view.contentSize.height-view.bounds.size.height)?(view.contentSize.height-view.bounds.size.height):offsetY;
        [view setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
}

-(void)showSearchView
{
    YJSearchBar *searchBar=[[YJSearchBar alloc] initWithFrame:CGRectMake(0, -64, 320, 44) flagStr:SEARCH_BAR_FLAG];
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];
    [UIView animateWithDuration:.25 animations:^{
        searchBar.frame=CGRectMake(0, 0, 320, 44);
    }];
    [searchBar becomeFirstResponder];
    
    touchControl=[[YJTouchView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44)];
    touchControl.delegate_touch=self;
    [self.view addSubview:touchControl];
    [touchControl release];
    touchControl.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
}
-(void)removeSearchView
{
    [touchControl removeFromSuperview];
    YJSearchBar *searchBar=(YJSearchBar *)[self.view getYJFlagViewWithFlag:SEARCH_BAR_FLAG];
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:.25 animations:^{
        searchBar.frame=CGRectMake(0, -64, 320, 44);
    } completion:^(BOOL finish){
        if (finish)
        {
            [searchBar removeFromSuperview];
        }
    }
     ];
}
#pragma mark-- YJNavBarDelegate Methods
-(void)leftItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    if ([self.delegate respondsToSelector:@selector(fileScanViewControllerBackButtonPressed:)])
    {
        [self.delegate fileScanViewControllerBackButtonPressed:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
-(void)rightItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    [self showSearchView];
}
#pragma mark--  YJSearchBarDelegate Methods
-(void)cancelButtonPressed:(YJSearchBar *)searchBar
{
    [self removeSearchView];
}
-(BOOL)yjSearchBarShouldReturn:(YJSearchBar *)searchBar
{
    [self removeSearchView];
    view.searchView.keywords=@[searchBar.inputTf.text];
    return YES;
}
#pragma mark-- YJTouchViewDelegate

-(void)viewToucheEnd:(YJFlagView *)view touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeSearchView];
}
@end

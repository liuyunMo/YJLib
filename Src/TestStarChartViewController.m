//
//  TestStarChartViewController.m
//  YJLib
//
//  Created by zhongyy on 13-12-6.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "TestStarChartViewController.h"
#import "YJStarChartView.h"
@interface TestStarChartViewController ()

@end

@implementation TestStarChartViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	YJStarChartView *view=[[YJStarChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    [view   release];
}


@end

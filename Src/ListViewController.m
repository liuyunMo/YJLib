//
//  ListViewController.m
//  YJLib
//
//  Created by zhongyy on 13-10-14.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataToShow;
}
@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    dataToShow=@[@"YJTest",@"YJTableView",@"YJCalender"];
    [dataToShow retain];
    
    UITableView *tab=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tab.delegate=self;
    tab.dataSource=self;
    [self.view addSubview:tab];
    [tab release];
    
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [dataToShow release];
    [super dealloc];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataToShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=CREATE_CELL(UITableViewCell);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=[dataToShow objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSString *title=[dataToShow objectAtIndex:indexPath.row];
    NSString *className=[NSString stringWithFormat:@"Test%@ViewController",title];
    Class C=NSClassFromString(className);
    UIViewController *vc=[[C alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end

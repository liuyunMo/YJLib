//
//  YJFileManagerViewController.m
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFileManagerViewController.h"
#import "YJScanViewController.h"

@interface YJFileManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tab;
}
@property(nonatomic,retain)NSMutableArray *dataArr;
@end

@implementation YJFileManagerViewController
-(void)initData
{
    NSError *error=nil;
    if (!_dataArr) _dataArr=[[NSMutableArray alloc] init];
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.folderPath error:&error]];
    if (error) NSLog(@"%@",error);
}
-(void)dissmissFileManager
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (self.navigationController.viewControllers.count==1) {
        UIBarButtonItem *leftBu=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dissmissFileManager)];
        self.navigationItem.leftBarButtonItem=leftBu;
        [leftBu release];
    }
    tab =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    tab.delegate=self;
    tab.dataSource=self;
    [self.view addSubview:tab];
    [tab release];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_dataArr release];
    [_folderPath release];
    [super dealloc];
}
#pragma mark-- UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    NSString *fileName=[self.dataArr objectAtIndex:[indexPath row]];
    cell.textLabel.text=fileName;
    BOOL isFolder=NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",self.folderPath,fileName] isDirectory:&isFolder];
    cell.accessoryType=isFolder?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    return cell;
}
#pragma mark-- UITableDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName=[self.dataArr objectAtIndex:[indexPath row]];
    BOOL isFolder=NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",self.folderPath,fileName] isDirectory:&isFolder];
    return isFolder?UITableViewCellEditingStyleNone:UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSString *fileName=[self.dataArr objectAtIndex:indexPath.row];
        NSString *path=[self.folderPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            if ([[NSFileManager defaultManager] removeItemAtPath:path error:NULL])
            {
                [self.dataArr removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }else{
                [self.view showQDAlertViewWithMessage:@"删除失败！"];
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSString *path=[NSString stringWithFormat:@"%@/%@",self.folderPath,cell.textLabel.text];
    if (cell.accessoryType==UITableViewCellAccessoryDisclosureIndicator)
    {
        YJFileManagerViewController *vc=[[YJFileManagerViewController alloc] init];
        vc.folderPath=path;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else{
        YJScanViewController *vc=[[YJScanViewController alloc] init];
        vc.filePath=path;
        [self.navigationController presentModalViewController:vc animated:YES];
        [vc release];
    }
}
@end

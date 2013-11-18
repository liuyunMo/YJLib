//
//  TestYJTableViewViewController.m
//  YJLib
//
//  Created by zhongyy on 13-11-4.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "TestYJTableViewViewController.h"
#import "YJTableView.h"
@interface TestYJTableViewViewController ()<YJTableViewDataSource,YJTableViewDelegate>
{
    YJTableView *tab;
    NSMutableArray *dataToShow;
}
@end
@implementation TestYJTableViewViewController
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    dataToShow=[[NSMutableArray alloc] init];
    
    
    tab=[[YJTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    tab.delegate=self;
    tab.dataSource=self;
    tab.pullDownToR=YES;
    tab.pullUpToR=YES;
    tab.numLeftToR=5;
    tab.rowHeight=44;
    [self.view addSubview:tab];
    [tab release];
    [self reloadData];
}
-(void)reloadData
{
    [self.view addNetTmpView];
    SET_SELF_BLOCK;
    DISPATCH_ASYNC(^{
        sleep(3);
        for (int i=0; i<5; i++) {
            [dataToShow addObject:@"dd"];
        }
    }, ^{
        [SELF_BLOCK loadDataFinish];
    });
}
-(void)addData
{
    [self.view addNetTmpView];
}
-(void)loadDataFinish
{
    [self.view removeNetTmpView];
    [tab reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataToShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==NULL) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    cell.textLabel.text=[dataToShow objectAtIndex:indexPath.row];
    return cell;
}
-(RefHandle)tableViewPullDown:(YJTableView *)tableView shouldRef:(BOOL *)ref
{
    *ref=YES;
    RefHandle handle=^{
        sleep(3);
        for (int i=0; i<15; i++) {
            [dataToShow addObject:@"dd"];
        }
    };
    return Block_copy(handle);
}
-(RefHandle)tableViewPullUp:(YJTableView *)tableView shouldRef:(BOOL *)ref;
{
    *ref=YES;
    RefHandle handle=^{
        sleep(1);
        for (int i=0; i<30; i++) {
            [dataToShow addObject:@"dd"];
        }
        };
    return Block_copy(handle);
}
@end

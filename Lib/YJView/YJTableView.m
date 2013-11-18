//
//  YJTableView.m
//  YJSwear
//
//  Created by zhongyy on 13-10-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTableView.h"
@interface YJTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tab;
    UITableViewStyle tabStyle;
    LYRoundProgressView *proView;
    int sectionCount;
    int lastSectionRowCount;
}
@end
@implementation YJTableView
/*  setter  */
-(void)setCellForRowAtIndexPath:(cellForRowAtIndexPath)cellForRowAtIndexPath
{
    SET_BLOCK(_cellForRowAtIndexPath, cellForRowAtIndexPath);
}
-(void)setNumberOfRowsInSection:(numberOfRowsInSection)numberOfRowsInSection
{
    SET_BLOCK(_numberOfRowsInSection, numberOfRowsInSection);
}
/*  setter  */
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_cellForRowAtIndexPath);
    SAFE_BLOCK_RELEASE(_numberOfRowsInSection);
    [super dealloc];
}
-(void)reloadData
{
    [tab reloadData];
}
- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell
{
    return [tab indexPathForCell:cell];
}
-(void)createViewWithStyle:(UITableViewStyle)style
{
    if(!tab)
    {
        if (!proView) {
            proView=[[LYRoundProgressView alloc] initWithloopDefaultColor:[UIColor grayColor] loopHighlightedColor:[UIColor blueColor] frame:CGRectMake(140, 5, 40, 40)];
            proView.backgroundColor=[UIColor clearColor];
            proView.loopWidth=3;
            proView.progress=0;
            proView.hidden=YES;
            proView.hiddenProStr=NO;
            [self addSubview:proView];
            [proView release];
        }
        
        tab=[[UITableView alloc] initWithFrame:self.bounds style:style];
        tab.rowHeight=self.rowHeight;
        tab.separatorStyle=self.separatorStyle;
        tab.delegate=self;
        tab.dataSource=self;
        tab.backgroundColor=[UIColor clearColor];
        tab.backgroundView=nil;
        [self addSubview:tab];
        [tab release];
    }
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.numLeftToR=10;
        self.rowHeight=44;
        self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tabStyle=style;
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self createViewWithStyle:tabStyle];
    }
}
-(void)handleWithPullDownRef
{
    proView.hidden=YES;
    if (self.loading) {
        return;
    }
    _loading=YES;
    
    UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ac.center=CGPointMake(self.bounds.size.width/2, 30);
    ac.color=[UIColor redColor];
    ac.tag=101;
    [ac startAnimating];
    [self insertSubview:ac belowSubview:tab];
    [ac release];
    [UIView animateWithDuration:.5 animations:^{
        tab.contentInset=UIEdgeInsetsMake(SPAN_TO_PULL_DOWN_REF,0.0f, 0.0f, 0.0f);
    }];
    
    
    BOOL ref=YES;
    __block RefHandle refHan=NULL;
    if ([self.delegate respondsToSelector:@selector(tableViewPullDown:shouldRef:)])
    {
        refHan=[self.delegate tableViewPullDown:self shouldRef:&ref];
    }
    SET_SELF_BLOCK;
    if (ref&&refHan) {
        dispatch_async(DISPATCH_GLOBAL_QUEUE,^{
            refHan();
            Block_release(refHan);
            dispatch_async(DISPATCH_MAIN_QUEUE,^{
                [SELF_BLOCK refFinished:@(101)];
            });});
    }else{
        [self performSelector:@selector(refFinished:) withObject:@(101) afterDelay:1];
    }
}
-(void)refFinished:(NSNumber *)acTag
{
    proView.progress=0;
    _loading=NO;
    UIActivityIndicatorView *ac=(UIActivityIndicatorView *)[self viewWithTag:101];
    [ac stopAnimating];
    
    
    UIActivityIndicatorView *ac1=(UIActivityIndicatorView *)[self viewWithTag:102];
    [ac1 stopAnimating];
    
    
    [UIView animateWithDuration:.5 animations:^{
        [tab setContentInset:UIEdgeInsetsMake(0.0f,0.0f, 0.0f, 0.0f)];
        [tab reloadData];
    } completion:^(BOOL finished) {
        if (finished) {
            [ac removeFromSuperview];
            [ac1 removeFromSuperview];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(tableViewLoadDataFinished:)]) {
        [self.delegate tableViewLoadDataFinished:self];
    }
}
-(void)handleWithPullUpRef
{
    if (self.loading) {
        return;
    }

    BOOL ref=NO;
    __block RefHandle refHan=NULL;
    if ([self.delegate respondsToSelector:@selector(tableViewPullUp:shouldRef:)])
    {
        refHan=[self.delegate tableViewPullUp:self shouldRef:&ref];
    }
    SET_SELF_BLOCK;
    if (ref&&refHan) {
        _loading=YES;
        UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        ac.center=CGPointMake(160, self.bounds.size.height-40);
        ac.color=[UIColor redColor];
        ac.tag=102;
        [ac startAnimating];
        [self insertSubview:ac belowSubview:tab];
        [ac release];
        [UIView animateWithDuration:.5 animations:^{
            tab.contentInset=UIEdgeInsetsMake(0.0f, 0.0f,SPAN_TO_PULL_DOWN_REF, 0.0f);
        }];
        
        dispatch_async(DISPATCH_GLOBAL_QUEUE,^{
            refHan();
            Block_release(refHan);
            dispatch_async(DISPATCH_MAIN_QUEUE,^{
                [SELF_BLOCK refFinished:@(102)];
            });});
    }else{
        [self performSelector:@selector(refFinished:) withObject:@(102) afterDelay:1];
    }
}
#pragma mark-- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if (self.numberOfRowsInSection) {
        count = _numberOfRowsInSection(tableView,section);
    }else if([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
    {
        count=[self.dataSource tableView:tableView numberOfRowsInSection:section];
    }
    if (section==sectionCount-1) {
        lastSectionRowCount=count;
    }
    return count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    sectionCount=1;
    if (self.numberOfSectionsInTableView) {
        sectionCount=_numberOfSectionsInTableView(tableView);
    }else if([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        sectionCount=[self.dataSource numberOfSectionsInTableView:tableView];
    }
    return sectionCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowAtIndexPath) {
        return _cellForRowAtIndexPath(tableView,indexPath);
    }else if([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
    {
        return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==sectionCount-1)
    {
        if (indexPath.row+self.numLeftToR>lastSectionRowCount)
        {
            if(self.pullUpToR)[self handleWithPullUpRef];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.heightForRowAtIndexPath)
    {
        return _heightForRowAtIndexPath(tableView,indexPath);
    }else if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.heightForHeaderInSection)
    {
        return _heightForHeaderInSection(tableView,section);
    }else if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.heightForFooterInSection)
    {
        return _heightForFooterInSection(tableView,section);
    }else if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.viewForHeaderInSection)
    {
        return _viewForHeaderInSection(tableView,section);
    }else if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.didSelectRowAtIndexPath)
    {
        _didSelectRowAtIndexPath(tableView,indexPath);
    }else if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y=scrollView.contentOffset.y;
    if (y<0&&self.pullDownToR) {
        proView.hidden=NO;
        float y_p=fabsf(y)-20;
        proView.center=CGPointMake(self.bounds.size.width/2, y_p>30?30:y_p);
        proView.progress=fabsf(y)/SPAN_TO_PULL_DOWN_REF;
    }else{
        proView.hidden=YES;
    }
    if (self.loading) {
        proView.hidden=YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (proView.progress>=1.0f) {
        if(self.pullDownToR)[self handleWithPullDownRef];
    }
}
@end

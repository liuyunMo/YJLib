//
//  YJScanViewController.m
//  TestYJFramework
//
//  Created by szfore on 13-7-2.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJScanViewController.h"
#import "YJDatabase_c.h"
@interface YJScanViewController ()<UIWebViewDelegate>
{
    UIWebView *web;
    UIScrollView *contentView;
}
@end

@implementation YJScanViewController
-(void)gotoBack
{
    [self loadFinished];
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)loadString:(NSString *)str
{
    if (!contentView) {
        contentView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44)];
        contentView.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:contentView];
        [contentView release];
    }
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    YJContentView *vi=[[YJContentView alloc] initWithString:str frame:CGRectMake(0, 0, 320, 10)];
    vi.textColor=[UIColor whiteColor];
    [contentView addSubview:vi];
    [vi release];
    float height=vi.frame.size.height;
    if (height>contentView.frame.size.height)
    {
        contentView.contentSize=CGSizeMake(320, height);
    }
}
-(void)loadDatabase
{
    sqlite3 *database=nil;
    openDatabase([self.filePath UTF8String], &database);
    YJStringRef tables=NULL,columns=NULL;
    copyAllTableName(database, &tables);
    printYJString(tables);
    YJStringRef p=tables;
    while (p)
    {
        int columnCount=0;
        getColumnCountFromTable(database, &columnCount, p->value);
        printf("+++%d\n",columnCount);
        p=p->next;
    }
    freeYJString(tables);
    copyAllColumnFromTable(database, &columns, "userInfoTable");
    
    
    freeYJString(columns);
    
    
    
    closeDatabase(database);
}
-(void)createNav
{
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.barStyle=UIBarStyleBlack;
    [self.view addSubview:bar];
    [bar release];
    
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:self.title];
    bar.items=@[item];
    [item release];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    item.leftBarButtonItem=leftItem;
    [leftItem release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNav];
    
    if ([self.filePath hasSuffix:@".plist"])//plist加载
    {        
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:self.filePath];
        if (dict)
        {
            [self loadString:[LYJsonCode jsonCodeWithObject:dict error:NULL]];
        }else{
            [self performSelector:@selector(gotoBack) withObject:nil afterDelay:5.];
        }
    }else if ([self.filePath hasSuffix:@".db"])
    {
        [self loadDatabase];
    }else if ([self.filePath hasSuffix:@".txt"]||[self.filePath hasSuffix:@".info"])
    {
        NSString *string=[NSString stringWithContentsOfFile:self.filePath encoding:4 error:NULL];
        [self loadString:string];
    }else if([self.filePath hasSuffix:@".ffpg"])
    {
        [self loadString:readFromFFPG(self.filePath)];
    }else{
        //web 加载
        web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44)];
        web.backgroundColor=[UIColor blackColor];
        web.delegate=self;
        web.scalesPageToFit=YES;
        [self.view addSubview:web];
        [web release];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.filePath]];
        [web loadRequest:request];
        [request release];
        [web addNetTmpView];
    }//web加载
}
-(void)loadFinished
{
    if (_deleteAfterLoad) [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:NULL];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [web removeNetTmpView];
    [self loadFinished];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self performSelector:@selector(gotoBack) withObject:nil afterDelay:5.];
}
@end

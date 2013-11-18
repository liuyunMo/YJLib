//
//  YJFlashImageViewController.m
//  YJHealth
//
//  Created by szfore on 13-7-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJFlashImageViewController.h"
#import "YJFlashImageView.h"
#import "YJScanViewController.h"

#define FIVC_NAV_FLAG @"YJFlashImageViewController_nav"
#define FIVC_FLASH_IMAGE_FLAG @"YJFlashImageViewController_flashImage"
@interface YJFlashImageViewController ()<YJNavBarDelegate,YJFlashImageViewDelegate>

@end

@implementation YJFlashImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    YJNavBar *nav=[[YJNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) flagStr:FIVC_NAV_FLAG];
    nav.showRightItem=YES;
    nav.delegate_navBar=self;
    nav.showLeftItem=YES;
    [nav setUpLeftItemTitle:@"返回"];
    [nav setUpRightItemTitle:@"原图"];
    [self.view addSubview:nav];
    [nav release];
    
    YJFlashImageView *flashImageView=[[YJFlashImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44) flagStr:FIVC_FLASH_IMAGE_FLAG];
    flashImageView.delegate_flash=self;
    //flashImageView.keywords=@[@"关键子",@"关键子键子键子",@"关键子键子",@"关键键键键子",@"关关关关键子",@"关键关键关键关键子",@"关键子关键子关键子"];
    [self.view insertSubview:flashImageView atIndex:0];
    [flashImageView release];
    
    flashImageView.image=[UIImage imageWithData:[YJEncrypt encryptDataUseDefault:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/flashImage.fpg",self.flashFolderPath]]]];
    flashImageView.tapPlistPath=[NSString stringWithFormat:@"%@/flashImage.plist",self.flashFolderPath];
    if(createFinishBlock)createFinishBlock(self);
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    if(block)Block_release(block);
    if (createFinishBlock) Block_release(createFinishBlock);
    [super dealloc];
}
-(void)gotoBack
{
    if (block) {
        block(self,NULL);
    }else{
        if (self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}
-(void)setUpBackBlock:(backBlock)back
{
    if (back) block=Block_copy(back);
}
-(id)initWithCreateFinishBlock:(createViewFinish)createViewblock;
{
    if (self=[super init])
    {
        if (createViewblock) createFinishBlock=Block_copy(createViewblock);
    }
    return self;
}
#pragma mark-- YJNavBarDelegate
-(void)rightItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    YJScanViewController *scan=[[YJScanViewController alloc] init];
    NSData *data=[YJEncrypt encryptDataUseDefault:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/flashImage.fpg",self.flashFolderPath]]];
    NSString *path=[NSString stringWithFormat:@"%@/flashImage.jpg",self.flashFolderPath];
    [data writeToFile:path atomically:YES];
    scan.title=@"预览";
    scan.filePath=path;
    scan.deleteAfterLoad=YES;
    [self presentModalViewController:scan animated:YES];
    [scan release];
}
-(void)leftItemPressed:(YJButton *)item nav:(YJNavBar *)nav
{
    [self gotoBack];
}
#pragma mark-- YJFlashImageViewDelegate
-(void)touchHotAreaWithName:(NSString *)name type:(NSString *)type flashImage:(YJFlashImageView *)flashImage
{
    YJScanViewController *scan=[[YJScanViewController alloc] init];
    scan.title=@"预览";
    scan.filePath=[NSString stringWithFormat:@"%@/%@",self.flashFolderPath,name];
    [self presentModalViewController:scan animated:YES];
    [scan release];
}
@end

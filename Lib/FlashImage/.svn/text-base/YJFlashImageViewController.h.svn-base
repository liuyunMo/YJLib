//
//  YJFlashImageViewController.h
//  YJHealth
//
//  Created by szfore on 13-7-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//


typedef  void(^createViewFinish)(id ctx);
@interface YJFlashImageViewController : UIViewController
{
    backBlock block;
    createViewFinish createFinishBlock;
}
@property(nonatomic,retain)NSString *flashFolderPath;
-(void)setUpBackBlock:(backBlock)back;
-(id)initWithCreateFinishBlock:(createViewFinish)createViewblock;
@end

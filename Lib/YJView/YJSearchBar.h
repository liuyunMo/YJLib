//
//  YJSearchBar.h
//  TestYJFramework
//
//  Created by szfore on 13-5-22.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

enum{
    kYJSearchBarTypeDefault=0
};
typedef __uint32_t YJSearchBarType;
@protocol YJSearchBarDelegate;
@interface YJSearchBar : YJFlagView<UITextFieldDelegate>
{
    
}
@property(nonatomic,assign)CGSize offset;
@property(nonatomic,retain)UITextField *inputTf;
@property(nonatomic,assign)id<YJSearchBarDelegate>delegate;
@property(nonatomic,assign)YJSearchBarType type;
@end
@protocol YJSearchBarDelegate <NSObject>
@optional
-(void)cancelButtonPressed:(YJSearchBar *)searchBar;
-(BOOL)yjSearchBarShouldReturn:(YJSearchBar *)searchBar;
@end
//
//  YJTextView.h
//  YJHealth
//
//  Created by szfore on 13-7-14.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PLACE_HORDER_COLOR COLOR_WITH_RGB(100,100,100)
@interface YJTextView : UITextView<YJFlagViewDelegate>
@property(nonatomic,copy)NSString *placeHolder;
@end

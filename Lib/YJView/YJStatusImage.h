//
//  YJStatusImage.h
//  YJSwear
//
//  Created by zhongyy on 13-9-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJImageView.h"
typedef void(^StatusChangeBlock)(BOOL selected);
@interface YJStatusImage : YJImageView
@property(nonatomic,retain)UIImage *selectImage;
@property(nonatomic,retain)UIImage *defaultImage;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)StatusChangeBlock stausBlock;
-(void)setImageForKey:(NSString *)key;
@end

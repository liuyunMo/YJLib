//
//  YJBarItem.h
//  YJHealth
//
//  Created by szfore on 13-7-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJBarItem : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,retain)UIImage *defaultImage;
@property(nonatomic,retain)UIImage *selectImage;
@property(nonatomic,retain)UIColor *defaultColor;
@property(nonatomic,retain)UIColor *selectColor;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)int tag;
@property(nonatomic,assign)float width;
-(void)setImageWithKey:(NSString *)key;
@end

//
//  YJLoadImageView.h
//  YJSwear
//
//  Created by zhongyy on 13-10-9.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJImageView.h"
#define DEFAULT_PPT NULL
@interface YJLoadImageView : YJImageView
-(id)initWithUrl:(NSURL *)url savePath:(NSString *)savePath defaultImage:(UIImage *)defaultImage;
-(void)changeForUrl:(NSURL *)url savePath:(NSString *)savePath;
@end

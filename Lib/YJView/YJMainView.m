//
//  YJMainView.m
//  YJHealth
//
//  Created by szfore on 13-7-5.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJMainView.h"

@implementation YJMainView
-(void)postUseInfoToMain:(NSDictionary *)userInfo finish:(void (^)(id))block
{
    if([self.delegate respondsToSelector:@selector(mainView:wantToDoWithUserInfo:finish:)])
    {
        [self.delegate mainView:self wantToDoWithUserInfo:userInfo finish:block];
    }
}
-(void)reloadData{}
@end

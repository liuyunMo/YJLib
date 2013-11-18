//
//  YJStatusImage.m
//  YJSwear
//
//  Created by zhongyy on 13-9-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJStatusImage.h"

@implementation YJStatusImage 
-(void)setSelected:(BOOL)selected
{
    _selected=selected;
    self.image=_selected?self.selectImage:self.defaultImage;
}
-(void)setStausBlock:(StatusChangeBlock)stausBlock
{
    SET_BLOCK(_stausBlock, stausBlock);
}
-(void)setImageForKey:(NSString *)key
{
    self.defaultImage=[YJImageManager getImageWithKeyString:key status:kYJImageStatusDefault];
    self.selectImage=[YJImageManager getImageWithKeyString:key status:kYJImageStatusSelected];
}
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.selected=!self.selected;
    if (_stausBlock) {
        _stausBlock(self.selected);
    }
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    SAFE_BLOCK_RELEASE(_stausBlock);
    [_defaultImage release];
    [_selectImage release];
    [super dealloc];
}
@end

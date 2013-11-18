//
//  YJStayButton.m
//  iService
//
//  Created by szfore on 13-5-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJStayButton.h"

@implementation YJStayButton
-(void)dealloc
{
    DEALLOC_PRINTF;
    [super dealloc];
}
-(void)setSelected:(BOOL)selected
{
    _selected=selected;
    self.status=_selected?kYJButtonStatusDefault:kYJButtonStatusSelected;
}
-(void)setStatus:(YJButtonStatus)status
{
    [super setStatus:status];
    _selected=(status==kYJButtonStatusSelected);
}
-(void)handleEventBegin
{
    self.status=self.selected?kYJButtonStatusDefault:kYJButtonStatusSelected;
}
-(void)handleEventEnd
{
    self.status=self.selected?kYJButtonStatusSelected:kYJButtonStatusDefault;
}
@end

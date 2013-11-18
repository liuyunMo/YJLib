//
//  YJInputView.m
//  YJExam
//
//  Created by admin123 on 13-3-28.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "YJInputView.h"

@implementation YJInputView
@synthesize textView=_textView;
-(void)createView
{
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(3, 3.5, 250, 37)];
    _textView.font=[UIFont systemFontOfSize:17];
    _textView.layer.cornerRadius=37/2.0;
    _textView.delegate=self;
    [self addSubview:_textView];
    
    UIButton *doneBut=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBut.frame=CGRectMake(256, 8.5, 60, 25);
    doneBut.layer.cornerRadius=3;
    [self addSubview:doneBut];
    doneBut.backgroundColor=[UIColor purpleColor];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor blueColor];
        [self createView];
    }
    return self;
}
-(void)dealloc
{
    [_textView release];
    [super dealloc];
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect rect=_textView.frame;
    if (_textView.contentSize.height>rect.size.height)
    {
        NSLog(@"%f",_textView.contentSize.height);
        rect.size.height=_textView.contentSize.height;
        rect.origin.y-=_textView.contentSize.height-rect.size.height;
    }
    _textView.frame=rect;
}
@end

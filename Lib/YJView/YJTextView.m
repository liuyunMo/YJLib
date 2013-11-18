//
//  YJTextView.m
//  YJHealth
//
//  Created by szfore on 13-7-14.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTextView.h"

@implementation YJTextView
@synthesize flagStr=_flagStr;
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_flagStr release];
    [_placeHolder release];
    [super dealloc];
}
-(NSString*)flagStr
{
    if (!_flagStr) {
        return @"YJTextView";
    }
    return _flagStr;
}
-(BOOL)becomeFirstResponder
{
    BOOL res=[super becomeFirstResponder];
    if (!self.text) {
        self.text=nil;
        self.textColor=[UIColor blackColor];
    }
    return res;
}
-(BOOL)resignFirstResponder
{
    if (!self.text) {
        self.text=self.placeHolder;
        self.textColor=PLACE_HORDER_COLOR;
    }
    return [super resignFirstResponder];
}
-(void)setPlaceHolder:(NSString *)placeHolder
{
    SET_PAR(_placeHolder, placeHolder);
    self.text=self.placeHolder;
    self.textColor=PLACE_HORDER_COLOR;
}
-(void)setText:(NSString *)text
{
    if ([self isFirstResponder]) {
        [super setText:text];
        self.textColor=[UIColor blackColor];
    }else if (stringDeleteWhitespaceAndNewline(text)&&![text isEqualToString:self.placeHolder]){
        [super setText:text];
        self.textColor=[UIColor blackColor];
    }else {
        [super setText:self.placeHolder];
        self.textColor=PLACE_HORDER_COLOR;
    }
//    if ((stringDeleteWhitespaceAndNewline(text)||[self isFirstResponder])&&![text isEqualToString:self.placeHolder]) {
//        
//    }else{
//        
//    }
}
-(NSString *)text
{
    NSString *text=[super text];
    if ((self.placeHolder&&[self.placeHolder isEqualToString:text])||(text&&text.length<1))
    {
        return nil;
    }else{
        return text;
    }
}
@end

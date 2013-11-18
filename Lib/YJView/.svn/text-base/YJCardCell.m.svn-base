//
//  YJCardCell.m
//  iService
//
//  Created by szfore on 13-5-7.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJCardCell.h"
#define BACKGROUNDIMAGE_FLAG @"YJCardCellBackgroundImage"
#define CARDIMAGE_FLAG @"YJCardCellCardImage"
#define ACCESSIMAGE_FLAG @"YJCardCellAccessImage"
@implementation YJCardCell
-(void)createViewInYJCardCell
{
    self.backgroundColor=[UIColor whiteColor];
    if (!cardImageView)
    {
        cardImageView=[[YJImageView alloc] initWithFrame:CGRectMake(5, 2, 40, 40)];
        cardImageView.flagStr=CARDIMAGE_FLAG;
        [self addSubview:cardImageView];
        [cardImageView release];
    }
    if (!titleLabel)
    {
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 240, 44)];
        titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:titleLabel];
        [titleLabel release];
    }
    if (!accessImageView)
    {
        accessImageView=[[YJImageView alloc] initWithFrame:CGRectMake(300, 12, 10, 20)];
        accessImageView.image=getCardCellAccessImage(CGSizeMake(20, 40));
        accessImageView.flagStr=ACCESSIMAGE_FLAG;
        [self addSubview:accessImageView];
        [accessImageView release];
    }
}
-(id)initWithFrame:(CGRect)frame
{
    frame.size.height=44;
    if (self=[super initWithFrame:frame])
    {
        [self createViewInYJCardCell];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    SET_PAR(_title, title);
    titleLabel.text=_title;
}
-(void)setCardImage:(UIImage *)cardImage
{
    SET_PAR(_cardImage, cardImage);
    cardImageView.image=_cardImage;
}
-(void)setBackgroudImage:(UIImage *)backgroudImage
{
    SET_PAR(_backgroudImage, backgroudImage);
    if (!backgroudImageView)
    {
        backgroudImageView=[[YJImageView alloc] initWithFrame:self.bounds];
        backgroudImageView.flagStr=BACKGROUNDIMAGE_FLAG;
        [self insertSubview:backgroudImageView atIndex:0];
        [backgroudImageView release];
    }
    backgroudImageView.image=_backgroudImage;
}
-(void)setAccessImage:(UIImage *)accessImage
{
    SET_PAR(_accessImage, accessImage);
    accessImageView.image=_accessImage;
}
-(void)setSelected:(BOOL)selected
{
    _selected=selected;
    [UIView animateWithDuration:0 animations:^{accessImageView.transform=_selected?CGAffineTransformMakeRotation(M_PI/2):CGAffineTransformIdentity;}];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_accessImage release];
    [_title release];
    [_cardImage release];
    [_backgroudImage release];
    [super dealloc];
}
@end
@implementation UIView (YJCardCell)
-(YJCardCell *)getCardCellWithIndex:(int)index
{
    for (YJCardCell *cell in self.subviews)
    {
        if ([cell isKindOfClass:[YJCardCell class]]&&cell.index==index)
        {
            return cell;
        }
    }
    return nil;
}
@end

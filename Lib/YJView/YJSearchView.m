//
//  YJSearchView.m
//  TestYJFramework
//
//  Created by szfore on 13-5-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJSearchView.h"
#define __TEXT_FONT_ [UIFont systemFontOfSize:15]
@implementation YJSearchResult
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_keyword release];
    [_charStrArr release];
    [super dealloc];
}
-(void)setCharStrArr:(NSArray *)charStrArr
{
    [charStrArr retain];
    [_charStrArr release];
    _charStrArr=charStrArr;
    NSMutableString *string=[NSMutableString string];
    for (YJChar *charStr in _charStrArr)
    {
        [string appendString:charStr.aChar];
    }
    [_keyword release];
    _keyword=string;
    [_keyword retain];
}
@end
@implementation NSMutableArray (YJSearchResult)
-(void)sortWithLocation
{
    for (int i=0; i<self.count; i++)
    {
        for (int j=i+1; j<self.count; j++)
        {
            YJSearchResult *result1=[self objectAtIndex:i];
            YJSearchResult *result2=[self objectAtIndex:j];
            if (result1.range.location>result2.range.location)
            {
                [self exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}
@end
@interface YJSearchView()
{
    int selectedIndex;
}

@property(nonatomic,retain)NSMutableArray *aCharStringArr;
@property(nonatomic,retain)YJSearchResult *selectedResult;
@end
@implementation YJSearchView

-(void)dealloc
{
    DEALLOC_PRINTF;
    [_font release];
    [_defaultTextColor release];
    [_selectedTextColor release];
    [_currentSelectTextColor release];
    [_contentString release];
    [_aCharStringArr release];
    [_searchResultArr release];
    [_keywords release];
    [_selectedResult release];
    [super dealloc];
}
-(void)setContentWidth:(float)contentWidth
{
    if (_contentWidth!=contentWidth)
    {
        _contentWidth=contentWidth;
        self.frame=[self getContentRectWithFrame:self.frame];
        [self searchChangedFrame];
        [self reloadData];
    }
}
-(void)setContentString:(NSString *)contentString
{
    if (!contentString) return;
    if ([contentString isEqualToString:_contentString]) return;
    [_contentString release];
    _contentString=contentString;
    [_contentString retain];
    self.frame=[self getContentRectWithFrame:self.frame];
    [self searchChangedFrame];
    
    [self searchForKeyword];
    
    [self reloadData];
}
-(void)setFont:(UIFont *)font
{
    [font retain];
    [_font release];
    _font=font;
    
    self.frame=[self getContentRectWithFrame:self.frame];
}
-(void)setX_span:(float)x_span
{
    if (_x_span!=x_span)
    {
        _x_span=x_span;
        self.frame=[self getContentRectWithFrame:self.frame];
        [self searchChangedFrame];
        [self reloadData];
    }
}
-(void)searchForKeyword
{
    [_searchResultArr removeAllObjects];
    for (NSString *keyword in self.keywords)
    {
        [_searchResultArr addObjectsFromArray:[self seachForString:keyword]];
    }
    
    selectedIndex=0;
    if (_searchResultArr.count>0) {
        [_searchResultArr sortWithLocation];
        self.selectedResult=[_searchResultArr objectAtIndex:selectedIndex];
    }else{
        self.selectedResult=nil;
    }
}
-(void)setKeywords:(NSArray *)keywords
{
    [keywords retain];
    [_keywords release];
    _keywords=keywords;
    
    [self searchForKeyword];
    
    [self reloadData];
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    if (!selectedTextColor) return;
    if (CGColorEqualToColor(self.selectedTextColor.CGColor, selectedTextColor.CGColor))return;
    [_selectedTextColor release];
    _selectedTextColor=selectedTextColor;
    [_selectedTextColor retain];
    [self reloadData];
}
-(void)setDefaultTextColor:(UIColor *)defaultTextColor
{
    if (!defaultTextColor) return;
    if (CGColorEqualToColor(self.defaultTextColor.CGColor, defaultTextColor.CGColor))return;
    [_defaultTextColor release];
    _defaultTextColor=defaultTextColor;
    [_defaultTextColor retain];
    [self reloadData];
}
-(void)setCurrentSelectTextColor:(UIColor *)currentSelectTextColor
{
    if (!currentSelectTextColor) return;
    if (CGColorEqualToColor(self.currentSelectTextColor.CGColor, currentSelectTextColor.CGColor))return;
    [_currentSelectTextColor release];
    _currentSelectTextColor=currentSelectTextColor;
    [_currentSelectTextColor retain];
    for (YJChar *charStr in self.selectedResult.charStrArr)
    {
        [self reloadDataInRect:charStr.frame];
    }
}
-(void)searchChangedFrame
{
    if ([self.delegate respondsToSelector:@selector(frameChangedToRect:searchView:)])
    {
        [self.delegate frameChangedToRect:self.frame searchView:self];
    }
}
-(YJChar *)getCharStrWithIndex:(int)index
{
    if (index>=0&&index<self.aCharStringArr.count)
    {
        return [self.aCharStringArr objectAtIndex:index];
    }
    return nil;
}
-(NSMutableArray *)seachForString:(NSString *)string
{
    int length=string.length;
    if (length<=0) return nil;
    NSMutableArray *resultArr=[[NSMutableArray alloc] init];
    int index=self.searchResultArr.count;
    for (int i=0; i<(self.contentString.length/length-1)*length; i++)
    {
        NSString *subStr=[self.contentString substringWithRange:NSMakeRange(i, length)];
        if ([subStr isEqualToString:string])
        {
            YJSearchResult *result=[[YJSearchResult alloc] init];
            result.range=NSMakeRange(i, length);
            NSMutableArray *charArr=[[NSMutableArray alloc] initWithCapacity:length];
            for (int j=i; j<i+length; j++)
            {
                YJChar *charStr=[self getCharStrWithIndex:j];
                if (charStr)
                {
                    [charArr addObject:charStr];
                }
            }
            result.charStrArr=charArr;
            [charArr release];
            [resultArr addObject:result];
            [result release];
            index++;
        }
    }
    return [resultArr autorelease];
}
-(void)reloadData
{
    [self setNeedsDisplay];
}
-(void)reloadDataInRect:(CGRect)rect
{
    [self setNeedsDisplayInRect:rect];
}
-(CGRect)getContentRectWithFrame:(CGRect)frame
{
    __block float height_p=0.0f;
    self.aCharStringArr=[self.contentString getYJCharArrWithWidth:self.contentWidth-self.x_span withFont:self.font?self.font:__TEXT_FONT_ height:^(float height){
        height_p=height;} startX:self.x_span/2];
    CGRect rect=frame;
    rect.size.height=height_p>rect.size.height?height_p:rect.size.height;
    return rect;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        selectedIndex=0;
        _selectedTextColor=[[UIColor redColor] retain];
        _currentSelectTextColor=[[UIColor blueColor] retain];
        _defaultTextColor=[[UIColor blackColor] retain];
        _searchResultArr=[[NSMutableArray alloc] init];
    }
    return self;
}
-(id)initWithString:(NSString *)string frame:(CGRect)frame
{
    _contentWidth=frame.size.width;
    _contentString=string;
    [_contentString retain];
    return [self initWithFrame:[self getContentRectWithFrame:frame]];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    for(YJChar *str in self.aCharStringArr)
    {
        if (CGRectContainsRect(rect, str.frame))
        {
            for (int i=0; i<self.searchResultArr.count; i++)
            {
                YJSearchResult *result=[self.searchResultArr objectAtIndex:i];
                if (str.location>=result.range.location&&str.location<result.range.location+result.range.length)
                {
                    if (i==selectedIndex)
                    {
                        CGContextSetFillColorWithColor(context, self.currentSelectTextColor.CGColor);
                    }else{
                        CGContextSetFillColorWithColor(context, self.selectedTextColor.CGColor);
                    }
//                    CGContextFillRect(context, str.frame);
//                    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                    break;
                }else{
                    CGContextSetFillColorWithColor(context, self.defaultTextColor.CGColor);
                }
            }
            [str.aChar drawInRect:str.frame withFont:str.font];
        }
    }
    UIGraphicsPopContext();
}
-(YJSearchResult *)gotoNextSearchResult
{
    selectedIndex++;
    if (selectedIndex>=self.searchResultArr.count)
    {
        selectedIndex=0;
    }
    for (YJChar *str in self.selectedResult.charStrArr)
    {
        [self reloadDataInRect:str.frame];
    }
    if (self.searchResultArr.count>0)
    {
        self.selectedResult=[self.searchResultArr objectAtIndex:selectedIndex];

        for (YJChar *str in self.selectedResult.charStrArr)
        {
            [self reloadDataInRect:str.frame];
        }
    }else{
        self.selectedResult=nil;
    }
    return self.selectedResult;
}
-(YJSearchResult *)gotoPreviousSearchResult
{
    selectedIndex--;
    if (selectedIndex<0)
    {
        selectedIndex=self.searchResultArr.count-1;
    }
    for (YJChar *str in self.selectedResult.charStrArr)
    {
        [self reloadDataInRect:str.frame];
    }
    if (self.searchResultArr.count>0)
    {
        self.selectedResult=[self.searchResultArr objectAtIndex:selectedIndex];
        for (YJChar *str in self.selectedResult.charStrArr)
        {
            [self reloadDataInRect:str.frame];;
        }
    }else{
        self.selectedResult=nil;
    }
    return self.selectedResult;
}
#pragma mark-- YJTouchDelegate Methods
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject] locationInView:self];
    for (YJChar *charStr in self.aCharStringArr)
    {
        if (CGRectContainsPoint(charStr.frame, point))
        {
            if ([self.delegate respondsToSelector:@selector(tapCharString:inSearchVeiw:keyword:keywordIndex:)])
            {
                for (int i=0; i<self.searchResultArr.count; i++)
                {
                    YJSearchResult *result=[self.searchResultArr objectAtIndex:i];
                    if (result.range.location<=charStr.location&&charStr.location<=result.range.location+result.range.length)
                    {
                        [self.delegate tapCharString:charStr inSearchVeiw:self keyword:result.keyword keywordIndex:i];
                        return;
                    }
                }
                [self.delegate tapCharString:charStr inSearchVeiw:self keyword:nil keywordIndex:-1];
                return;
            }
        }
    }
}
@end

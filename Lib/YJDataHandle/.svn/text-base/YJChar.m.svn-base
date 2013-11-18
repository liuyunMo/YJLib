//
//  YJChar.m
//  TestYJFramework
//
//  Created by szfore on 13-5-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJChar.h"

@implementation YJChar
-(NSString *)description
{
    return [NSString stringWithFormat:@"char:%@,font:%@,size:%@,rect:%@,isReturnKey:%d,location:%d",self.aChar,self.font.description,[NSValue valueWithCGSize:self.size],[NSValue valueWithCGRect:self.frame],self.isReturnKey,self.location];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self =[super init])
    {
        
    }
    return self;
}
-(NSData *)data
{
    return nil;
}
-(NSString *)aChar
{
    return [NSString stringWithUTF8String:aChar];
}
-(void)setAChar:(NSString *)charStr
{
    if (!charStr) return;
    if (NULL!=aChar) free(aChar);
    aChar =(char *)malloc(charStr.length+1);
    strcpy(aChar, [charStr UTF8String]);
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_font release];
    free(aChar);
    [super dealloc];
}
@end
@implementation UIFont (YJChar)
-(NSString *)description
{
    return [NSString stringWithFormat:@"fontName:%@,fontSize:%f",self.fontName,self.pointSize];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self =[super init])
    {
        
    }
    return self;
}
@end
@implementation NSString (YJChar)
-(NSMutableArray *)getYJCharArrWithWidth:(float)contentWidth withFont:(UIFont *)font height:(void(^)(float height))block startX:(float)startX
{
    NSMutableArray *valueArr=[[NSMutableArray alloc] init];
    NSArray *strArr=[self componentsSeparatedByString:@"\n"];
    float height=0.0f;
    int charCount=0;
    for(NSString *subStr in strArr)
    {
        float width=startX;
        for (int i=0; i<subStr.length; i++)
        {
            YJChar *char_str=[[YJChar alloc] init];
            char_str.isReturnKey=NO;
            char_str.aChar=[subStr substringWithRange:NSMakeRange(i, 1)];
            char_str.location=i+charCount;
            char_str.font=font;
            char_str.size=[char_str.aChar sizeWithFont:font];
            if (width+char_str.size.width>=contentWidth)
            {
                width=startX;
                height+=char_str.size.height;
            }
            char_str.frame=CGRectMake(width, height, char_str.size.width, char_str.size.height);
            width+=char_str.size.width;
            [valueArr addObject:char_str];
            [char_str release];
        }
        charCount+=subStr.length+1;
        
        YJChar *char_return=[[YJChar alloc] init];
        char_return.aChar=@"\n";
        char_return.font=font;
        char_return.isReturnKey=YES;
        char_return.location=charCount;
        char_return.size=[@"\n" sizeWithFont:font];
        [valueArr addObject:char_return];
        [char_return release];
        
        height+=char_return.size.height;
        char_return.frame=CGRectMake(startX, height, char_return.size.width, char_return.size.height);
    }
    [valueArr removeLastObject];
    block(height);
    return [valueArr autorelease];
}
@end
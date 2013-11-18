//
//  YJXMLParse.m
//  iTest
//
//  Created by szfore on 13-4-8.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJXMLParse.h"

@implementation YJXMLParse
-(id)initWithFilePath:(NSString *)filePath
{
    if (self=[super init])
    {
        NSXMLParser *parser=[[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        parser.delegate=self;
        [parser parse];
        [parser release];
    }
    return self;
}
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    printf("\n开始解析");
    self.contentArr=[NSMutableArray array];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    printf("\n解析完成");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Row"])
    {
        self.str=[NSMutableString string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Row"])
    {
        [self.str replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, self.str.length)];
        if (self.str&&![self.str isEqualToString:@""])
        {
            [self.contentArr addObject:self.str];
            self.str=nil;
        }
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.str) {
        [self.str appendString:string];
    }
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_contentArr release];
    [_str release];
    [super dealloc];
}
@end

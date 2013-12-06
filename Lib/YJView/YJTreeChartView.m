//
//  YJTreeChartView.m
//  YJLib
//
//  Created by zhongyy on 13-12-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTreeChartView.h"
//kVerticalk
#define SPAN_MIN_HORIZONTAL 10  //  水平最小间距

#define USE_LINE  0

#define SPA_V_F         3       //同层node的偏移

#define SPAN_BORDER     30      //边框

#define NODE_MIN_WIDTH      60
#define NODE_HEIGHT         20


@implementation YJTreeNode
-(id)init
{
    if ([super init]){
        self.font=[UIFont systemFontOfSize:17];
        self.lineColor=[UIColor lightGrayColor];
        self.textColor=[UIColor colorWithRed:0.291 green:0.090 blue:0.445 alpha:1.000];
        self.borderColor=[UIColor lightGrayColor];
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_nodeName release];
    [_lineColor release];
    [_borderColor release];
    [_textColor release];
    [_font release];
    [_subNodeIds release];
    [super dealloc];
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@_%@_%d",_nodeName,_subNodeIds,_floorIndex];
}
@end
@interface YJTreeChartView()
{
    NSMutableArray *dataArr;
    int floorCount;
    float maxWidth;
    float maxHeight;
    
    float currentX;// kHorizontal
}
@property(nonatomic,copy)NSString *rootNodeName;
@end
@implementation YJTreeChartView
-(void)addNode:(YJTreeNode*)node
{
    [dataArr addObject:node];
    floorCount=floorCount>node.floorIndex?floorCount:node.floorIndex;
    [self setFitSize];
    [self setNeedsDisplay];
}
-(void)collectAllSubNode:(YJTreeNode *)node fromArr:(NSArray *)arr toArr:(NSMutableArray **)toArr;
{
    if ([*toArr isKindOfClass:[NSMutableArray class]])
    {
        for (NSString *subNodeId in node.subNodeIds)
        {
            YJTreeNode *subNode=[self getNodeWithId:[subNodeId intValue] fromArr:dataArr];
            if (subNode) {
                [*toArr addObject:subNode];
            }
            [self collectAllSubNode:subNode fromArr:dataArr toArr:toArr];
        }
    }
}
-(void)removeNode:(YJTreeNode *)node
{
    
    YJTreeNode *supNode=[self getSuperNode:node];
    NSMutableArray *supNodeSubNodeIds=[NSMutableArray arrayWithArray:supNode.subNodeIds];
    for (NSString *nodeIdStr in supNodeSubNodeIds)
    {
        if (node.nodeId==[nodeIdStr intValue])
        {
            [supNodeSubNodeIds removeObject:nodeIdStr];
            break;
        }
    }
    supNode.subNodeIds=supNodeSubNodeIds;
    
    NSMutableArray *deleNodes=[NSMutableArray arrayWithObject:node];
    [self collectAllSubNode:node fromArr:dataArr toArr:&deleNodes];
    
    [dataArr removeObjectsInArray:deleNodes];
    
    int floorIndexMax=0;
    for (YJTreeNode *tNode in dataArr)
    {
        floorIndexMax=floorIndexMax>tNode.floorIndex?floorIndexMax:tNode.floorIndex;
    }
    floorCount=floorIndexMax;
    [self setFitSize];
    [self setNeedsDisplay];
}
-(YJTreeNode *)getSuperNode:(YJTreeNode *)node
{
    return [self getSuperNode:node FromArr:dataArr];
}
-(YJTreeNode *)getSuperNode:(YJTreeNode *)node FromArr:(NSArray *)arr
{

    for (YJTreeNode *tNode in arr)
    {
        for (NSString *nodeIdStr in tNode.subNodeIds)
        {
            if (node.nodeId==[nodeIdStr intValue])
            {
                return tNode;
            }
        }
    }
    return nil;
}
/*
-(void)changeNode:(YJTreeNode *)node toName:(NSString *)name
{
    YJTreeNode *preNode=[self getSuperNode:node];
    NSMutableArray *subNodeNames=[NSMutableArray arrayWithArray:preNode.subNodeNames];
    for (NSString *subName in subNodeNames)
    {
        if ([subName isEqualToString:node.nodeName])
        {
            [subNodeNames replaceObjectAtIndex:[subNodeNames indexOfObject:subName] withObject:name];
            break;
        }
    }
    preNode.subNodeNames=subNodeNames;
    node.nodeName=name;
    [self refurbishView];
    
}
 */
-(void)refurbishView
{
    [self setFitSize];
    [self setNeedsDisplay];
}
-(void)reDraw
{
    self.data=_data;
    [self setNeedsDisplay];
}
- (void)dealloc
{
    DEALLOC_PRINTF;
    [_data release];
    [dataArr release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _spanBetFlo=50;
        dataArr=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)setFitSize
{
    maxWidth  =MIN(self.bounds.size.width - SPAN_BORDER*2, KEY_WINDOW.frame.size.width  ) ;
    maxHeight = MIN(self.bounds.size.height - SPAN_BORDER*2, KEY_WINDOW.frame.size.height  ) ;
    
    for(int i=0;i<floorCount;i++)
    {
        NSArray *arr=[self getNodeWithFloor:i+1];
        
        switch (self.direction) {
            case kVertical:
            {
                float width=0;
                width+=SPAN_MIN_HORIZONTAL*(arr.count+1);
                for (YJTreeNode *node in arr)
                {
                    int nodeWidth=[node.nodeName sizeWithFont:node.font].width+10;
                    node.width=nodeWidth>NODE_MIN_WIDTH?nodeWidth:NODE_MIN_WIDTH;
                    node.height=NODE_HEIGHT;
                    width+=node.width;
                }
                maxWidth=maxWidth>width?maxWidth:width;
            }
                
                break;
            case kHorizontal:
            {
                float subHeightMax=0;
                float subWidthMax=0;
                
                subHeightMax+=SPAN_MIN_HORIZONTAL*(arr.count+1);
                
                for (YJTreeNode *node in arr)
                {
                    int nodeWidth=[node.nodeName sizeWithFont:node.font].width+10;
                    node.width=nodeWidth>NODE_MIN_WIDTH?nodeWidth:NODE_MIN_WIDTH;
                    node.height=NODE_HEIGHT;
                    subWidthMax=subWidthMax>node.width?subWidthMax:node.width;
                    subHeightMax+=node.height;
                }
                maxWidth+=subWidthMax+self.spanBetFlo;
                maxHeight=MAX(subHeightMax, maxHeight);
            }
                break;
            default:
                break;
        }
        
        
    }
    switch (self.direction) {
        case kVertical:
            maxHeight=MAX(maxHeight, SPAN_BORDER+self.spanBetFlo*(floorCount-1)+NODE_HEIGHT*floorCount);
            
            break;
        case kHorizontal:
            maxWidth-=self.spanBetFlo*2;
            maxWidth=MAX(maxWidth, SPAN_BORDER+self.spanBetFlo*(floorCount-1)+NODE_MIN_WIDTH*floorCount);
            break;
            
        default:
            break;
    }
    
    CGRect rect=self.frame;
    rect.size.width=maxWidth+SPAN_BORDER*2;
    rect.size.height=maxHeight+SPAN_BORDER*2;
    
    
    if ([self.delegate respondsToSelector:@selector(view:willChangeToFrame:from:)]) {
        [self.delegate view:self willChangeToFrame:rect from:self.frame];
    }
    
    self.frame=rect;
}
-(void)setData:(NSDictionary *)data
{
    SET_PAR(_data, data);
    [dataArr removeAllObjects];
    
    
    floorCount=0;
    [self collectNodeFromArr:[[_data allValues] lastObject] withSupNodeName:[[[_data allKeys] lastObject] intValue] floor:1 toArray:&dataArr floorCount:&floorCount];
    
    self.rootNodeName=[[_data allKeys] lastObject];
    [self setFitSize];
}
-(void)collectNodeFromArr:(NSArray *)arr withSupNodeName:(int)supNodeId floor:(int)floor toArray:(NSMutableArray **)toArr floorCount:(int *)floorCountRef
{
    NSMutableArray *subNodeIdArr=[NSMutableArray array];
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *dict=[arr objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            [subNodeIdArr addObject:dict];
            YJTreeNode *node=[[YJTreeNode alloc] init];
            node.nodeId=[(NSString *)dict intValue];
            node.nodeName=[NSString stringWithFormat:@"node id =%d",node.nodeId];
            node.subNodeIds=nil;
            node.floorIndex=floor+1;
            
            *floorCountRef=MAX(*floorCountRef, node.floorIndex);
            if ([*toArr isKindOfClass:[NSMutableArray class]])
            {
                [*toArr addObject:node];
            }
            [node release];
            
        }else{
            [subNodeIdArr addObject:[[dict allKeys] lastObject]];
            NSArray *subArr=[[dict allValues] lastObject];
            [self collectNodeFromArr:subArr withSupNodeName:[[[dict allKeys] lastObject] intValue] floor:floor+1 toArray:toArr floorCount:floorCountRef];
        }
    }
    
    YJTreeNode *node=[[YJTreeNode alloc] init];
    node.nodeId=supNodeId;
    node.nodeName=[NSString stringWithFormat:@"node id =%d",node.nodeId];
    node.subNodeIds=subNodeIdArr;
    node.floorIndex=floor;
    
    *floorCountRef=MAX(*floorCountRef, node.floorIndex);
    if ([*toArr isKindOfClass:[NSMutableArray class]])
    {
        [*toArr addObject:node];
    }
    [node release];
}
/*
-(void)getNodeName:(NSArray *)arr withSupNodeName:(NSString *)name floor:(int)floor
{
    NSMutableArray *nameArr=[NSMutableArray array];
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *dict=[arr objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            [nameArr addObject:(NSString *)dict];
            YJTreeNode *node=[[YJTreeNode alloc] init];
            node.nodeName=(NSString *)dict;
            node.subNodeNames=nil;
            node.floorIndex=floor+1;
            
            floorCount=floorCount>node.floorIndex?floorCount:node.floorIndex;
            [dataArr addObject:node];
        }else{
            [nameArr addObject:[[dict allKeys] lastObject]];
            NSArray *subArr=[[dict allValues] lastObject];
            [self getNodeName:subArr withSupNodeName:[[dict allKeys] lastObject] floor:floor+1];
        }
    }
    
    YJTreeNode *node=[[YJTreeNode alloc] init];
    node.nodeName=name;
    node.subNodeNames=nameArr;
    node.floorIndex=floor;
    
    floorCount=floorCount>floor?floorCount:floor;
    [dataArr addObject:node];
}
 */
-(NSArray *)getNodeWithFloor:(int)floorIndex
{
    NSMutableArray *nodes=[NSMutableArray array];
    for (YJTreeNode *node in dataArr) {
        if (node.floorIndex==floorIndex)
        {
            [nodes addObject:node];
        }
    }
    return nodes;
}
-(YJTreeNode *)getNodeWithId:(int)nodeId fromArr:(NSArray*)arr
{
    for (YJTreeNode *node in arr)
    {
        if (node.nodeId==nodeId)
        {
            return node;
        }
    }
    return nil;
}
/*
-(YJTreeNode *)getNodeWithNodeName:(NSString*)nodeName
{
    for (YJTreeNode *node in dataArr)
    {
        if ([node.nodeName isEqualToString:nodeName])
        {
            return node;
        }
    }
    return nil;
}
 */
-(void)drawHorizontalFloor:(int)floorIndex ctx:(CGContextRef)ctx rect:(CGRect)bounds
{
    NSArray *rootArr=[self getNodeWithFloor:floorIndex];
    
    int nodeCount=rootArr.count;
    int subNodeCount=0;
    
    float span_rn=0;
    float rootNodeTotalHeight=0;
    float span_sn=0;
    float subNodeTotalHeight=0;
    for (YJTreeNode *node in rootArr)
    {
        subNodeCount+=node.subNodeIds.count;
        rootNodeTotalHeight+=node.height;
        
        for (NSString *subNodeId in node.subNodeIds)
        {
            YJTreeNode *subNode=[self getNodeWithId:[subNodeId intValue] fromArr:dataArr];
            subNodeTotalHeight+=subNode.height;
        }
    }
    
    rootNodeTotalHeight+=(rootArr.count-1)*NODE_HEIGHT;
    if (rootNodeTotalHeight>=maxHeight)
    {
        span_rn=SPAN_MIN_HORIZONTAL;
    }else{
        span_rn=(bounds.size.height-nodeCount*NODE_HEIGHT)/(nodeCount+1);
    }
    
    subNodeTotalHeight+=(subNodeCount-1)*NODE_HEIGHT;
    if (subNodeTotalHeight>=maxHeight)
    {
        span_sn=SPAN_MIN_HORIZONTAL;
    }else{
        span_sn=(bounds.size.height-subNodeCount*NODE_HEIGHT)/(subNodeCount+1);
    }
    
    float currY=bounds.origin.y+span_rn;
    float subCurrY=span_sn+bounds.origin.y;
    float maxNodeWidth=0;
    for(int i=0;i<rootArr.count;i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        maxNodeWidth=maxNodeWidth>node.width?maxNodeWidth:node.width;
        maxNodeWidth+=node.subNodeIds.count*SPA_V_F;
    }
    
    for(int i=0;i<rootArr.count;i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        
        float x = currentX;
        float y = currY;
        float w = node.width;
        float h = node.height;
        
        CGRect rootRect=CGRectMake(x, y, w, h);
        node.rect=rootRect;
        
        if ([self.delegate respondsToSelector:@selector(view:willDrawNode:ctx:)])
        {
            [self.delegate view:self willDrawNode:node ctx:ctx];
        }
        
        
        currY+=span_rn+node.height;
        
        CGContextSaveGState(ctx);
        [node.textColor setFill];
        [node.borderColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        CGContextAddRect(ctx, rootRect);
        
        
        [node.nodeName drawInRect:rootRect withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
        
        if ([self.delegate respondsToSelector:@selector(view:endDrawNode:ctx:)])
        {
            [self.delegate view:self endDrawNode:node ctx:ctx];
        }
        
        CGContextSaveGState(ctx);
        [node.lineColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        
        for (int j=0; j<node.subNodeIds.count; j++)
        {
            float sx=x+maxNodeWidth+self.spanBetFlo;
            float sy=subCurrY;
            
            int subNodeId=[[node.subNodeIds objectAtIndex:j] intValue];
            YJTreeNode *subNode=[self getNodeWithId:subNodeId fromArr:dataArr];
            
            float cx=x+maxNodeWidth+self.spanBetFlo/2-(rootArr.count-i)*SPA_V_F;
            
            if (cx<=x+maxNodeWidth) {
                cx=(i+1)*SPA_V_F+x+maxNodeWidth;
            }
            if (cx>=x+maxNodeWidth+self.spanBetFlo)
            {
                cx=x+maxNodeWidth+self.spanBetFlo-(rootArr.count-i)*SPA_V_F;
            }
            
            CGContextMoveToPoint(ctx, x+w, y+h/2);
            if (USE_LINE) {
                CGContextAddLineToPoint(ctx, cx, y+h/2);
                CGContextAddLineToPoint(ctx, cx, sy+subNode.height/2);
                CGContextAddLineToPoint(ctx, sx, sy+subNode.height/2);
            }else{
                CGContextAddLineToPoint(ctx, x+maxNodeWidth, y+h/2);
                CGContextAddCurveToPoint(ctx, x+maxNodeWidth, y+h/2, cx, sy+subNode.height/2, sx-5, sy+subNode.height/2);
                CGContextAddLineToPoint(ctx, sx, sy+subNode.height/2);
                
            }
            subCurrY+=span_sn+subNode.height;
        }
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    currentX+=maxNodeWidth+self.spanBetFlo;
}
/*
-(void)drawFloor:(int)floorIndex ctx:(CGContextRef)ctx rect:(CGRect)bounds
{
    
    NSArray *rootArr=[self getNodeWithFloor:floorIndex];
    
    int nodeCount=rootArr.count;
    int subNodeCount=0;
    
    float span_rn=0;
    float rootNodeTotalWidth=0;
    float span_sn=0;
    float subNodeTotalWidth=0;
    for (YJTreeNode *node in rootArr)
    {
        subNodeCount+=node.subNodeNames.count;
        rootNodeTotalWidth+=node.width;
        
        for (NSString *subNodeName in node.subNodeNames)
        {
            YJTreeNode *subNode=[self getNodeWithNodeName:subNodeName];
            subNodeTotalWidth+=subNode.width;
        }
    }
    
    rootNodeTotalWidth+=(rootArr.count-1)*NODE_MIN_WIDTH;
    if (rootNodeTotalWidth>=maxWidth)
    {
        span_rn=SPAN_MIN_HORIZONTAL;
    }else{
        span_rn=(bounds.size.width-nodeCount*NODE_MIN_WIDTH)/(nodeCount+1);
    }
    
    subNodeTotalWidth+=(subNodeCount-1)*NODE_MIN_WIDTH;
    if (subNodeTotalWidth>=maxWidth)
    {
        span_sn=SPAN_MIN_HORIZONTAL;
    }else{
        span_sn=(bounds.size.width-subNodeCount*NODE_MIN_WIDTH)/(subNodeCount+1);
    }
    
    float currX=bounds.origin.x+span_rn;
    float subCurrX=span_sn+bounds.origin.x;
    
    for(int i=0;i<rootArr.count;i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        
        float x = currX;
        float y = SPAN_BORDER+(floorIndex-1)*(self.spanBetFlo+node.height);
        float w = node.width;
        float h = node.height;
        
        CGRect rootRect=CGRectMake(x, y, w, h);
        node.rect=rootRect;
        
        currX+=span_rn+node.width;
        
        CGContextSaveGState(ctx);
        [node.textColor setFill];
        [node.borderColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        CGContextAddRect(ctx, rootRect);
        
        
        [node.nodeName drawInRect:rootRect withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
        
        if ([self.delegate respondsToSelector:@selector(view:endDrawNode:ctx:)])
        {
            [self.delegate view:self endDrawNode:node ctx:ctx];
        }
        
        CGContextSaveGState(ctx);
        [node.lineColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        for (int j=0; j<node.subNodeNames.count; j++)
        {
            float sx=subCurrX;
            float sy=y+h+self.spanBetFlo;
            
            NSString *subNodeName=[node.subNodeNames objectAtIndex:j];
            YJTreeNode *subNode=[self getNodeWithNodeName:subNodeName];
            
            
            CGContextMoveToPoint(ctx, x+w/2, y+h);
            CGContextAddLineToPoint(ctx, x+w/2, y+h+self.spanBetFlo/2+i*SPA_V_F);
            CGContextAddLineToPoint(ctx, sx+subNode.width/2, y+h+self.spanBetFlo/2+i*SPA_V_F);
            CGContextAddLineToPoint(ctx, sx+subNode.width/2, sy);
            
            subCurrX+=span_sn+subNode.width;
        }
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
}
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] setFill];
    CGContextFillRect(ctx,rect);
    CGContextRestoreGState(ctx);
    
    CGRect drawRect=CGRectMake(rect.origin.x+SPAN_BORDER, rect.origin.y+SPAN_BORDER, rect.size.width-2*SPAN_BORDER, rect.size.height-2*SPAN_BORDER);
    switch (self.direction) {
        case kVertical:
            /*  暂不支持
            for (int i=0; i<floorCount+1; i++)
            {
                [self drawFloor:i ctx:ctx rect:drawRect];
            }*/
            break;
        case kHorizontal:
            currentX=SPAN_BORDER;
            for (int i=0; i<floorCount+1; i++)
            {
                [self drawHorizontalFloor:i ctx:ctx rect:drawRect];
            }
            break;
            
        default:
            break;
    }
    
}
-(void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:self];
    YJTreeNode *seleNode=nil;
    for (YJTreeNode *node in dataArr)
    {
        node.selected=NO;
        if (CGRectContainsPoint(node.rect, touchPoint))
        {
            seleNode=node;
            seleNode.selected=YES;
        }
    }
    if(seleNode)
    {
        [self setNeedsDisplay];
        if ([self.delegate respondsToSelector:@selector(view:selectNode:)]) {
            [self.delegate view:self selectNode:seleNode];
        }
    }
}
@end

//
//  YJTreeChartView.m
//  YJLib
//
//  Created by zhongyy on 13-12-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "YJTreeChartView.h"
//kVerticalk
#define SPAN_MIN  30  //  node最小间距

#define USE_LINE  0

#define SPA_V_F         0       //同层node的偏移

#define SPAN_BORDER     30      //边框

#define NODE_MIN_WIDTH      60
#define NODE_HEIGHT         30

#define DRAW_FONT  [UIFont systemFontOfSize:15]

CGPathRef createPath(CGRect rect ,float r)
{
    float x=rect.origin.x;
    float y=rect.origin.y;
    float w=rect.size.width;
    float h=rect.size.height;
    
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x+r, y);
    CGPathAddLineToPoint(path, NULL, x+w-r, y);
    CGPathAddArc(path, NULL, x+w-r, y+r, r, -M_PI/2,0, 0);
    CGPathAddLineToPoint(path, NULL, x+w, y+h-r);
    CGPathAddArc(path, NULL, x+w-r, y+h-r, r, 0, M_PI/2, 0);
    CGPathAddLineToPoint(path, NULL, x+r, y+h);
    CGPathAddArc(path, NULL, x+r, y+h-r, r, M_PI/2, M_PI, 0);
    CGPathAddLineToPoint(path, NULL, x, y+r);
    CGPathAddArc(path, NULL, x+r, y+r, r, M_PI, M_PI*3/2, 0);
    return path;
}
@implementation YJTreeNode
-(id)init
{
    if ([super init]){
        self.font=DRAW_FONT;
        self.lineColor=[UIColor lightGrayColor];
        self.textColor=[UIColor colorWithRed:0.291 green:0.090 blue:0.445 alpha:1.000];
        self.borderColor=[UIColor lightGrayColor];
        self.enable=YES;
    }
    return self;
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_desc release];
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
    int selectNodeId;
}
@end
@implementation YJTreeChartView
-(NSArray *)nodeArr
{
    return dataArr;
}
-(NSString *)desc
{
    NSMutableString *desc=[NSMutableString string];
    for (int i=0; i<floorCount; i++)
    {
        NSArray *arr=[self getNodeWithFloor:i+1];
        for (YJTreeNode *node in arr)
        {
            YJTreeNode *supNode=[self getSuperNode:node];
            
            if (supNode) {
                [desc appendFormat:@"针对问题（%@）",supNode.nodeName];
                switch (node.type) {
                    case kNodeMethod:
                        [desc appendFormat:@"提出了解决方法：%@\n",node.nodeName];
                        break;
                    case kNodeQuestion:
                    {
                        [desc appendFormat:@"重新定义问题：%@\n",node.nodeName];
                        int mC=0;
                        int qC=0;
                        for (NSString *idStr in node.subNodeIds)
                        {
                            YJTreeNode *subNode=[self getNodeWithId:[idStr intValue] fromArr:dataArr];
                            if (subNode.type==kNodeQuestion) {
                                qC++;
                            }else{
                                mC++;
                            }
                        }
                        [desc appendFormat:@"针对问题（%@）获得%d个方法，重定义%d个问题\n",node.nodeName,mC,qC];
                    }
                        break;
                    default:
                        break;
                }
            }else{
                [desc appendFormat:@"提出了问题：%@\n",node.nodeName];
                int mC=0;
                int qC=0;
                for (NSString *idStr in node.subNodeIds)
                {
                    YJTreeNode *subNode=[self getNodeWithId:[idStr intValue] fromArr:dataArr];
                    if (subNode.type==kNodeQuestion) {
                        qC++;
                    }else{
                        mC++;
                    }
                }
                [desc appendFormat:@"针对问题（%@）获得%d个方法，重定义%d个问题\n",node.nodeName,mC,qC];
            }
        }
    }
    return desc;
}
-(void)addNode:(YJTreeNode*)node
{
    YJTreeNode *supNode=[self getSuperNode:node];
    [dataArr insertObject:node atIndex:[dataArr indexOfObject:supNode]+1];
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
    
    if ([self.delegate respondsToSelector:@selector(view:willDeleteNodes:superNode:)]) {
        [self.delegate view:self willDeleteNodes:deleNodes superNode:supNode];
    }
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
-(void)countSubNode:(int *)count fromNode:(YJTreeNode *)node fromArr:(NSArray *)arr
{
    *count+=node.subNodeIds.count;
    for (NSString *idStr in node.subNodeIds)
    {
        YJTreeNode *subNode=[self getNodeWithId:[idStr intValue] fromArr:arr];
        if (subNode)
        {
            if (subNode.subNodeIds.count>0)
            {
                *count-=1;
                [self countSubNode:count fromNode:subNode fromArr:arr];
            }
        }
    }
}
-(int)getAllSubNodeCount:(YJTreeNode *)node fromArr:(NSArray *)arr
{
    int count=0;
    [self countSubNode:&count fromNode:node fromArr:arr];
    return count;
}
-(NSArray *)getSubNodes:(YJTreeNode *)node fromArr:(NSArray *)arr
{
    NSMutableArray *nodes=[NSMutableArray array];
    for (NSString *idStr in node.subNodeIds)
    {
        YJTreeNode *subNode=[self getNodeWithId:[idStr intValue] fromArr:arr];
        if (subNode)
        {
            [nodes addObject:subNode];
        }
    }
    if(nodes.count>0)
    {
       return nodes; 
    }
    return nil;
}
-(YJTreeNode *)getSuperNode:(YJTreeNode *)node withIndex:(int*)indexRef
{
    for (YJTreeNode *tNode in dataArr)
    {
        for (NSString *nodeIdStr in tNode.subNodeIds)
        {
            if (node.nodeId==[nodeIdStr intValue])
            {
                *indexRef=[tNode.subNodeIds indexOfObject:nodeIdStr];
                return tNode;
            }
        }
    }
    return nil;
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
-(void)setNodesToShow:(NSArray *)nodes
{
    if (!dataArr) {
        dataArr=[[NSMutableArray alloc] init];
    }
    [dataArr removeAllObjects];
    if(nodes)[dataArr addObjectsFromArray:nodes];
    
    for (YJTreeNode *node in dataArr) {
        floorCount=MAX(floorCount, node.floorIndex);
    }
    [self refurbishView];
}
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
#ifdef USE_TASK_PIC_MODEL
-(void)setFitSize
{
    //node 所占高度 ＝ node.subNodeCount*nodeHeight+(node.subNodeCount+1)*SPAN_MIN
    for (YJTreeNode *node in dataArr) {
        node.contentHeight=0;
        node.contentWidth=0;
    }
    maxHeight=0;
    maxWidth=0;
    
    for (int i=floorCount; i>0; i--)
    {
        NSArray *nodes=[self getNodeWithFloor:i];
        float f_maxWidth=0;
        for (YJTreeNode *node in nodes)
        {
            node.contentWidth=[node.nodeName sizeWithFont:node.font].width+15;
            node.contentWidth=MAX(node.contentWidth, NODE_MIN_WIDTH);
            f_maxWidth=f_maxWidth>node.contentWidth?f_maxWidth:node.contentWidth;
            if (node.contentHeight==0) {
                node.contentHeight+=2*5+NODE_HEIGHT;
            }
            YJTreeNode *supNode=[self getSuperNode:node];
            if (supNode) {
                supNode.contentHeight+=node.contentHeight+5;
            }else{
                
            }
        }
        maxWidth+=f_maxWidth;
    }
    maxWidth+=(floorCount+1)*5;
    YJTreeNode *rootNode=[[self getNodeWithFloor:1] lastObject];
    maxHeight=rootNode.contentHeight;
    maxWidth=MAX(maxWidth, self.bounds.size.width);
    maxHeight=MAX(maxHeight, self.bounds.size.height);
    
    for (int i=1; i<floorCount; i++)
    {
        
        NSArray *nodes=[self getNodeWithFloor:i];
        if (i==1)
        {
            YJTreeNode *rootNode = [nodes lastObject];
            int allSubCount=[self getAllSubNodeCount:rootNode fromArr:dataArr];
            NSLog(@"%d",allSubCount);
            CGRect rect=rootNode.rect;
            rect.size.height=NODE_HEIGHT;
            rect.size.width=rootNode.contentWidth;
            rect.origin.x=SPAN_BORDER;
            rect.origin.y=maxHeight/2-rect.size.height/2;
            rootNode.rect=rect;
        }
        
        for (YJTreeNode *node in nodes)
        {
            int allSubCount=[self getAllSubNodeCount:node fromArr:dataArr];
           
            
            NSArray *subNodes=[self getSubNodes:node fromArr:dataArr];
            
            float bg_y=node.rect.origin.y+node.rect.size.height/2-node.contentHeight/2+7.5;
            for (int i=0; i<subNodes.count; i++)
            {
                YJTreeNode *subNode=[subNodes objectAtIndex:i];
                CGRect rect=subNode.rect;
                rect.size.height=NODE_HEIGHT;
                rect.size.width=subNode.contentWidth;
                rect.origin.x=node.rect.origin.x+node.contentWidth+SPAN_MIN;
                rect.origin.y=bg_y;
                subNode.rect=rect;
                bg_y+=subNode.contentHeight;
            }
        }
    }
    
    
    CGRect rect=self.frame;
    rect.size.width=maxWidth+SPAN_BORDER*2;
    rect.size.height=maxHeight+SPAN_BORDER*2;
    
    if ([self.delegate respondsToSelector:@selector(view:willChangeToFrame:from:)]) {
        [self.delegate view:self willChangeToFrame:rect from:self.frame];
    }
    
    self.frame=rect;
}
#else
-(void)setFitSize
{
    maxWidth  =MIN(self.bounds.size.width - SPAN_BORDER*2, KEY_WINDOW.frame.size.width  ) ;
    maxHeight = MIN(self.bounds.size.height - SPAN_BORDER*2, KEY_WINDOW.frame.size.height  ) ;
    maxWidth=SPAN_BORDER;
    for(int i=0;i<floorCount;i++)
    {
        NSArray *arr=[self getNodeWithFloor:i+1];
        
        switch (self.direction) {
            case kVertical:
            {
                float width=0;
                width+=SPAN_MIN*(arr.count+1);
                for (YJTreeNode *node in arr)
                {
                    int nodeWidth=[node.nodeName sizeWithFont:node.font].width+15;
                    node.contentWidth=nodeWidth>NODE_MIN_WIDTH?nodeWidth:NODE_MIN_WIDTH;
                    node.contentHeight=NODE_HEIGHT;
                    width+=node.contentWidth;
                }
                maxWidth=maxWidth>width?maxWidth:width;
            }
                
                break;
            case kHorizontal:
            {
                float subHeightMax=0;
                float subWidthMax=0;
                
                
                subHeightMax+=SPAN_MIN*(arr.count+1);
                
                for (YJTreeNode *node in arr)
                {
                    int nodeWidth=[node.nodeName sizeWithFont:node.font].width+10;
                    node.contentWidth=nodeWidth>NODE_MIN_WIDTH?nodeWidth:NODE_MIN_WIDTH;
                    node.contentHeight=NODE_HEIGHT;
                    subWidthMax=subWidthMax>node.contentWidth?subWidthMax:node.contentWidth;
                    subHeightMax+=node.contentHeight;
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
            maxWidth-=self.spanBetFlo;
            maxWidth=MAX(maxWidth, KEY_WINDOW.frame.size.width);
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
#endif

-(void)setData:(NSDictionary *)data
{
    SET_PAR(_data, data);
    [dataArr removeAllObjects];
    
    
    floorCount=0;
    [self collectNodeFromArr:[[_data allValues] lastObject] withSupNodeName:[[[_data allKeys] lastObject] intValue] floor:1 toArray:&dataArr floorCount:&floorCount];
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
            
            if ([self.delegate respondsToSelector:@selector(view:makeNodeToShow:)])
            {
                [self.delegate view:self makeNodeToShow:node];
            }
            
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
    
    if ([self.delegate respondsToSelector:@selector(view:makeNodeToShow:)])
    {
        [self.delegate view:self makeNodeToShow:node];
    }
    
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
#ifdef USE_TASK_PIC_MODEL
-(void)drawHorizontalFloor:(int)floorIndex ctx:(CGContextRef)ctx rect:(CGRect)bounds
{
    NSArray *rootArr=[self getNodeWithFloor:floorIndex];
    int nodeCount=rootArr.count;
//    float sp_root_total=maxHeight;
//    float f_maxWidth=0;
//    for (YJTreeNode *node in rootArr) {
//        sp_root_total-=node.contentHeight;
//        f_maxWidth=MAX(f_maxWidth, node.contentWidth);
//    }
//    float begin_y=0;
    for (int i=0; i<nodeCount; i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        int index=0;
        YJTreeNode *supNode=[self getSuperNode:node withIndex:&index];
//        float w=node.contentWidth;
//        float h=NODE_HEIGHT;
//        
//        int index=0;
//        YJTreeNode *supNode=[self getSuperNode:node withIndex:&index];
//        
//        float y=0;
//        float x=0;
//        if (supNode)
//        {
//            float sp_s_n=(supNode.contentHeight-supNode.subNodeIds.count*NODE_HEIGHT)/(supNode.subNodeIds.count+1);
//            
//            if (index==0) {
//                begin_y=sp_s_n;
//            }
//            y=begin_y;
//            begin_y+=node.contentHeight+sp_s_n;
//            x=supNode.rect.origin.x+SPAN_MIN+supNode.rect.size.width;
//        }else{
//            y=maxHeight/2-NODE_HEIGHT/2;
//            x=SPAN_BORDER;
//        }
//        
//        //CGRect rootRect=CGRectMake(x, y, w, h);
//        CGRect rect=node.rect;
//        rect.origin.x=x;
//        rect.size.width=w;
//        rect.size.height=h;
//        rect.origin.y=y;
//        node.rect=rect;
        
        CGRect rect=node.rect;
        
        if ([self.delegate respondsToSelector:@selector(view:willDrawNode:ctx:)])
        {
            [self.delegate view:self willDrawNode:node ctx:ctx];
        }
        
        CGContextSaveGState(ctx);
        [node.textColor setFill];
        [node.borderColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        CGPathRef rootPath=createPath(rect, 3);
        CGContextAddPath(ctx, rootPath);
        CGPathRelease(rootPath);
        
        float fontHight=[node.nodeName sizeWithFont:DRAW_FONT].height;
        float f_span=(rect.size.height-fontHight)/2;
        CGRect f_rect=CGRectMake(rect.origin.x, rect.origin.y+f_span, rect.size.width, rect.size.height-2*f_span);
        
        [node.nodeName drawInRect:f_rect withFont:node.font lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
        
        if ([self.delegate respondsToSelector:@selector(view:endDrawNode:ctx:)])
        {
            [self.delegate view:self endDrawNode:node ctx:ctx];
        }
        //draw line
        
        if (supNode)
        {
            CGContextSaveGState(ctx);
            CGContextSetLineWidth(ctx, 1);
            CGContextSetStrokeColorWithColor(ctx, supNode.lineColor.CGColor);
            
            float b_x=supNode.rect.origin.x+supNode.rect.size.width;
            float b_y=supNode.rect.origin.y+supNode.rect.size.height/2;
            
            float e_x=node.rect.origin.x;
            float e_y=node.rect.origin.y+node.rect.size.height/2;
            
            CGContextMoveToPoint(ctx, b_x, b_y);
            if (USE_LINE) {
                CGContextAddLineToPoint(ctx, b_x+SPAN_MIN/2.0, supNode.rect.origin.y+NODE_HEIGHT/2);
                CGContextAddLineToPoint(ctx, b_x+SPAN_MIN/2, e_y);
                CGContextAddLineToPoint(ctx, e_x,e_y);
            }else{
                CGContextAddCurveToPoint(ctx, b_x+20, b_y, e_x-20, e_y, e_x, e_y);
            }
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextRestoreGState(ctx);
        }
    }
    

}
#else
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
        rootNodeTotalHeight+=node.contentHeight;
        
        for (NSString *subNodeId in node.subNodeIds)
        {
            YJTreeNode *subNode=[self getNodeWithId:[subNodeId intValue] fromArr:dataArr];
            subNodeTotalHeight+=subNode.contentHeight;
        }
    }
    
    rootNodeTotalHeight+=(rootArr.count-1)*NODE_HEIGHT;
    if (rootNodeTotalHeight>=maxHeight)
    {
        span_rn=SPAN_MIN;
    }else{
        span_rn=(bounds.size.height-nodeCount*NODE_HEIGHT)/(nodeCount+1);
    }
    
    subNodeTotalHeight+=(subNodeCount-1)*NODE_HEIGHT;
    if (subNodeTotalHeight>=maxHeight)
    {
        span_sn=SPAN_MIN;
    }else{
        span_sn=(bounds.size.height-subNodeCount*NODE_HEIGHT)/(subNodeCount+1);
    }
    
    float currY=bounds.origin.y+span_rn;
    float subCurrY=span_sn+bounds.origin.y;
    float maxNodeWidth=0;
    for(int i=0;i<rootArr.count;i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        maxNodeWidth=maxNodeWidth>node.contentWidth?maxNodeWidth:node.contentWidth;
        maxNodeWidth+=node.subNodeIds.count*SPA_V_F;
    }
    
    for(int i=0;i<rootArr.count;i++)
    {
        YJTreeNode *node=[rootArr objectAtIndex:i];
        
        float x = currentX;
        float y = currY;
        float w = node.contentWidth;
        float h = NODE_HEIGHT;
        
        CGRect rootRect=CGRectMake(x, y, w, h);
        node.rect=rootRect;
        
        if ([self.delegate respondsToSelector:@selector(view:willDrawNode:ctx:)])
        {
            [self.delegate view:self willDrawNode:node ctx:ctx];
        }
        
        
        currY+=span_rn+node.contentHeight;
        
        CGContextSaveGState(ctx);
        [node.textColor setFill];
        [node.borderColor setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        CGPathRef rootPath=createPath(rootRect, 3);
        CGContextAddPath(ctx, rootPath);
        CGPathRelease(rootPath);
        //CGContextAddRect(ctx, rootRect);
        
        float fontHight=[node.nodeName sizeWithFont:DRAW_FONT].height;
        float f_span=(rootRect.size.height-fontHight)/2;
        CGRect f_rect=CGRectMake(rootRect.origin.x, rootRect.origin.y+f_span, rootRect.size.width, rootRect.size.height-2*f_span);
        
        [node.nodeName drawInRect:f_rect withFont:DRAW_FONT lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
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
                CGContextAddLineToPoint(ctx, cx, sy+subNode.contentHeight/2);
                CGContextAddLineToPoint(ctx, sx, sy+subNode.contentHeight/2);
            }else{
                CGContextAddLineToPoint(ctx, x+maxNodeWidth, y+h/2);
                CGContextAddCurveToPoint(ctx, x+maxNodeWidth+20, y+h/2, sx-20, sy+subNode.contentHeight/2, sx, sy+subNode.contentHeight/2);
                //CGContextAddLineToPoint(ctx, sx, sy+subNode.height/2);
                
            }
            subCurrY+=span_sn+subNode.contentHeight;
        }
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    currentX+=maxNodeWidth+self.spanBetFlo;
}
#endif

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
    //    CGContextSaveGState(ctx);
    //    [[UIColor whiteColor] setFill];
    //    CGContextFillRect(ctx,rect);
    //    CGContextRestoreGState(ctx);
    
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
        //node.selected=NO;
        if (CGRectContainsPoint(node.rect, touchPoint)&&node.enable)
        {
            YJTreeNode *lastSelectNode=[self getNodeWithId:selectNodeId fromArr:dataArr];
            lastSelectNode.selected=NO;
            
            seleNode=node;
            seleNode.selected=YES;
            
            selectNodeId=seleNode.nodeId;
            
            break;
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

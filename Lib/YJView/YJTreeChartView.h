//
//  YJTreeChartView.h
//  YJLib
//
//  Created by zhongyy on 13-12-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
/*
   version : 2013.12.06
 */
  /*
   {
        "questionId":[{"subQuestionId":[...]},{"subQuestionId":[...]},...]
   }
   
   @{@"100":@[
   @{@(getCurrentTimeSince1970()):@[@{@"4":@[@"5",@"6"]},@{@"7":@[@{@"8":@[@"9",@"10",@"11"]},@{@"12":@[@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"]},@"25"]}]},
   @{@"26":@[@"27"]}
   ]};
   */

enum  {
    kVertical   = 0,   // 垂直  暂不支持
    kHorizontal = 1    // 水平
    };
typedef NSUInteger YJTreeDir;

enum  {
    kNodeUnknow=0,
    kNodeQuestion,
    kNodeMethod
    };
typedef NSUInteger YJNodeType;

@interface YJTreeNode : NSObject
@property(nonatomic,assign)int nodeId;
@property(nonatomic,assign)int floorIndex;
@property(nonatomic,assign)CGRect rect;//位置
@property(nonatomic,assign)float contentWidth;
@property(nonatomic,assign)float contentHeight;//所占高度，跟子节点的数目有关
@property(nonatomic,copy)NSString *nodeName;
@property(nonatomic,retain)UIColor *lineColor;
@property(nonatomic,retain)UIColor *borderColor;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,retain)NSArray *subNodeIds;// id
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)BOOL enable;//是否可交互
@property(nonatomic,assign)YJNodeType type;
@property(nonatomic,copy)NSString *desc;
@end

@protocol YJTreeChartViewDelegate;

@interface YJTreeChartView : YJTouchView
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,assign)id<YJTreeChartViewDelegate>delegate;
@property(nonatomic,assign)YJTreeDir direction;// default kVertical;
@property(nonatomic,readonly)NSArray *nodeArr;
@property(nonatomic,readonly)float spanBetFlo;//每层的间距
@property(nonatomic,readonly)NSString *desc;//文本描述
-(void)reDraw;
-(void)setNodesToShow:(NSArray *)nodes;
-(void)refurbishView;
-(YJTreeNode *)getSuperNode:(YJTreeNode *)node;
-(void)addNode:(YJTreeNode*)node;
-(void)removeNode:(YJTreeNode *)node;
@end
@protocol YJTreeChartViewDelegate <NSObject>

@optional
-(void)view:(YJTreeChartView*)chartView willChangeToFrame:(CGRect)toFrame from:(CGRect)fromRect;
-(void)view:(YJTreeChartView*)chartView willDrawNode:(YJTreeNode*)node ctx:(CGContextRef)ctx;
-(void)view:(YJTreeChartView*)chartView endDrawNode:(YJTreeNode*)node ctx:(CGContextRef)ctx;
-(void)view:(YJTreeChartView *)chartView selectNode:(YJTreeNode *)node;
-(void)view:(YJTreeChartView *)chartView makeNodeToShow:(YJTreeNode *)node;
-(void)view:(YJTreeChartView *)chartView willDeleteNodes:(NSArray*)deleteNodeArr superNode:(YJTreeNode *)supNode;
@end
CGPathRef createPath(CGRect rect ,float r);

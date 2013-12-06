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
    kVertical   = 0,   // 垂直
    kHorizontal = 1    // 水平
    };
typedef NSUInteger YJTreeDir;


@interface YJTreeNode : NSObject
@property(nonatomic,assign)int nodeId;
@property(nonatomic,assign)int floorIndex;
@property(nonatomic,assign)CGRect rect;
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;
@property(nonatomic,copy)NSString *nodeName;
@property(nonatomic,retain)UIColor *lineColor;
@property(nonatomic,retain)UIColor *borderColor;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,retain)NSArray *subNodeIds;// NSString
@property(nonatomic,assign)BOOL selected;
@end

@protocol YJTreeChartViewDelegate;

@interface YJTreeChartView : YJTouchView
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,assign)id<YJTreeChartViewDelegate>delegate;
@property(nonatomic,assign)YJTreeDir direction;// default kVertical;
@property(nonatomic,readonly)NSArray *nodeArr;
@property(nonatomic,readonly)float spanBetFlo;//每层的间距
-(void)reDraw;
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
@end

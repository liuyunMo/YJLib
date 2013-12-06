//
//  TestTreeChartViewController.m
//  YJLib
//
//  Created by zhongyy on 13-12-3.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

#import "TestTreeChartViewController.h"
#import "YJTreeChartView.h"
@interface TestTreeChartViewController ()<YJTreeChartViewDelegate,UIAlertViewDelegate>
{
    YJTreeChartView *view;
    UIScrollView *sc;
    
}
@property(nonatomic,retain)YJTreeNode *selectedNode;
@end

@implementation TestTreeChartViewController

- (void)dealloc
{
    DEALLOC_PRINTF;
    [_selectedNode release];
    [super dealloc];
}
-(void)changeTreeChartType
{
    /*
    switch (view.direction) {
        case kVertical:
            view.direction=kHorizontal;
            break;
        case kHorizontal:
            view.direction=kVertical;
            break;
        default:
            break;
    }
    [view reDraw];
     */
    UIImage *image=[view getScreenShot];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    NSData *data=UIImageJPEGRepresentation(image, 1.0);
//    [data writeToFile:[DOCUMENTS_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",getCurrentTimeString()]] atomically:YES  ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"导出图片" style:UIBarButtonItemStyleBordered target:self action:@selector(changeTreeChartType)];
    self.navigationItem.rightBarButtonItem=right;
    [right release];
    

    
    sc=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44-49)];
    [self.view addSubview:sc];
    [sc release];
    
    view=[[YJTreeChartView alloc] initWithFrame:sc.bounds];
    view.delegate=self;
    view.direction=kHorizontal;
    view.data=@{@"100":@[
                        @{@(getCurrentTimeSince1970()):@[@{@"4":@[@"5",@"6"]},@{@"7":@[@{@"8":@[@"9",@"10",@"11"]},@{@"12":@[@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"]},@"25"]}]},
                        @{@"26":@[@"27"]}
                        ]};
    [view.data writeToFile:[DOCUMENTS_PATH stringByAppendingPathComponent:@"hahha.plist"] atomically:YES];
    [sc addSubview:view];
    [view release];
    
    //@"√"@"?"
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc] initWithTitle:@"增加平级" style:UIBarButtonItemStyleBordered target:self action:@selector(addPingXing)];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc] initWithTitle:@"增加下级" style:UIBarButtonItemStyleBordered target:self action:@selector(addXiaJi)];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc] initWithTitle:@"删除节点" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteNode)];
    UIBarButtonItem *item4=[[UIBarButtonItem alloc] initWithTitle:@"解决问题" style:UIBarButtonItemStyleBordered target:self action:@selector(endQueation)];
    UIBarButtonItem *item5=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editQueation)];
    
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49-44, self.view.bounds.size.width, 49)];
    toolBar.items=@[item1,item2,item3,item4,item5];
    [self.view addSubview:toolBar];
    
    [toolBar release];
    [item1 release];
    [item2 release];
    [item3 release];
    [item4 release];
}
-(void)endQueation
{
    
}

-(void)addPingXing
{
    if (self.selectedNode)
    {
        
        
        YJTreeNode *node=[[YJTreeNode alloc] init];
        node.nodeId=getCurrentTimeSince1970();
        node.nodeName=[NSString stringWithFormat:@"%f 平级",getCurrentTimeSince1970()];
        node.floorIndex=self.selectedNode.floorIndex;
        node.subNodeIds=nil;
        
        YJTreeNode *supNode=[view getSuperNode:self.selectedNode];
        NSMutableArray *arr=[NSMutableArray arrayWithArray:supNode.subNodeIds];
        [arr addObject:@(node.nodeId)];
        supNode.subNodeIds=arr;
        [view addNode:node];
        [node release];
    }else{
        SHOW_MSG(@"请选中要编辑的节点！");
    }
}

-(void)addXiaJi
{
    if (self.selectedNode)
    {
        NSMutableArray *subNode=[NSMutableArray arrayWithArray:self.selectedNode.subNodeIds];
        YJTreeNode *node=[[YJTreeNode alloc] init];
        node.nodeId=getCurrentTimeSince1970();
        node.nodeName=[NSString stringWithFormat:@"%f 增加的",getCurrentTimeSince1970()];
        node.floorIndex=self.selectedNode.floorIndex+1;
        [subNode addObject:@(node.nodeId)];
        self.selectedNode.subNodeIds=subNode;
        node.subNodeIds=nil;
        [view addNode:node];
        [node release];
    }else{
        SHOW_MSG(@"请选中要编辑的节点！");
    }
}
-(void)deleteNode
{
    if (self.selectedNode)
    {
        [view removeNode:self.selectedNode];
        self.selectedNode=NO;
    }else{
        SHOW_MSG(@"请选中要编辑的节点！");
    }
}
-(void)editQueation
{
    if (self.selectedNode)
    {
        UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle=UIAlertViewStylePlainTextInput;
        [al show];
        [al release];
    }else{
        SHOW_MSG(@"请选中要编辑的节点！");
    }
}
-(void)view:(YJTreeChartView*)chartView willChangeToFrame:(CGRect)toFrame from:(CGRect)fromRect
{
    float conHeight=MAX(sc.bounds.size.height,toFrame.size.height);
    float conWidth=MAX(sc.bounds.size.width,toFrame.size.width);
    [sc setContentSize:CGSizeMake(conWidth, conHeight)];
}
-(void)view:(YJTreeChartView*)chartView willDrawNode:(YJTreeNode*)node ctx:(CGContextRef)ctx
{
    node.borderColor=node.selected?[UIColor redColor]:[UIColor lightGrayColor];
    node.lineColor=COLOR_WITH_RGB(arc4random()%255, arc4random()%255, arc4random()%255);
}
-(void)view:(YJTreeChartView*)chartView endDrawNode:(YJTreeNode*)node ctx:(CGContextRef)ctx
{
    BOOL que=node.floorIndex%2==1;
    NSString *str=que?@"√":@"?";
    CGSize size=CGSizeMake(15, 15);
    float x=node.rect.origin.x;
    float y=node.rect.origin.y;
    CGRect rect=CGRectMake(x-size.width/2, y-size.height/2, size.width, size.height);
    CGContextSaveGState(ctx);
    !que?[[UIColor redColor] setFill]:[[UIColor blueColor] setFill];
    [[UIColor colorWithRed:0.001 green:0.438 blue:0.001 alpha:1.000] setStroke];
    CGContextSetLineWidth(ctx, .5);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] setFill];
    [str drawInRect:rect withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
    CGContextRestoreGState(ctx);
}
-(void)view:(YJTreeChartView *)chartView selectNode:(YJTreeNode *)node
{
    float cenX=node.rect.origin.x+node.rect.size.width/2;
    float cenY=node.rect.origin.y+node.rect.size.height/2;
    
    float setoffX=cenX-sc.frame.size.width/2;
    float setoffY=cenY-sc.frame.size.height/2;
    
    [sc setContentOffset:CGPointMake(setoffX, setoffY) animated:YES];
    self.selectedNode=node ;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        NSString *content=nil;
        UITextField *tf=[alertView textFieldAtIndex:0];
        content=tf.text?tf.text:@"";
        self.selectedNode.nodeName=content;
        [view refurbishView];
    }
}
@end

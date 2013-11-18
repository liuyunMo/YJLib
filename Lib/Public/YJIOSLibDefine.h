//
//  YJIOSLibDefine.h
//  TestYJFramework
//
//  Created by szfore on 13-5-21.
//  Copyright (c) 2013年 szfore. All rights reserved.
//

/*
 
 version: 2013.11.07
 
 修改内容： 
         增加网络部分的定义
         排版清晰
 */


#ifndef TestYJFramework_YJIOSLibDefine_h
#define TestYJFramework_YJIOSLibDefine_h

//i5屏幕支持
#define I5_SCREEN_SUPPORT
//取消对i5屏幕支持
//#undef  I5_SCREEN_SUPPORT

#define TAG_START 5000

#define YJDUBEG//输出dealloc
//#undef  YJDUBEG//取消输出dealloc

//提示
#define SHOW_MSG(msg)   [KEY_WINDOW performSelectorOnMainThread:@selector(showQDAlertViewWithMessage:) withObject:msg waitUntilDone:YES]
#define ALERT_MSG(msg) [KEY_WINDOW performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:msg waitUntilDone:YES]
//路径
#define DOCUMENTS_PATH     [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define LIBRARY_PATH       [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define CACHES_PATH        [LIBRARY_PATH stringByAppendingPathComponent:@"Caches"]
#define LAYOUT_PATH        [CACHES_PATH stringByAppendingPathComponent:@"Layout_szfore"]
#define IMAGE_CACHES_PATH  [CACHES_PATH stringByAppendingPathComponent:@"Image_szfore"]

//颜色
#define SAFE_COLOR(x)   ((x)>0.0f?((x)>255.0f?255.0f:(x)):0.0f)
#define COLOR_WITH_RGB(r,g,b) [UIColor colorWithRed:SAFE_COLOR(r)/255.0 green:SAFE_COLOR(g)/255.0 blue:SAFE_COLOR(b)/255.0 alpha:1]
#define COLOR_WITH_RGBA(r,g,b,a) [UIColor colorWithRed:SAFE_COLOR(r)/255.0 green:SAFE_COLOR(g)/255.0 blue:SAFE_COLOR(b)/255.0 alpha:SAFE_COLOR(a)/255.0]

//其他
#define CHECK_PAR_AND_RETURN_NULL(par) do{if(!par){printf("参数传入为空，返回null\n");return nil;}}while (0)

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define SHOW_MSG_AND_RETURN(ctx,msg) do{[ctx showAlertWithMessage:msg];return;}while(0)

#define SET_PAR(_p,p) do{[p retain];[_p release];_p=p;}while(0)

#define ERROR_LOG(c,error) do{if(error)NSLog(@"%@ line:%d error:%@",NSStringFromClass([c class]),__LINE__,error);}while(0)

//输出打印
#ifdef YJDUBEG
#define DEALLOC_PRINTF printf(("\n%s"), __PRETTY_FUNCTION__);
#else
#define DEALLOC_PRINTF 
#endif

//创建对象
#define OBJ_CREATE(aClass) (^{  \
id obj=[[aClass alloc] init];     \
return obj;                  \
})()

//此宏  只为减少编码量  只能用在cellforow代理中  复杂的cell 请用自定义cell
#define CREATE_CELL(CellClass)\
(^{\
static NSString *cellId=@"cellId";\
CellClass *cell=(CellClass *)[tableView dequeueReusableCellWithIdentifier:cellId];\
if (cell==nil) {\
cell=[[[CellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];\
}\
return cell;\
})()

typedef void (^InitCellBlock)(UITableViewCell *cell);
#define CREATE_INIT_CELL(CellClass,InitCellBlock)\
(^{\
static NSString *cellId=@"cellId";\
CellClass *cell=(CellClass *)[tableView dequeueReusableCellWithIdentifier:cellId];\
if (cell==nil) {\
cell=[[[CellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];\
InitCellBlock(cell);\
}\
return cell;\
})()

//GCD
#define DISPATCH_GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define DISPATCH_MAIN_QUEUE dispatch_get_main_queue()
#define DISPATCH_ASYNC(gBlock,mBlock) dispatch_async(DISPATCH_GLOBAL_QUEUE,^{gBlock();\
if(mBlock)dispatch_async(DISPATCH_MAIN_QUEUE,mBlock);}\
)

#define SELF_BLOCK bSelf
#define SET_SELF_BLOCK /*do{*/__block typeof(self) SELF_BLOCK=self/*;}while(0)*/

#define DISPATCH_ASYNC_WITH_SET_SELF_BLOCK(gBlock,mBlock) do{SET_SELF_BLOCK;DISPATCH_ASYNC(gBlock,mBlock);}while(0)

//释放
#define SAFE_RELEASE(p) do{if(p){[p release];p=nil;}}while(0)
#define SAFE_FREE(p)    do{if(p){free(p);p=NULL;}}while(0)
#define SAFE_BLOCK_RELEASE(block) do{if(block)Block_release(block);block=NULL;}while(0);
#define SET_BLOCK(_b,b) do{if(!b){Block_release(_b);_b=NULL;break;}if(_b)Block_release(_b); _b=Block_copy(b);}while(0)

#define CLOSE_TIMER(t) do{if(t){[t invalidate];t=nil;}}while(0);

//网络

#ifndef KEY_MSG
#warning "请定义 KEY_MSG"
#define KEY_MSG @"msg"
#endif

#ifndef KEY_STATUS
#warning "请定义 KEY_STATUS，标示网络数据请求成功的key！"
#define KEY_STATUS @"code"
#endif

#ifndef NET_DATA_OK
#warning "请定义 NET_DATA_OK，用以标示网络数据请求成功！"
#define NET_DATA_OK 1
#endif

#ifndef POINT_NO_DATA
#warning "请定义 POINT_NO_DATA，用以提示没有获得网络数据！"
#define POINT_NO_DATA         @"未请求到数据，请重试！"
#endif

#ifndef POINT_NO_NET
#warning "请定义 POINT_NO_NET，用以提示没有获得网络访问权限！"
#define POINT_NO_NET          @"没有网络访问权限"
#endif

#define SHOW_NO_DATA       SHOW_MSG(POINT_NO_DATA)
#define SHOW_NO_NET        SHOW_MSG(POINT_NO_NET)


#define CHECK_DATA(dict) ^{\
if (!dict) {\
SHOW_NO_DATA;\
return NO;\
}\
if (![[dict objectForKey:KEY_STATUS] intValue]==NET_DATA_OK) {\
SHOW_MSG([dict objectForKey:KEY_MSG]);\
return NO;\
}\
return YES;\
}();

#define CHECK_NET_RESULT _check_net_result
#define CHECK_NET_DICT(dict) do{\
int CHECK_NET_RESULT= CHECK_DATA(dict)  \
}while(0)



//block
//typedef void (^backBlock)(id context,NSDictionary *userInfo);
typedef void(^YJResBlock)(id ctx,id result);
typedef YJResBlock backBlock;//兼容以前～～
//other
typedef unsigned char YJStatus;
#define YJStatusOK    1
#define YJStatusFail  0

enum YJErrorCode {
    //network  680**
    kYJErrorNoNetworkExist = 68001,//网络不存在或用户限制了网络请求
    
    //json     681**
    kYJErrorInvalidJSONObject =68101,//不能转换为json串的对象
    kYJErrorJsonStringToData  =68102,//
    
    //JExam     682**
    kYJExamErrorNoPre = 68201,//已经是第一题
    kYJExamErrorNoNext,//已经是最后一题
    kYJExamErrorBeyond//题目索引越界
    };

typedef enum YJErrorCode YJExamErrorCode;



enum  {
    kEntironmentIPhone4 = 0,
    kEntironmentIPhone5,
    // kEntironmentIPad
};
typedef NSUInteger YJEntironment;

//touch  
enum
{
    kTouchEventCancel=0,
    kTouchEventBegan,
    kTouchEventMoved,
    kTouchEventEnded
};
typedef NSInteger YJTouchEvent;
#endif

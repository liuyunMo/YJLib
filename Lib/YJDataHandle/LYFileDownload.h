/* 文件下载  需要优化 */

#import <Foundation/Foundation.h>
@protocol LYFileDownloadDelegate;
@interface LYFileDownload : NSObject
//下载资源路径
@property(nonatomic,retain)NSString *resourcePath;
//本地存储路径
@property(nonatomic,retain)NSString *localPath;
//当前已下载文件大小
@property(nonatomic,assign)unsigned long long currentSize;
//需要下载的文件大小（可能会返回错误）
@property(nonatomic,assign)unsigned long long totalSize;
//类标识
@property(nonatomic,retain) NSString *downloadFlagStr;
@property(nonatomic,assign) int flag;
@property(nonatomic,readonly)BOOL downloading;
//设置超时 默认为5s  
@property(nonatomic,assign) NSTimeInterval timeOut;
//代理
@property(nonatomic,assign) id<LYFileDownloadDelegate> delegate;
//初始化方法   init返回为空
-(id)initWithResourcePath:(NSString *)rePath andSavePath:(NSString*)savePath start:(BOOL)start;
//开始下载
-(void)startDownloadFile;
//取消下载
-(void)cancelDownloadFile;
//删除已下载的文件
-(BOOL)deleteLocalFile:(NSError **)error;
@end
@protocol LYFileDownloadDelegate <NSObject>
@optional
//下载完成
-(void)fileDownloadFinished:(LYFileDownload *)fileDownLoad;
//下载失败
-(void)fileDownloadDidFail:(LYFileDownload *)fileDownLoad withError:(NSError *)error;
//更新数据
-(void)fileDownloadUpdateData:(LYFileDownload *)fileDownLoad currentSize:(unsigned long long)size;
//获取到文件大小
-(void)fileDownloadGetTolalSize:(unsigned long long)size fileDownload:(LYFileDownload *)fileDownLoad;
@end
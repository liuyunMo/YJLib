

#import "LYFileDownload.h"
#define TIME_OUT 30
@interface LYFileDownload()<NSURLConnectionDataDelegate>
{
    
    NSMutableURLRequest *request;
    BOOL fileExists;
}
@property(nonatomic,retain)NSURLConnection *URLConnection;
@property(nonatomic,retain)NSFileHandle *fileHandle;
@end
@implementation LYFileDownload
@synthesize resourcePath=_resourcePath;
@synthesize localPath=_localPath;
@synthesize currentSize=_currentSize;
@synthesize totalSize=_totalSize;
@synthesize downloadFlagStr=_downloadFlagStr;
@synthesize delegate=_delegate;
@synthesize timeOut=_timeOut;
@synthesize URLConnection=_URLConnection;
@synthesize flag=_flag;

-(void)startDownloadFile
{
    if (_downloading)
    {
        return;
    }
    NSLog(@"开始下载");
    _downloading=YES;
    if (_timeOut<=0.0)
    {
        _timeOut=TIME_OUT;
    }
    _currentSize=0;
    if (!request)
    {
        request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self.resourcePath stringByAddingPercentEscapesUsingEncoding:4]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT];
    }
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.localPath])
    {
        fileExists=YES;
        self.fileHandle=[NSFileHandle fileHandleForWritingAtPath:self.localPath];
        NSDictionary *fileDict=[manager attributesOfItemAtPath:self.localPath error:nil];
        unsigned long long fileSize=[fileDict fileSize];
        NSString *range = [[NSString alloc] initWithFormat:@"bytes=%lld-",fileSize];
        [request addValue:range forHTTPHeaderField:@"range"];
        [range release];
        _currentSize+=fileSize;
        [self.fileHandle seekToEndOfFile];
    }else {
        [manager createFileAtPath:self.localPath contents:nil attributes:nil];
        self.fileHandle=[NSFileHandle fileHandleForWritingAtPath:self.localPath];
        fileExists=NO;
    }
    if (self.URLConnection)
    {
        [self.URLConnection cancel];
        self.URLConnection=nil;
    }
    self.URLConnection=[NSURLConnection connectionWithRequest:request delegate:self];
    [self.URLConnection start];
}
-(id)initWithResourcePath:(NSString *)rePath andSavePath:(NSString*)savePath start:(BOOL)start
{
    if (self=[super init])
    {
        self.resourcePath=rePath;
        self.localPath=savePath;
        if (start)
        {
            [self startDownloadFile];
        }
    }
    return self;
}
-(id)init
{
    return nil;
}
-(void)cancelDownloadFile
{
    if (_downloading)
    {
        _downloading=NO;
        [self.URLConnection cancel];
        self.URLConnection=nil;
        [self.fileHandle closeFile];
    }
}
-(BOOL)deleteLocalFile:(NSError **)error
{
    [self cancelDownloadFile];
    return [[NSFileManager defaultManager] removeItemAtPath:self.localPath error:error];
}
-(void)dealloc
{
    DEALLOC_PRINTF;
    [_downloadFlagStr release];
    [request release];
    [_fileHandle release];
    [_URLConnection release];
    [_resourcePath release];
    [_localPath release];
    [super dealloc];
}
#pragma mark--- NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_delegate&&[_delegate respondsToSelector:@selector(fileDownloadDidFail:withError:)])
    {
        [_delegate fileDownloadDidFail:self withError:error];
    }
    [self cancelDownloadFile];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSUInteger statusCode=[(NSHTTPURLResponse *)response statusCode];
    if (statusCode==200||(fileExists&&statusCode==206)||(fileExists&&statusCode==416))
    {
        _downloading=YES;
        _totalSize=[response expectedContentLength]+self.currentSize;
        if (_delegate&&[_delegate respondsToSelector:@selector(fileDownloadGetTolalSize:fileDownload:)])
        {
            [_delegate fileDownloadGetTolalSize:self.totalSize fileDownload:self];
        }
    }else {
        NSError *error=[[NSError alloc] initWithDomain:@"资源错误！" code:statusCode userInfo:nil];
        if (_delegate&&[_delegate respondsToSelector:@selector(fileDownloadDidFail:withError:)])
        {
            [_delegate fileDownloadDidFail:self withError:error];
        }
        [error release];
        [self cancelDownloadFile];
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _currentSize+=data.length;
    if (_delegate&&[_delegate respondsToSelector:@selector(fileDownloadUpdateData:currentSize:)])
    {
        [_delegate fileDownloadUpdateData:self currentSize:self.currentSize];
    }
    if(_downloading)
    {
        [self.fileHandle writeData:data];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_delegate&&[_delegate respondsToSelector:@selector(fileDownloadFinished:)]) 
    {
        [_delegate fileDownloadFinished:self];
    }
    [self cancelDownloadFile];
}
@end

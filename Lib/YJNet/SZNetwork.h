
/*
 传输数据使用json
 
 */
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "YJFlagView.h"
#define SZTMP_VIEW_FLAG @"___YJNETWORK_TMP_VIEW_FLAG____"
enum {
	kNotReachable = 0, 
	kReachableViaWWAN,
	kReachableViaWiFi
};
typedef	uint32_t NetworkStatus;
@interface SZNetwork : NSObject
+(BOOL)networkExist;
+(NSString *)getIPStr:(NSString* (^)(void))block;
+(NetworkStatus)currentNetworkType;
+(id)postDataWithURL:(NSURL *)url data:(NSData *)data;
+(id)postDataWithURL:(NSURL *)url data:(NSData *)data error:(void (^)(NSError *error))error;
+(id)uploadImageWithURL:(NSURL *)url image:(NSArray *)images params:(NSDictionary*)params;
@end
@interface UIView (SZNetwork)
-(void)addNetTmpView;
-(void)removeNetTmpView;
@end
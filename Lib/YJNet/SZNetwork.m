//
//  SZNetworkCheck.m
//  SZFastStudy
//
//  Created by admin123456 on 13-1-15.
//  Copyright (c) 2013年 admin123456. All rights reserved.
//

#import "SZNetwork.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
@implementation SZNetwork
+(BOOL)networkExist
{
    return [self currentNetworkType]!=kNotReachable;
}
+(NetworkStatus)currentNetworkType
{
    struct ifaddrs * first_ifaddr, * current_ifaddr;
    NSMutableArray* activeInterfaceNames = [NSMutableArray array];
    getifaddrs( &first_ifaddr );
    current_ifaddr = first_ifaddr;
    while( current_ifaddr!=NULL )
    {
        if( current_ifaddr->ifa_addr->sa_family == AF_INET )
        {
            [activeInterfaceNames addObject:[NSString stringWithUTF8String:current_ifaddr->ifa_name]];
        }
        current_ifaddr = current_ifaddr->ifa_next;
    }
    
    if([activeInterfaceNames containsObject:@"en0"]||[activeInterfaceNames containsObject:@"en1"])return kReachableViaWiFi;
    if([activeInterfaceNames containsObject:@"pdp_ip0"])return kReachableViaWWAN;
    return kNotReachable;
}
+(id)postDataWithURL:(NSURL *)url data:(NSData *)data
{
    return [self postDataWithURL:url data:data error:NULL];
}
+(id)postDataWithURL:(NSURL *)url data:(NSData*)data error:(void (^)(NSError *error))error
{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    if (data)
    {
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
    }else{
        [request setHTTPMethod:@"GET"];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSHTTPURLResponse *response=nil;
    NSError *error_net=nil;
    NSData   *dataNet = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response error:&error_net];
    [request release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(error)  error(error_net);
    if (!dataNet)
    {
        return nil;
    }
    else
    {
//        NSString *json=[[NSString alloc] initWithData:dataNet encoding:4];
//        NSLog(@"%@",json);
//        [json release];
        return [NSJSONSerialization JSONObjectWithData:dataNet options:NSJSONReadingMutableContainers error:nil];
    }
}
+(NSString *)getIPStr:(NSString* (^)(void))block
{
    NSMutableString *ipStr=[[NSMutableString alloc]init];
    NSString *ip=[YJPublic getSettingsBundleValueForTitile:@"IP"];
    if (ip) [ipStr appendString:ip];
    if (block!=NULL)
    {
        [ipStr appendString:block()];
    }
    return [ipStr autorelease];
}
+(id)uploadImageWithURL:(NSURL *)url image:(NSArray *)images params:(NSDictionary*)params
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    NSString *MPboundary=[NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    NSString *endMPboundary=[NSString stringWithFormat:@"%@--",MPboundary];
    
    NSMutableString *body=[NSMutableString string];
    for (NSString *key in params.allKeys)
    {
        [body appendFormat:@"%@\r\n",MPboundary];
        
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    [body appendFormat:@"%@\r\n",MPboundary];
    
    NSMutableData *data=[NSMutableData data];
    

    for (int i=0; i<images.count; i++)
    {
        NSMutableString *sst=[NSMutableString string];
        
        [sst appendFormat:@"Content-Disposition: form-data; name=\"imgName_%d\"; filename=\"imgName_%d.png\"\r\n",i+1,i+1];
        [sst appendFormat:@"Content-Type: image/png\r\n\r\n"];
        NSLog(@"%@",sst);
        NSData* subData =UIImagePNGRepresentation([images objectAtIndex:i]);
        [data appendData:[sst dataUsingEncoding:4]];
        [data appendData:subData];
        [data appendData:[[NSString stringWithFormat:@"\r\n%@\r\n",MPboundary] dataUsingEncoding:4]];
    }
    
    
    
    NSString *end=[NSString stringWithFormat:@"\r\n%@",endMPboundary];
    NSMutableData *myRequestData=[NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
    
    NSData *dataNet = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:nil error:nil];
    NSString *str=[[[NSString alloc] initWithData:dataNet encoding:4] autorelease];
    return [LYJsonCode objectFromJsonString:str error:NULL];
}
@end
@implementation UIView (SZNetwork)
-(void)addNetTmpView
{
    YJFlagView *tmpView=[self getYJFlagViewWithFlag:SZTMP_VIEW_FLAG];
    if (!tmpView)
    {
        tmpView=[[YJFlagView alloc] initWithFrame:self.bounds];
        tmpView.flagStr=SZTMP_VIEW_FLAG;
        UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [ac startAnimating];
        ac.color=[UIColor greenColor];
        ac.center=tmpView.center;
        [tmpView addSubview:ac];
        [self addSubview:tmpView];
        [ac release];
        [tmpView release];
        [self bringSubviewToFront:tmpView];
    }
}
-(void)removeNetTmpView
{
    YJFlagView *tmpView=[self getYJFlagViewWithFlag:SZTMP_VIEW_FLAG];
    if (tmpView)[tmpView removeFromSuperview];
}
@end

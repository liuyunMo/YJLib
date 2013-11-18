#define YJ_DEBUG 1//测试中。。。

#import "LYJsonCode.h"
#import <objc/runtime.h>
@implementation LYJsonCode
+(NSString *)jsonCodeWithObject:(id)object error:(NSError **)error;
{
    CHECK_PAR_AND_RETURN_NULL(object);
    if (![NSJSONSerialization isValidJSONObject:object]) {
        if(error)*error=[NSError errorWithDomain:@"传入参数不能转换为json数据！" code:kYJErrorInvalidJSONObject userInfo:nil];
        return nil;
    }
    NSString *jsonStr=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:error];
    jsonStr=[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    
    if(error)ERROR_LOG(self, *error);
    return jsonStr;
}
+(id)objectFromJsonString:(NSString *)jsonStr error:(NSError **)error
{
    CHECK_PAR_AND_RETURN_NULL(jsonStr);
    id object=nil;
    NSData *data=[jsonStr dataUsingEncoding:4];
    if (data)
    {
        object= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
    }else{
        if(error)*error =[NSError errorWithDomain:@"jsonString to Data error" code:kYJErrorJsonStringToData userInfo:nil];
    }
    if (error) ERROR_LOG(self, *error);
    return object;
}
+(NSString *)jsonCodeWithCustomObject:(NSObject *)object
{
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([object class],&outCount);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *name=property_getName(property);
        NSString *nameStr=[NSString stringWithCString:name encoding:4];
        id value=[object valueForKey:nameStr];
        if (value==nil)
        {
            value=[NSNull null];
        }
        [dict setObject:value forKey:nameStr];
    }
    NSString *json=[self jsonCodeWithDictionary:dict];
    [dict release];
    return json;
}
+(id)deepCopy:(id<NSCoding>)object
{
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:object];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
+(NSString *)jsonCodeWithArray:(NSArray*)array
{
    if (YJ_DEBUG) {
        NSError *error=nil;
        return [self jsonCodeWithObject:array error:&error];
    }
    CHECK_PAR_AND_RETURN_NULL(array);
    
    NSMutableString *mutableStr=[NSMutableString string];
    for (int i=0;i<[array count];i++)
    {
        id value=[array objectAtIndex:i];
        if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *arr=[self deepCopy:value];
            NSString *arrayStr=[self jsonCodeWithArray:(NSArray *)arr];
            [mutableStr appendFormat:@"%@,",arrayStr];
        }
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict=[self deepCopy:value];
            NSString *dictStr=[self jsonCodeWithDictionary:dict];
            [mutableStr appendFormat:@"%@,",dictStr];
        }
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *strValue=[self deepCopy:value];
            NSMutableString *subStr=[NSMutableString string];
            [subStr appendString:strValue];
            [subStr replaceOccurrencesOfString:@"\"" withString:@"\\\""  options:NSLiteralSearch range:NSMakeRange(0, subStr.length)];
            [subStr replaceOccurrencesOfString:@"\\" withString:@"\\\\"  options:NSLiteralSearch range:NSMakeRange(0, subStr.length)];
            [subStr insertString:@"\"" atIndex:0];
            [subStr insertString:@"\"," atIndex:[subStr length]];
            [mutableStr appendString:subStr];
        }
        if ([value isKindOfClass:[NSNumber class]])
        {
            NSString *strValue=[NSString stringWithFormat:@"%@",[self deepCopy:value]];
            NSMutableString *subStr=[NSMutableString string];
            [subStr appendString:strValue];
            [subStr replaceOccurrencesOfString:@"\"" withString:@"\\\""  options:NSLiteralSearch range:NSMakeRange(0, subStr.length)];
            [subStr replaceOccurrencesOfString:@"\\" withString:@"\\\\"  options:NSLiteralSearch range:NSMakeRange(0, subStr.length)];
            [subStr insertString:@"\"" atIndex:0];
            [subStr insertString:@"\"," atIndex:[subStr length]];
            [mutableStr appendString:subStr];
        }
    }
    [mutableStr insertString:@"[" atIndex:0];
    if (mutableStr.length>1)
    {
        [mutableStr deleteCharactersInRange:NSMakeRange([mutableStr length]-1, 1)];
    }
    [mutableStr insertString:@"]" atIndex:[mutableStr length]];
    return mutableStr;
}
+(NSString *)jsonCodeWithDictionary:(NSDictionary *)dataDict
{
    if (YJ_DEBUG) {
        NSError *error=nil;
        return [self jsonCodeWithObject:dataDict error:&error];
    }
    
    CHECK_PAR_AND_RETURN_NULL(dataDict);
    
    NSArray *arr=[dataDict allKeys];
    NSMutableString *str=[NSMutableString new];
    for (int i=0;i<[arr count];i++)
    {
        NSString *key=[arr objectAtIndex:i];
        NSMutableString *mutableKey=[NSMutableString string];
        [mutableKey appendString:key];
        [mutableKey insertString:@"\"" atIndex:0];
        [mutableKey insertString:@"\"" atIndex:[mutableKey length]];
        id mutableValue=[dataDict objectForKey:key];
        if ([mutableValue isKindOfClass:[NSArray class]])
        {
            NSString *arrayStr=[self jsonCodeWithArray:(NSArray *)mutableValue];
            [str appendFormat:@"%@:%@",mutableKey,arrayStr];
        }
        if ([mutableValue isKindOfClass:[NSDictionary class]])
        {
            NSString *dictStr=[self jsonCodeWithDictionary:(NSDictionary *)mutableValue];
            [str appendFormat:@"%@:%@",mutableKey,dictStr];
        }
        if ([mutableValue isKindOfClass:[NSString class]])
        {
            NSMutableString *mutableString=[NSMutableString stringWithString:mutableValue];
            [mutableString replaceOccurrencesOfString:@"\"" withString:@"\\\""  options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
            [mutableString replaceOccurrencesOfString:@"\\" withString:@"\\\\"  options:NSLiteralSearch range:NSMakeRange(0, mutableString.length)];
            [mutableString insertString:@"\"" atIndex:0];
            [mutableString insertString:@"\"" atIndex:[mutableString length]];
            [str appendFormat:@"%@:%@",mutableKey,mutableString];
        }
        if ([mutableValue isKindOfClass:[NSNumber class]]) 
        {
            NSMutableString *mutableString=[NSMutableString stringWithFormat:@"%@",[self deepCopy:mutableValue]];
            [mutableString insertString:@"\"" atIndex:0];
            [mutableString insertString:@"\"" atIndex:[mutableString length]];
            [str appendFormat:@"%@:%@",mutableKey,mutableString];
        }
        if (i==[arr count]-1)
        {
            break;
        }
        [str appendString:@","];
    }
    [str insertString:@"{" atIndex:0];
    [str insertString:@"}" atIndex:[str length]];
    return [str autorelease];
}
@end

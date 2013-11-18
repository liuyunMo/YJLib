

@interface LYJsonCode : NSObject
+(id)deepCopy:(id<NSCoding>)object;
//有问题～～～ 
+(NSString *)jsonCodeWithArray:(NSArray*)array;
+(NSString *)jsonCodeWithDictionary:(NSDictionary *)dataDict;
+(NSString *)jsonCodeWithCustomObject:(NSObject *)object;

//替代 (ios5.0 )
+(NSString *)jsonCodeWithObject:(id)object error:(NSError **)error;
+(id)objectFromJsonString:(NSString *)jsonStr error:(NSError **)error;
@end

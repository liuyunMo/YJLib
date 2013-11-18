//defines

//YJImageManager

//file name
#define IMAGE_NAME_INFO_FILE_NAME @"image"
//status define
#define IMAGE_STATUS_DEFAULT @"default"
#define IMAGE_STATUS_MOVING @"moving"
#define IMAGE_STATUS_SELECTED @"selected"
//entironment define
#define IMAGE_ENTIRONMENT_IPHONE4 @"i4"
#define IMAGE_ENTIRONMENT_IPHONE5 @"i5"

#import "YJImageManager.h"
@implementation YJImageManager
+(UIImage *)loadFpgImageFile:(NSString*)name
{
    //从appBundle加载
    //从本地加载
    return nil;
}
+(UIImage *)getLocalImageWithName:(NSString *)name
{
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Image_yj/%@",name]];
    UIImage *image=[UIImage imageWithContentsOfFile:path];
    if (!image)
    {
        NSString *errorStr=[NSString stringWithFormat:@"加载%@图片资源失败！",name];
        ERROR_LOG(self, errorStr);
    }
    return image;
}
+(NSDictionary *)getImageNameDict
{
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IMAGE_NAME_INFO_FILE_NAME ofType:@"plist"]];
    //if (!dict) NSLog(@"找不到%@.plist文件!",IMAGE_NAME_INFO_FILE_NAME);
    return dict;
}
+(UIImage *)getImageWithName:(NSString *)name stayUp:(BOOL)stayUp
{
    do {
        NSArray *fileNameArr=[name componentsSeparatedByString:@"."];
        if (fileNameArr.count<2)
        {
            NSLog(@"YJImageManager %@ 格式错误",self);
            return nil;
        }
        if ([@"fpg" isEqualToString:[fileNameArr lastObject]])
        {
            return [self loadFpgImageFile:name];
        }
        
        UIImage *image=nil;
        if (stayUp)
        {
            image=[UIImage imageNamed:name];
        }else{
            image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[fileNameArr objectAtIndex:0] ofType:[fileNameArr lastObject]]];
        }
        if (!image) break;
        return image;
    } while (0);
    
    //NSLog(@"appBundle找不到名称为%@的图片资源文件，尝试加载本地Documents/Image_yj文件夹下资源文件",name);
    return [self getLocalImageWithName:name];
}
+(NSString *)getNameWithKeyString:(NSString *)keyString
{
    NSString *imageName=[[self getImageNameDict] objectForKey:keyString];
    if (!imageName)
    {
        //NSLog(@"找不到%@对应的的内容....故选择以关键字%@.png匹配",keyString,keyString);
        return [NSString stringWithFormat:@"%@.png",keyString];
    }
    return imageName;
}
+(UIImage *)getImageWithKeyString:(NSString *)keyString
{
    return [self getImageWithName:[self getNameWithKeyString:keyString] stayUp:NO];
}
+(UIImage *)getImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status
{
    NSString *name=[self getNameWithKeyString:keyString];
    name=[name nameWithStatus:status];
    return [self getImageWithName:name stayUp:NO];
}
+(UIImage *)getImageWithKeyString:(NSString *)keyString entironment:(YJEntironment)entironment
{
    NSString *name=[self getNameWithKeyString:keyString];
    name=[name nameWithEntironment:entironment];
    return [self getImageWithName:name stayUp:NO];
}
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString
{
    return [self getImageWithName:[self getNameWithKeyString:keyString] stayUp:YES];
}
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status
{
    NSString *name=[self getNameWithKeyString:keyString];
    name=[name nameWithStatus:status];
    return [self getImageWithName:name stayUp:YES];
}
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString entironment:(YJEntironment)entironment
{
    NSString *name=[self getNameWithKeyString:keyString];
    name=[name nameWithEntironment:entironment];
    return [self getImageWithName:name stayUp:YES];
}
+(UIImage *)getImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status entironment:(YJEntironment)entironment stayUp:(BOOL)stayUp
{
    NSString *name=[self getNameWithKeyString:keyString];
    name=[name nameWithStatus:status];
    name=[name nameWithEntironment:entironment];
    return [self getImageWithName:name stayUp:stayUp];
}
@end
@implementation NSString (YJImageManager)
-(NSString *)nameWithStatus:(YJImageStatus)status
{
    NSArray *fileNameArr=[self componentsSeparatedByString:@"."];
    if (fileNameArr.count<2)
    {
        NSLog(@"YJImageManager %@ 格式错误",self);
        return nil;
    }
    NSString *statusStr=IMAGE_STATUS_DEFAULT;
    switch (status) {
        case kYJImageStatusMoving:
            statusStr=IMAGE_STATUS_MOVING;
            break;
        case kYJImageStatusSelected:
            statusStr=IMAGE_STATUS_SELECTED;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@_%@.%@",[fileNameArr objectAtIndex:0],statusStr,[fileNameArr lastObject]];
}
-(NSString *)nameWithEntironment:(YJEntironment)entironment
{
    NSArray *fileNameArr=[self componentsSeparatedByString:@"."];
    if (fileNameArr.count<2)
    {
        NSLog(@"YJImageManager %@ 格式错误",self);
        return nil;
    }
    NSString *entironmentStr=IMAGE_ENTIRONMENT_IPHONE4;
    switch (entironment)
    {
        case kEntironmentIPhone5:
            entironmentStr=IMAGE_ENTIRONMENT_IPHONE5;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@@%@.%@",[fileNameArr objectAtIndex:0],entironmentStr,[fileNameArr lastObject]];
}
@end
@implementation YJImageManager (YJPublic)
+(UIImage *)getCurrentEntironmentImageWithKeyString:(NSString*)keyString
{
    return [self getImageWithKeyString:keyString entironment:[YJPublic currentEntironment]];
}
+(UIImage *)getCurrentEntironmentImageWithKeyString:(NSString*)keyString status:(YJImageStatus)status
{
    return [self getImageWithKeyString:keyString status:status entironment:[YJPublic currentEntironment] stayUp:NO];
}
@end
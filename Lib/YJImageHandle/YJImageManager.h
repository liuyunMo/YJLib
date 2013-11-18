
/*
 文件名称为image.plist
 图片名称各个标示之间_相连
 环境标示用@相连
 
 状态为：default,moving,selected
 
 环境标示为i4,i5；
 
 定义如下：
 
 
 //file name
 #define IMAGE_NAME_INFO_FILE_NAME @"image"
 //status define
 #define IMAGE_STATUS_DEFAULT @"default"
 #define IMAGE_STATUS_MOVING @"moving"
 #define IMAGE_STATUS_SELECTED @"selected"
 //entironment define
 #define IMAGE_ENTIRONMENT_IPHONE4 @"i4"
 #define IMAGE_ENTIRONMENT_IPHONE5 @"i5"
 

 图片名称格式为  name_status@ent.png 对应键值编码  key:name;
 
 示例：   login_default@i4.png ｜login@i4.png ｜login.png      对应键值编码  key:login;
 
 */

#import "YJPublic.h"
#import "YJIOSLibDefine.h"
enum {
    kYJImageStatusDefault = 0,
    kYJImageStatusMoving,
    kYJImageStatusSelected
    };
typedef __uint32_t YJImageStatus;
@interface YJImageManager : NSObject
+(NSDictionary *)getImageNameDict;
+(UIImage *)getImageWithName:(NSString *)name stayUp:(BOOL)stayUp;
+(NSString *)getNameWithKeyString:(NSString *)keyString;

//[UIImage imageWithContentsOfFile:path]
+(UIImage *)getImageWithKeyString:(NSString *)keyString;
+(UIImage *)getImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status;
+(UIImage *)getImageWithKeyString:(NSString *)keyString entironment:(YJEntironment)entironment;
//内存不释放的图片  [UIImage imageNamed:name]
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString;
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status;
+(UIImage *)getStayUpImageWithKeyString:(NSString *)keyString entironment:(YJEntironment)entironment;

//
+(UIImage *)getImageWithKeyString:(NSString *)keyString status:(YJImageStatus)status entironment:(YJEntironment)entironment stayUp:(BOOL)stayUp;
@end

@interface NSString (YJImageManager)
-(NSString *)nameWithStatus:(YJImageStatus)status;
-(NSString *)nameWithEntironment:(YJEntironment)entironment;
@end
@interface YJImageManager (YJPublic)
+(UIImage *)getCurrentEntironmentImageWithKeyString:(NSString*)keyString;
+(UIImage *)getCurrentEntironmentImageWithKeyString:(NSString*)keyString status:(YJImageStatus)status;
@end

/************************/
// 数据为题目的数组  数组元素是YJQuestion对象
//
//
//
//


#import <Foundation/Foundation.h>
#import "YJQuestion.h"
#import "YJTestDefine.h"
@interface YJQuestionHandle : NSObject
@property(nonatomic,readonly)int questionCount;
@property(nonatomic,readonly)NSArray *questionIdArray;
//YJQuestion
-(id)initWithQuestionArray:(NSArray *)questionArray;
-(int)getQuestionIdWithIndex:(int)index;
-(YJQuestion *)getQuestionWithIndex:(int)index;
-(YJQuestion *)getQuestionWithQuestionId:(int)questionId;
-(NSArray *)getAnswerWithQuestionId:(int)questionId;
-(NSArray *)getAnswerWithIndex:(int)index;
@end

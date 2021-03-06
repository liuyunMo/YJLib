//
//  YJSearchView.h
//  TestYJFramework
//
//  Created by szfore on 13-5-27.
//  Copyright (c) 2013年 szfore. All rights reserved.
//
#import "YJChar.h"
#import "YJTouchView.h"
@protocol YJSearchViewDelegate;
@interface YJSearchResult : NSObject
@property(nonatomic,assign)NSRange range;
//YJChar
@property(nonatomic,retain)NSArray *charStrArr;
@property(nonatomic,readonly)NSString *keyword;
@end
@interface NSMutableArray (YJSearchResult)
-(void)sortWithLocation;
@end
@interface YJSearchView : YJTouchView
@property(nonatomic,assign)float contentWidth;
@property(nonatomic,copy)NSArray *keywords;
@property(nonatomic,copy)NSString *contentString;
@property(nonatomic,readonly)NSMutableArray *searchResultArr;
@property(nonatomic,assign)float x_span;
@property(nonatomic,assign)id<YJSearchViewDelegate> delegate;
//color
@property(nonatomic,retain)UIColor *defaultTextColor;
@property(nonatomic,retain)UIColor *selectedTextColor;
@property(nonatomic,retain)UIColor *currentSelectTextColor;
@property(nonatomic,retain)UIFont *font;

-(id)initWithString:(NSString *)string frame:(CGRect)frame;
//YJSeachResult
-(NSMutableArray *)seachForString:(NSString *)string;
-(YJChar *)getCharStrWithIndex:(int)index;
-(YJSearchResult *)gotoNextSearchResult;
-(YJSearchResult *)gotoPreviousSearchResult;
-(void)reloadData;
-(void)reloadDataInRect:(CGRect)rect;
@end
@protocol YJSearchViewDelegate <NSObject>
@optional
-(void)frameChangedToRect:(CGRect)toRect searchView:(YJSearchView *)searchView;
-(void)tapCharString:(YJChar *)charStr inSearchVeiw:(YJSearchView *)searchView keyword:(NSString *)keyword keywordIndex:(int)index;
@end

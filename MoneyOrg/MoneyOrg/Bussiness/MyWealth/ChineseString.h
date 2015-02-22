//
//  ChineseString.h
//  YZX_ChineseSorting
//
//  Created by Suilongkeji on 13-10-29.
//  Copyright (c) 2013年 Suilongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property (nonatomic,strong)NSDictionary * dic;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)dicArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortDic:(NSArray*)dicArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)dicArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

@end
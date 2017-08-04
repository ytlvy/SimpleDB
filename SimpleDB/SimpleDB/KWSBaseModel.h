//
//  KWSBaseModel.h
//  KWSing
//
//  Created by gyj on 16/6/22.
//  Copyright © 2016年 kuwo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSBaseInfo.h"

@protocol KWSBaseModelDelegate <NSObject>

@optional
- (void)parseValue:(id)data property:(NSString *)property;

@end

@interface KWSBaseModel : KWSBaseInfo<KWSBaseModelDelegate>

/**
 *  属性和数据库字段对应关系
 *
 *  @return 字典对应 key 为属性 val 为数据库字段
 */
+ (NSDictionary *)fmPropertyMap;

/**
 *  属性和数据库字段一致, 用于新model创建
 */
+ (NSArray *)fmPropertyArray;

/**
 *  数据库更新 条件数组
 *
 *
 @return 条件数组
 */
+ (NSArray *)fmConditions;

+ (NSArray *)fmPrimaryKeys;

+ (NSString *)fmSortString;


- (NSDictionary *)fmColumnMap;

- (void)pure_customInit:(NSDictionary *)dic;

- (NSDictionary *)toDictionary;


@end

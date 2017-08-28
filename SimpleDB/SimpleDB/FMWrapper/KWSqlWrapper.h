//
//  KWSqlWrapper.h
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KWSqlType){

    KWSqlType_None = 0,
    KWSqlType_ColumTotal,
    KWSqlType_SelectInt,
    KWSqlType_SelectOne,
    KWSqlType_SelectRow,
    KWSqlType_SelectArray,
    KWSqlType_Total,
    KWSqlType_Insert,
    KWSqlType_InsertArray,
    KWSqlType_Update,
    KWSqlType_Create,
    KWSqlType_Delete,
    KWSqlType_AddColum
};

@interface KWSqlWrapper : NSObject

@property (nonatomic, assign) KWSqlType sqlType;

@property (nonatomic, copy)   NSString *table;
@property (nonatomic, assign) BOOL distinct;


@property (nonatomic, strong) NSArray *colums;
@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, strong) NSDictionary *columAndTypes;


/**
 字段和对应的数值
 */
@property (nonatomic, strong) NSDictionary *columAndvalues;

/**
 条件列表 字典
 */
@property (nonatomic, strong) NSDictionary *conditions;

@property (nonatomic, strong) NSDictionary *whereIn;

/**
 排序
 */
@property (nonatomic, strong) NSString *sort;

/**
 主键
 */
@property (nonatomic, strong) NSArray *primaryKeys;

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;

/**
 表格对应的 objc 类, 用于创建表
 */
@property (nonatomic, strong) Class clazz;


/**
  用于执行 sql 的参数数值字典
 */
@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) NSMutableArray *paramArray;


/**
 批量逆向插入
 */
@property (nonatomic, assign) BOOL reverse;


- (NSString *)composite;
- (void)reset;
+ (NSString *)conditionStr:(NSArray *)conditions;

@end

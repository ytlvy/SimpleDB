//
//  KWDBManagerPrivate.h
//  KWUtility
//
//  Created by gyj on 2017/6/29.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#ifndef KWSimpleDBManagerPrivate_h
#define KWSimpleDBManagerPrivate_h
#import "KWFMWrapper.h"

@class FMResultSet;


@protocol KWBaseModelProtocal <NSObject>

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

@end

@interface KWSimpleDBManager()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) id   propertyClazz;
@property (nonatomic, strong) NSString *tableIdentifier;
@property (nonatomic, assign) NSInteger currentVersion;
@property (nonatomic, strong) KWFMWrapper *dbWrapper;



- (NSString *)insertSqlWithDic:(NSDictionary *)dic;
- (NSString *)updateSqlWithDic:(NSDictionary *)dic condition:(NSArray *)conditons;
- (NSString *)insertSqlWithDic:(NSDictionary *)dic tableName:(NSString *)tableName;

- (id)parseFMResult:(NSDictionary *)rs clazz:(Class)clazz;
- (NSString *)updateSqlWithDic:(NSDictionary *)dic condition:(NSArray *)conditons tableName:(NSString *)tableName;
- (id)createInstanceByClassName:(NSString *)className;

- (void)upgradeCheck;
- (BOOL)upgrade:(NSInteger)oldVersion;
- (BOOL)upgradeFrom1To2;
- (BOOL)upgradeFrom2To3;
- (BOOL)upgradeFrom3To4;

- (void)commonInit;
- (BOOL)createTables;
- (Class)propertyClazz;

@end
#endif /* KWDBManagerPrivate_h */

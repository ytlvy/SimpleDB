//
//  KWDBManager.h
//  KWUtility
//
//  Created by gyj on 2017/6/29.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@class KWSBaseModel;

@interface KWSimpleDBManager : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (NSArray *)allModel;
- (NSArray *)modelsInRange:(NSRange)range;

- (BOOL)insertModel:(KWSBaseModel *)model;
- (BOOL)insertModels:(NSArray<KWSBaseModel *>*)models;
- (BOOL)rinsertModels:(NSArray<KWSBaseModel *>*)models;

- (BOOL)updateModel:(KWSBaseModel *)model;
/**
 更新数据

 @param condition 条件字典 @{@"col1":@"val1", @"col2":@"val2"}
 @param params 需要更新的数据字典 @{@"needupdateCol1":@"val1", @"needupdateCol2":@"val2"}
 @return 
 */
- (BOOL)updateModelCondition:(NSDictionary *)condition params:(NSDictionary *)params;


- (BOOL)updateModel:(NSDictionary *)values column:(NSString *)colum values:(NSArray *)values;

- (BOOL)deleteModel:(KWSBaseModel *)model;
- (BOOL)removeModel:(KWSBaseModel *)model;

- (BOOL)removeAll;
- (BOOL)deleteAll;


- (NSInteger)totalNumber;
- (KWSBaseModel *)modelForDic:(NSDictionary *)dic;

- (void)virtual_configManager;
- (BOOL)keepModelTotalNum:(NSInteger)total;

#pragma mark - condition
- (NSArray *)modelsInRange:(NSRange)range condition:(NSDictionary *)condition;//version2
- (NSInteger)totalNumberCondition:(NSDictionary *)condition;  //version2
- (BOOL)keepModelTotalNum:(NSInteger)total condition:(NSDictionary *)condition; //version2
- (BOOL)removeModelsCondition:(NSDictionary *)condition; //version2
@end

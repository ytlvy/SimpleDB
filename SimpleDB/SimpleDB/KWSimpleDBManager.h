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
- (BOOL)deleteModel:(KWSBaseModel *)model;
- (BOOL)deleteAll;

- (NSInteger)totalNumber;
- (KWSBaseModel *)modelForDic:(NSDictionary *)dic;

- (void)virtual_configManager;

@end

//
//  KWDBManager.m
//  KWUtility
//
//  Created by gyj on 2017/6/29.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWSimpleDBManager.h"
#import "FMDatabaseQueue.h"

#import <objc/runtime.h>
#import "FMDB.h"
#import "KWSBaseModel.h"
#import "KWSimpleDBManagerPrivate.h"
#import "DataTypeEncoding.h"
#import <UIKit/UIKit.h>
#import "KWFMWrapper.h"
#import "KWDBVersion.h"
#import "KWSqlWrapper.h"


static NSString * const TYPE_INT_NAME     = @"int";
static NSString * const TYPE_DOUBLE_NAME  = @"double";
static NSString * const TYPE_ID_NAME      = @"id";
static NSString * const TYPE_DATE_NAME    = @"date";
static NSString * const TYPE_ARRAY_NAME   = @"array";

@interface KWSimpleDBManager() 

@property (nonatomic, strong) NSString *path;

@end


@implementation KWSimpleDBManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"NOT USE");
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
        [self virtual_configManager];
        [self commonInit];
    }
    return self;
}

#pragma mark - init Functions
- (void)upgradeCheck {
    
    NSAssert(self.tableIdentifier.length > 0, @"");
    NSAssert(self.currentVersion > 0, @"");
    [[KWDBVersion sharedInstance] checkUpgrade:self.tableIdentifier curVer:self.currentVersion blk:^BOOL(NSInteger oldVer){
        return [self upgrade:oldVer]; 
    }];
}

- (BOOL)upgrade:(NSInteger)oldVersion {
    BOOL succ = YES;
    
    while (oldVersion < self.currentVersion) {
        
        switch (oldVersion) {
            case 0:
                break;
            case 1:
                succ = [self upgradeFrom1To2];
                break;
            case 2:
                succ = [self upgradeFrom2To3];
                break;
            case 3:
                succ = [self upgradeFrom3To4];
                break;
            default:
                break;
        }
        if(!succ) {
            break;
        }
        oldVersion ++;
    }    
        
    return succ;
}

- (BOOL)upgradeFrom1To2 {
    NSAssert(NO, @"");
    return NO;
}
- (BOOL)upgradeFrom2To3 {
    NSAssert(NO, @"");
    return NO;
    
}
- (BOOL)upgradeFrom3To4 {
    NSAssert(NO, @"");
    return NO;
}

- (BOOL)upgradeFrom5To6 {
    NSAssert(NO, @"");
    return NO;
}

- (BOOL)upgradeFrom4To5 {
    NSAssert(NO, @"");
    return NO;
}

- (void)commonInit {
    
    NSAssert(self.tableName, @"need Configure");
    NSAssert(self.propertyClazz, @"need Configure");
    NSAssert(self.tableIdentifier, @"need Configure");
    NSAssert(self.currentVersion, @"need Configure");
    [self createTables];
    [self upgradeCheck];
}

- (BOOL)createTables {
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).create(self.propertyClazz, [self.propertyClazz valueForKey:@"fmPropertyArray"]).primary([self.propertyClazz fmPrimaryKeys]).commit();
    
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"create table error");
    }
    
    return res.success;
}

#pragma mark - Public Interface

- (BOOL)insertModel:(KWSBaseModel *)model {
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).insert([model fmColumnMap]).commit();
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"insert model error");
    }
    return res.success; 
}

- (BOOL)insertModels:(NSArray<KWSBaseModel *>*)models {
    
    NSMutableArray *params = [NSMutableArray new];
    for (KWSBaseModel *model in models) {
        [params addObject:[model fmColumnMap]];
    }
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).insertArray(params, NO).commit();
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"insert models error");
    }
    return res.success;  
}

- (BOOL)rinsertModels:(NSArray<KWSBaseModel *>*)models {
    
    NSMutableArray *params = [NSMutableArray new];
    for (KWSBaseModel *model in models) {
        [params addObject:[model fmColumnMap]];
    }
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).insertArray(params, YES).commit();
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"insert models error");
    }
    return res.success;  
}


- (BOOL)keepModelTotalNum:(NSInteger)total{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE rowid < (SELECT rowid FROM %@ ORDER BY rowid DESC LIMIT 1 OFFSET %ld)", self.tableName, self.tableName, total-1];
    
    KWSqlResult *res = self.dbWrapper.commitSql(sql);
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"insert models error");
    }
    return res.success;  
}


- (BOOL)updateModel:(KWSBaseModel *)model {
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).update([model fmColumnMap]).where([self conditionMap:model]).commit();
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"updateModel error");
    }
    return res.success;  
}
- (BOOL)updateModel:(NSDictionary *)params column:(NSString *)colum values:(NSArray *)values {
    NSAssert(params.count > 0 && values.count > 0 && colum.length > 0, @"");
    
    NSArray *colums = [self.propertyClazz fmPropertyArray];
    if(colums.count < 1) {
        colums = [[self.propertyClazz fmPropertyMap] allKeys];
    }
    NSAssert(colums.count > 0, @"");
    //监测条件字段
    if([colums indexOfObject:colum] == NSNotFound) {
        NSAssert(NO, @"");
    }
    
    //监测更新数据字段
    [[params allKeys] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([colums indexOfObject:obj] == NSNotFound) {
            NSAssert(NO, @"");
        }
    }];
    
    KWSqlResult *res =  self.dbWrapper.table(self.tableName).whereIn(colum, values).update(params).commit();
    return res.success;

}

- (BOOL)updateModelCondition:(NSDictionary *)condition params:(NSDictionary *)params {
    NSAssert(condition.count > 0 && params.count > 0, @"");
    
    NSArray *colums = [self.propertyClazz fmPropertyArray];
    if(colums.count < 1) {
        colums = [[self.propertyClazz fmPropertyMap] allKeys];
    }
    NSAssert(colums.count > 0, @"");
    
    [[condition allKeys] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([colums indexOfObject:obj] == NSNotFound) {
            NSAssert(NO, @"");
        }
    }];
                     
    [[params allKeys] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([colums indexOfObject:obj] == NSNotFound) {
            NSAssert(NO, @"");
        }
    }];
    
    KWSqlResult *res =  self.dbWrapper.table(self.tableName).where(condition).update(params).commit();
    return res.success;
}

- (KWSBaseModel *)modelForDic:(NSDictionary *)dic {
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).selectRow([self.propertyClazz fmPropertyArray]).where(dic).commit();
    if([res.rows firstObject]) {
        KWSBaseModel *model = [self parseFMResult:[res.rows firstObject] clazz:self.propertyClazz];
        return model;
    }
    
    return nil;
}

- (NSArray *)allModel {
    KWSqlResult *res = nil;
    if([self.propertyClazz fmSortString].length > 0) {
        res = self.dbWrapper.table(self.tableName).selectArray(nil).sortStr([self.propertyClazz fmSortString]).commit();
    }
    else {
        res = self.dbWrapper.table(self.tableName).selectArray(nil).commit(); 
    }
    if([res.rows count] >0) {
        NSMutableArray *list = [[NSMutableArray alloc] init]; 
        
        [res.rows enumerateObjectsUsingBlock:^(NSDictionary *row, NSUInteger idx, BOOL * _Nonnull stop) {
            if([row isKindOfClass:[NSDictionary class]]) {
                KWSBaseModel *model = [self parseFMResult:row clazz:self.propertyClazz]; 
                if(model) {
                    [list addObject:model];
                }
            }
        }];
        
        return list;
    }
    
    return nil;
}

- (NSArray *)modelsInRange:(NSRange)range {
    return [self modelsInRange:range condition:nil];
}

- (NSInteger)totalNumber {
    KWSqlResult *res = self.dbWrapper.table(self.tableName).total().commit();
    return res.num;
}

- (BOOL)deleteModel:(KWSBaseModel *)model {
    
    if (!model) {
        return YES;
    }
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).remove().where([self conditionMap:model]).commit();
    return res.success;
}

- (BOOL)removeModel:(KWSBaseModel *)model {
    return [self deleteModel:model];
}

- (BOOL)deleteAll {
    KWSqlResult *res = self.dbWrapper.table(self.tableName).remove().commit();
    return res.success; 
}
- (BOOL)removeAll {
    return [self deleteAll]; 
}

#pragma mark - condition


- (BOOL)removeModelsCondition:(NSDictionary *)condition {
    if (![condition isKindOfClass:[NSDictionary class]] || condition.count <1) {
        NSAssert(NO, @"");
        return NO;
    }
    
    KWSqlResult *res = self.dbWrapper.table(self.tableName).remove().where(condition).commit();
    return res.success;
}

- (NSArray *)modelsInRange:(NSRange)range condition:(NSDictionary *)condition {
    NSAssert(range.length > 0, @"");
    
    KWFMWrapper *wrapper = self.dbWrapper.table(self.tableName).selectArray(nil);
    if([self.propertyClazz fmSortString].length > 0) {
        wrapper = wrapper.sortStr([self.propertyClazz fmSortString]);
    }
    
    if(condition && [condition isKindOfClass:[NSDictionary class]]) {
        wrapper = wrapper.where(condition);
    }
    
    KWSqlResult *res = wrapper.limit(range.length,  range.location).commit();
    
    if([res.rows count] >0) {
        NSMutableArray *list = [[NSMutableArray alloc] init]; 
        [res.rows enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[NSDictionary class]]) {
                KWSBaseModel *model = [self parseFMResult:obj clazz:self.propertyClazz];
                if(model) {
                    [list addObject:model];
                }
            }
            
        }];
        
        return list;
    }
    
    return nil;
    
}


- (NSInteger)totalNumberCondition:(NSDictionary *)condition {
    if (![condition isKindOfClass:[NSDictionary class]] || condition.count <1) {
        NSAssert(NO, @"");
        return 0;
    }
    KWSqlResult *res = self.dbWrapper.table(self.tableName).total().where(condition).commit();
    return res.num;
}
- (BOOL)keepModelTotalNum:(NSInteger)total condition:(NSDictionary *)condition {
    if (![condition isKindOfClass:[NSDictionary class]] || condition.count <1) {
        NSAssert(NO, @"");
        return 0;
    }

    NSString *condStr = [self conditionStr:[condition allKeys] needWhere:NO];
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE rowid < (SELECT rowid FROM %@ WHERE %@ ORDER BY rowid DESC LIMIT 1 OFFSET %ld) AND %@", self.tableName, self.tableName, condStr, total-1, condStr];
    
    KWSqlResult *res = self.dbWrapper.commitSqlAndParams(sql, condition);
    if(!res.success) {
        NSAssert(NO, @"");
        NSLog(@"insert models error");
    }
    return res.success;  
}

- (NSString *)conditionStr:(NSArray *)conditions needWhere:(BOOL)needWhere {
    if ([conditions count] < 1) {
        //        NSAssert(NO, @"Model 唯一条件不完备");
        return @" ";
    }
    NSMutableString *con = needWhere ? [@" WHERE " mutableCopy] : [NSMutableString new];
    [con appendString: [NSString stringWithFormat:@" %@=:%@ ", conditions[0], conditions[0]]];
    
    int length = (int)[conditions count];
    if (length > 1) {
        for (int i = 1; i<length; i++) {
            [con appendFormat:@"AND %@=:%@ ", conditions[i], conditions[i]];
        }
    }
    
    return [con copy];
}

#pragma mark - Private Interface

- (NSDictionary *)conditionMap:(KWSBaseModel *)model {
    NSDictionary *columMap = [model fmColumnMap];
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    NSArray *conditions = [self.propertyClazz fmConditions];
    if([conditions count] > 0) {
        [conditions enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            if(columMap[key]) {
                [m_dic setObject:columMap[key] forKey:key];
            }
        }]; 
    }
    
    return m_dic;
}

- (NSString *)insertSqlWithDic:(NSDictionary *)dic {
    return [self insertSqlWithDic:dic tableName:self.tableName];
}

- (NSString *)insertSqlWithDic:(NSDictionary *)dic tableName:(NSString *)tableName {
    
    NSAssert(dic && tableName, @"表名称未提供或者map为空");
    
    if (!dic) {
        return @"";
    }
    
    NSString *tabelStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@", tableName] ;
    NSMutableString *columnStr = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString *valueStr  = [[NSMutableString alloc] initWithString:@"VALUES ("];
    
    
    NSArray *keys = [dic allKeys];
    
    [columnStr appendFormat:@"%@ )", [keys componentsJoinedByString:@", "]];
    [valueStr appendFormat:@":%@ ) ", [keys componentsJoinedByString:@", :"]];
    
    return [NSString stringWithFormat:@"%@%@%@", tabelStr, columnStr, valueStr];
}

- (NSString *)updateSqlWithDic:(NSDictionary *)dic condition:(NSArray *)conditions tableName:(NSString *)tableName {
    NSMutableString *updateStr = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET ", tableName];
    
    NSArray *allKeys = [dic allKeys];
    for (NSString *key in allKeys) {
        if ([conditions indexOfObject:key] == NSNotFound) {
            [updateStr appendFormat:@"%@=:%@, ", key, key];
        }
    }
    
    [updateStr deleteCharactersInRange:NSMakeRange(updateStr.length - 2, 2)];
    [updateStr appendString: [self conditionStr: conditions needWhere:YES]];
    //    NSLog(@"==INFO== update db string: %@", updateStr);
    return [updateStr copy];
}

- (NSString *)updateSqlWithDic:(NSDictionary *)dic condition:(NSArray *)conditons{
    
    return [self updateSqlWithDic:dic condition:conditons tableName:self.tableName];
}


- (KWSBaseModel *)parseFMResult:(NSDictionary *)fmResult clazz:(Class)clazz {
    
    KWSBaseModel *instanceObj = [self createInstanceByClassName:[clazz description]];
    
    BOOL isUseMap = NO;
    
    NSArray *allProperties;
    NSArray *fmPropertyArr      = [clazz valueForKey:@"fmPropertyArray"];
    NSDictionary *fmPropertyMap = [clazz valueForKey:@"fmPropertyMap"];
    if (!fmPropertyArr) {
        isUseMap = YES;
        allProperties = [fmPropertyMap allKeys];
    }
    else {
        allProperties = fmPropertyArr;
    }
    
    if (!fmResult || !allProperties) {
        NSAssert(NO, @"==ERROR== 解析数据库失败");
        return nil;
    }
    
    /**
     *  根据key遍历dic
     */
    for (NSString * key in allProperties) {
        //获取数据库字段
        NSString *column;
        if (isUseMap) {
            column = fmPropertyMap[key];
        }
        else {
            column  = key;
        }
        
        if (!fmResult[column]) {
            NSAssert(NO, @"==ERROR== 数据库字段错误");
            continue;
        }
        //获取数据库字段数据
        id value = [fmResult valueForKey:column];
        objc_property_t property = class_getProperty(clazz, [key UTF8String]);
        
        NSString *type = [[self class] getPropertyType:property];
        if ([type isEqualToString:TYPE_DATE_NAME]) {
            
            if ([value isKindOfClass:[NSNumber class]]) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                [instanceObj setValue:date forKey:key];
                continue;
            }
            else if([value isKindOfClass:[NSString class]]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                [instanceObj setValue:[dateFormatter dateFromString:value] forKey:key];
                continue;
            }
        }
        
        if ([value isKindOfClass:[NSNumber class]]) {
            if (![key isEqualToString:@"id"]) {
                [instanceObj setValue:value forKey:key];
            }
        }
        else if([value isKindOfClass:[NSData class]]) {
            __autoreleasing NSError* error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:&error]; 
            if (error != nil) return nil;
            
            if([instanceObj respondsToSelector:@selector(parseValue:property:)]){
                [instanceObj parseValue:result property:key];
            }
            else {
                [instanceObj setValue:result forKey:key];
            }
        }
        else {
            if ([value isKindOfClass:[NSString class]]) {
                if ([value isEqualToString:@"(null)"]) {
                    value = @"";
                }
            }
            
            [instanceObj setValue:value forKey:key];
        }
    }
    
    if (instanceObj) {
        return instanceObj;
    }
    
    return nil;
}

- (id)createInstanceByClassName:(NSString *)className {
    NSBundle * bundle   = [NSBundle mainBundle];
    Class clazz         = [bundle classNamed:className];
    id instanceObj      = [[clazz alloc] init];
    return instanceObj;
}

+ (NSString *)getPropertyType:(objc_property_t)property {
    const char * type = property_getAttributes(property);
    NSString * typeStr = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeStr componentsSeparatedByString:@","];
    if ([attributes count] <= 0) {
        return nil;
    }
    NSString * typeAttribute = [attributes firstObject];
    if ([typeAttribute length] < 1) {
        return nil;
    }
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (!strcmp(rawPropertyType, @encode(float)) ||
        !strcmp(rawPropertyType, @encode(CGFloat)) ||
        !strcmp(rawPropertyType, @encode(double))) {
        return TYPE_DOUBLE_NAME;
    }
    else if (!strcmp(rawPropertyType, @encode(int)) ||
             !strcmp(rawPropertyType, @encode(long)) ||
             !strcmp(rawPropertyType, @encode(NSInteger)) ||
             !strcmp(rawPropertyType, @encode(NSUInteger))) {
        return TYPE_INT_NAME;
    }
    else if (!strcmp(rawPropertyType, "@\"NSDate\"")) {
        return TYPE_DATE_NAME;
    }
    else if (!strcmp(rawPropertyType, @encode(id))) {
        return TYPE_ID_NAME;
    }
    else if (!strcmp(rawPropertyType, "c")) {
        NSAssert(NO, @"");
    }
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        NSString * className = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
        if (className) {
            return className;
        }
    }
    NSAssert(NO, @"");
    return nil;
}


- (void)virtual_configManager {
    
}

- (KWFMWrapper *)dbWrapper {
    if(_dbWrapper == nil) {
        _dbWrapper = [[KWFMWrapper alloc] initWithPath:self.path];
    }
    return _dbWrapper;
}

@end


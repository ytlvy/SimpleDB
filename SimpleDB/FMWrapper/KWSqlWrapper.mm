//
//  KWSqlWrapper.m
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import "KWSqlWrapper.h"
#import <objc/runtime.h>
#import "DataTypeEncoding.h"
#import "EXTScope.h"
#import "KWFMEnum.h"

@interface KWSqlWrapper()

@property (nonatomic, strong) NSString *sql;

@end

@implementation KWSqlWrapper
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.params = [NSMutableDictionary new];
        self.paramArray = [NSMutableArray new];
    }
    return self;
}


- (NSString *)composite  {
    
    NSAssert(self.table, @"");
    
    switch (self.sqlType) {
            
        case KWSqlType_Total:
            [self compositeTotal];
            break;
        case KWSqlType_SelectInt:
            [self compositeSelectInt];
            break;
        case KWSqlType_ColumTotal:
            [self compositeColumTotal];
            break;
        case KWSqlType_SelectOne:
            [self compositeSelectOne]; 
            break;
        case KWSqlType_SelectRow:
            [self compositeSelectRow];  
            break;
        case KWSqlType_SelectArray:
            [self compositeSelectArray];  
            break;
        case KWSqlType_Insert:
            [self compositeInsert];
            break;
        case KWSqlType_InsertArray:
            [self compositeInsertArray];
            break;
            
        case KWSqlType_Update:
            [self compositeUpdate];
            break;
        case KWSqlType_Create:
            [self compositeCreate];
            break;
        case KWSqlType_Delete:
            [self compositeDelte];
            break;
        case KWSqlType_AddColum:
            [self compositeAddColum];
            break;
        default:
            break;
    }
    
    return self.sql;
}

- (void)reset {
    self.sqlType = KWSqlType_None;
    self.colums = nil;
    self.rows = nil;
    self.columAndTypes = nil;
    self.columAndvalues = nil;
    self.reverse = NO;
    self.conditions = nil; 
    self.sort = nil;
    self.primaryKeys = nil;
    self.limit = 0;
    self.offset = 0;
    if(self.paramArray.count > 0) {
        self.paramArray = [NSMutableArray new];
    }
    if(self.params.count > 0) {
        self.params = [NSMutableDictionary new];
    }
}

- (void)compositeTotal {
    self.sql = [NSString stringWithFormat:@"SELECT count(*) FROM %@", self.table]; 
    [self appendWhere]; 
}
- (void)compositeColumTotal {
    NSAssert([self.colums count] > 0, @"");
    
    if(self.distinct) {
        self.sql = [NSString stringWithFormat:@"SELECT DISTINCT count(%@) FROM %@", [self.colums firstObject], self.table]; 
    }
    else {
        self.sql = [NSString stringWithFormat:@"SELECT count(%@) FROM %@", [self.colums firstObject], self.table];
    }
    
    [self appendWhere]; 
}

- (void)compositeSelectInt {
    NSAssert([self.colums count] > 0, @"");
    self.sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", [self.colums firstObject], self.table];
    [self appendWhere]; 
}

- (void)compositeSelectOne {
    NSAssert([self.colums count] > 0, @"");
    self.sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", [self.colums firstObject], self.table];
    [self appendWhere];
}

- (void)compositeSelectRow {
    if([self.colums count] > 0) {
        self.sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", [self.colums componentsJoinedByString:@", "], self.table];
    }
    else {
       self.sql = [NSString stringWithFormat:@"SELECT * FROM %@", self.table]; 
    }
    [self appendWhere]; 
}

- (void)compositeSelectArray {
    if([self.colums count] > 0) {
        self.sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", [self.colums componentsJoinedByString:@", "], self.table];
    }
    else {
        self.sql = [NSString stringWithFormat:@"SELECT * FROM %@", self.table]; 
    }
    [self appendWhere]; 
    [self appendSort];
    [self appendLimit];
}


- (void)compositeInsert {
    NSAssert([self.columAndvalues count] > 0, @""); 
    self.sql = [self insertSqlWithDic:self.columAndvalues]; 
    [self.params addEntriesFromDictionary:self.columAndvalues];
    
}

- (void)compositeInsertArray {
    NSAssert([self.rows count] > 0, @""); 
    NSAssert(self.table, @"表名称未提供或者map为空");
    NSDictionary *row = [self.rows firstObject];
    NSAssert([row isKindOfClass:[NSDictionary class]], @"");
    
    //1
    NSString *tabelStr = [NSString stringWithFormat:@"INSERT INTO %@", self.table];
    
    //2
    NSArray *allKeys = [row allKeys];
    NSMutableString *columnStr = [[NSMutableString alloc] initWithString:@"("];
    [columnStr appendFormat:@"%@ )", [allKeys componentsJoinedByString:@", "]];
    
    //3
    NSMutableString *valueStr = [NSMutableString new];
    NSInteger columNum = [allKeys count];
    NSInteger rowNum = [self.rows count];
    for (int i=0; i<rowNum; i++) {
        NSDictionary *row = self.reverse ?  self.rows[rowNum - i - 1] :self.rows[i] ;
        [valueStr appendString:@"("];
        
        for (int j =0; j<columNum; j++) {
            if(j == columNum -1) {
               [valueStr appendString:@"?"]; 
            }
            else {
                [valueStr appendString:@"?,"];
            }
            
            [self.paramArray addObject:row[allKeys[j]]];
        }
        
        if(i == rowNum-1) {
            [valueStr appendString:@"); "];
        }
        else {
            [valueStr appendString:@"), "];
        }
    }
    
    self.sql = [NSString stringWithFormat:@"%@%@ VALUES %@", tabelStr, columnStr, valueStr];
}

- (void)compositeUpdate {
    NSAssert([self.columAndvalues count] > 0, @""); 
    NSAssert(self.conditions, @"");
    
    self.sql = [self updateSqlWithDic:self.columAndvalues condition:[[self conditions] allKeys]]; 
    [self.params addEntriesFromDictionary:self.columAndvalues];
    [self.params addEntriesFromDictionary:self.conditions];
}

- (void)compositeCreate {
    NSAssert([self.colums count]>0 || [[self.columAndTypes allKeys] count]>0, @"数据库字段未设置");
    
    NSMutableString *createStr = [NSMutableString new];
    [createStr appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (", self.table];
    
    if(self.colums) {
        for (NSString *col in self.colums) {
            [createStr appendFormat:@"%@   %@, ", col, [self columType:col]];
        }
    }
    else if(self.columAndTypes) {
        [self.columAndTypes enumerateKeysAndObjectsUsingBlock:^(NSString *col, NSNumber *type, BOOL * _Nonnull stop) {
            NSAssert([type isKindOfClass:[NSNumber class]], @"");
            
            [createStr appendFormat:@"%@   %@, ", col, [self typeForColumEnum:type]]; 
        }];
    }
    
    if ([[self primaryKeys] count] > 0) {
        [createStr appendFormat:@"PRIMARY KEY ( %@ ) ", [[self primaryKeys] componentsJoinedByString:@", "]];
    }
    else {
        [createStr deleteCharactersInRange:NSMakeRange(createStr.length-2, 2)];
    }
    
    [createStr appendString:@");"]; 
    self.sql = createStr;
}

- (void)compositeDelte {
    self.sql = [NSString stringWithFormat:@"DELETE FROM %@", self.table];
    self.sql = [self.sql stringByAppendingString:[[self class] conditionStr:[self.conditions allKeys]]]; 
    [self.params addEntriesFromDictionary:self.conditions];
}

- (void)compositeAddColum {
    NSAssert(self.clazz, @"");
    NSAssert([self.colums count]>0 , @"");
    NSMutableString *m_sql = [NSMutableString new];
    @weakify(self);
    [self.colums enumerateObjectsUsingBlock:^(NSString *col, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [m_sql appendString:[NSString stringWithFormat:@" ALTER TABLE %@ ADD %@ %@;", self.table, col, [self columType:col]]]; 
    }];
    self.sql = m_sql;
}

#pragma mark - Private Interface

- (NSString *)typeForColumEnum:(NSNumber *)type {
    if(![type isKindOfClass:[NSNumber class]]) {
        return @"TEXT DEFAULT \"\"";
    }
    
    NSString * sqlStrWithTypeCode = nil;
    
    switch ([type integerValue]) {
        case KWColumType_Number:
        {
            sqlStrWithTypeCode = @"INTEGER DEFAULT 0";
        }
            break;
        case KWColumType_Data:
        {
            sqlStrWithTypeCode = @"BLOB";
        }
            break;
        case KWColumType_UIImage:
        {
            sqlStrWithTypeCode = @"BLOB";
        }
            break;
            
        case KWColumType_Date:
        {
            sqlStrWithTypeCode = @"TIMESTAMP default (datetime('now', 'localtime'))";
        }
            break;
            
        default:
        {
            sqlStrWithTypeCode = @"TEXT DEFAULT \"\"";
        }
            break;
    }
    return sqlStrWithTypeCode;
}
- (NSString *)columType:(NSString *)colum {
    objc_property_t oproperty = class_getProperty(self.clazz, [colum UTF8String]);
    const char * attributesChar = property_getAttributes(oproperty);
    VTypeCode typeCode          = [DataTypeEncoding getTypeWithAttribute:attributesChar];
    return [DataTypeEncoding getSqlWithTypeCode:typeCode]; 
}


- (void)appendWhere {
    if(self.conditions && [[self.conditions allKeys] count]>0) {
        self.sql = [self.sql stringByAppendingString:[[self class] conditionStr:[self.conditions allKeys]]];
        [self.params addEntriesFromDictionary:self.conditions];
    }
}

- (void)appendSort {
    if(self.sort.length > 0) {
        self.sql = [self.sql stringByAppendingString:self.sort];
    }
}

- (void)appendLimit {
    if(self.limit > 0) {
        self.sql = [self.sql stringByAppendingString:[NSString stringWithFormat:@" LIMIT %ld OFFSET %ld ", (long)self.limit, (long)self.offset]];
    }
}

- (NSString *)insertSqlWithDic:(NSDictionary *)dic {
    return [self insertSqlWithDic:dic tableName:self.table];
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
    [updateStr appendString: [[self class] conditionStr: conditions]];
    //    NSLog(@"==INFO== update db string: %@", updateStr);
    return [updateStr copy];
}

+ (NSString *)conditionStr:(NSArray *)conditions {
    if ([conditions count] < 1) {
//        NSAssert(NO, @"Model 唯一条件不完备");
        return @" ";
    }
    NSMutableString *con = [[NSString stringWithFormat:@" WHERE %@=:%@ ", conditions[0], conditions[0]] mutableCopy];
    
    int length = (int)[conditions count];
    if (length > 1) {
        for (int i = 1; i<length; i++) {
            [con appendFormat:@"AND %@=:%@ ", conditions[i], conditions[i]];
        }
    }
    
    return [con copy];
}


- (NSString *)updateSqlWithDic:(NSDictionary *)dic condition:(NSArray *)conditons{
    
    return [self updateSqlWithDic:dic condition:conditons tableName:self.table];
}

@end

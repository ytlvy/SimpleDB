//
//  FWWrapper.m
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import "KWFMWrapper.h"
#import "FMDatabaseQueue.h"
#import "KWSqlWrapper.h"
#import "KWDBWrapper.h"

@interface KWFMWrapper()


@property (nonatomic, copy)   NSString *p_path;
@property (nonatomic, strong) KWSqlWrapper *sqlWrapper;
@property (nonatomic, strong) KWDBWrapper *dbWrapper;

@end

@implementation KWFMWrapper

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
        self.p_path = path;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path table:(NSString *)table {
    self = [super init];
    if (self) {
        self.p_path = path;
        self.sqlWrapper.table = table;
    }
    return self; 
}

#pragma mark - Public Interface

- (KWFMWrapper *(^)(NSString *table))table {
    return ^id(NSString *table){
        self.sqlWrapper.table = table;
        return self;
    };
}

#pragma mark - 类型

- (KWFMWrapper *(^)(Class clazz, NSArray *colums))create {
    return ^id(Class clazz, NSArray *colums) {
        self.sqlWrapper.sqlType = KWSqlType_Create;
        self.sqlWrapper.clazz = clazz;
        self.sqlWrapper.colums = colums;
        return self;
    };
}

- (KWFMWrapper *(^)(NSDictionary *colAndType))createT {
    return ^id(NSDictionary *colAndType) {
        self.sqlWrapper.sqlType = KWSqlType_Create;
        self.sqlWrapper.columAndTypes = colAndType;
        return self;
    }; 
}

- (KWFMWrapper *(^)())total {
    return ^id(){
        self.sqlWrapper.sqlType = KWSqlType_Total;
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSString *colum))columTotal {
    return ^id(NSString *colum){
        self.sqlWrapper.sqlType = KWSqlType_ColumTotal;
        self.sqlWrapper.colums = @[colum];
        
        return self;
    }; 
}

- (KWFMWrapper *(^)(NSString *colum))selectInt {
    return ^id(NSString *colum){
        self.sqlWrapper.sqlType = KWSqlType_SelectInt;
        self.sqlWrapper.colums = @[colum];
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSString *colum))selectOne {
    return ^id(NSString *colum){
        self.sqlWrapper.sqlType = KWSqlType_SelectOne;
        self.sqlWrapper.colums = @[colum];
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSArray *))selectRow {
    return ^id(NSArray *colums){
        self.sqlWrapper.sqlType = KWSqlType_SelectRow;
        self.sqlWrapper.colums = colums; 
        return self;
    }; 
}

- (KWFMWrapper *(^)(NSArray *colums))selectArray {
    return ^id(NSArray *colums){
        self.sqlWrapper.sqlType = KWSqlType_SelectArray;
        self.sqlWrapper.colums = colums; 
        return self;
    };
}

- (KWFMWrapper *(^)(NSDictionary *params))insert {
    return ^id(NSDictionary *params){
        self.sqlWrapper.sqlType = KWSqlType_Insert;
        self.sqlWrapper.columAndvalues = params;
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSArray *rows, BOOL reverse))insertArray {
    return ^id(NSArray *rows, BOOL reverse){
        self.sqlWrapper.sqlType = KWSqlType_InsertArray;
        self.sqlWrapper.rows = rows;
        self.sqlWrapper.reverse = reverse;
        
        return self;
    };
 
}

- (KWFMWrapper *(^)(NSDictionary *params))update {
    return ^id(NSDictionary *params){
        self.sqlWrapper.sqlType = KWSqlType_Update;
        self.sqlWrapper.columAndvalues = params;
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSArray *colums))addColum {
    return ^id(NSArray *colums) {
        self.sqlWrapper.sqlType = KWSqlType_AddColum;
        self.sqlWrapper.colums = colums;
        
        return self;
    };
}

- (KWFMWrapper *(^)())remove {
    return ^id(){
        self.sqlWrapper.sqlType = KWSqlType_Delete;
        
        return self;
    };
}



#pragma mark - 

- (KWFMWrapper *(^)(NSArray *pkeys))primary {
    return ^id(NSArray *pkeys) {
        self.sqlWrapper.primaryKeys = pkeys;
        return self;
    };
}

- (KWFMWrapper *(^)(NSDictionary *conditions))where {
    return ^id(NSDictionary *conditions) {
        self.sqlWrapper.conditions = conditions;
        return self;
    };
}

- (KWFMWrapper *(^)(NSInteger limit, NSInteger offset))limit {
    return ^id(NSInteger limit, NSInteger offset) {
        self.sqlWrapper.limit = limit;
        self.sqlWrapper.offset = offset;
        return self;
    };
}

- (KWFMWrapper *(^)(NSString *colum, BOOL ASC))sort {
    return ^id(NSString *colum, BOOL ASC) {
        if(self.sqlWrapper.sort.length > 0) {
            self.sqlWrapper.sort =  [NSString stringWithFormat: @"%@, %@ %@", self.sqlWrapper.sort, colum, ASC ? @"":@"DESC"];
        }
        else {
            self.sqlWrapper.sort = [NSString stringWithFormat: @"ORDER BY %@ %@", colum, ASC ? @"":@"DESC"];
        }
        
        return self;
    };
}

- (KWFMWrapper *(^)(NSString *sortStr))sortStr {
    return ^id(NSString *sortStr) {
        self.sqlWrapper.sort= sortStr;
        return self;
    }; 
}

- (KWSqlResult *(^)(NSString *sql))commitSql {
     return ^id(NSString *sql) {
         KWSqlResult *result = [self.dbWrapper execute:sql params:nil];
         return result;
     };
}

- (KWSqlResult *(^)(NSString *sql, NSDictionary *params))commitSqlAndParams{
    return ^id(NSString *sql, NSDictionary *params) {
        KWSqlResult *result = [self.dbWrapper execute:sql params:params];
        return result;
    };
}

- (KWSqlResult *(^)())commit {
    return ^id() {
        
        NSAssert(self.sqlWrapper.sqlType != KWSqlType_None, @"");
        
        KWSqlResult *result = [KWSqlResult errorResult];
        NSString *sql =  [self.sqlWrapper composite];
        switch (self.sqlWrapper.sqlType) {
            case KWSqlType_Total:
            case KWSqlType_ColumTotal:
            case KWSqlType_SelectInt:
                result = [self.dbWrapper selectInt:sql params:self.sqlWrapper.params];
                break;
            case KWSqlType_SelectOne:
                result = [self.dbWrapper selectOne:sql params:self.sqlWrapper.params];
                break;
            case KWSqlType_SelectRow:
                result = [self.dbWrapper selectRow:sql params:self.sqlWrapper.params];
                break;
            case KWSqlType_SelectArray:
                result = [self.dbWrapper selectArray:sql params:self.sqlWrapper.params];
                break;
            case KWSqlType_Insert:
            case KWSqlType_Update:
            case KWSqlType_Delete:
            case KWSqlType_AddColum:
            case KWSqlType_Create:
                result = [self.dbWrapper execute:sql params:self.sqlWrapper.params];
                break;
                
            case KWSqlType_InsertArray:
                result = [self.dbWrapper execute:sql array:self.sqlWrapper.paramArray];
                break;

            default:
                break;
        }
            
        [self.sqlWrapper reset];
        return result;
    };
}

#pragma mark - Private Interace
- (NSString *)dbPath:(NSString *)dbName {
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[array firstObject] stringByAppendingPathComponent:dbName];
}

#pragma mark - Properties

- (KWSqlWrapper *)sqlWrapper {
	if(_sqlWrapper == nil) {
		_sqlWrapper = [[KWSqlWrapper alloc] init];
	}
	return _sqlWrapper;
}

- (KWDBWrapper *)dbWrapper {
	if(_dbWrapper == nil) {
		_dbWrapper = [[KWDBWrapper alloc] initWithQueue:[FMDatabaseQueue databaseQueueWithPath:[self dbPath:self.p_path]]];
	}
	return _dbWrapper;
}

@end

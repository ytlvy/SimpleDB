//
//  KWDBWrapper.m
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import "KWDBWrapper.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface KWDBWrapper()

@property(nonatomic,strong) FMDatabaseQueue * kwCoreDBQueue;

@end

@implementation KWDBWrapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"");
    }
    return self;
}

- (instancetype)initWithQueue:(FMDatabaseQueue *)queue {
    self = [super init];
    if (self) {
        NSAssert(queue, @"");
        self.kwCoreDBQueue = queue; 
    }
    return self;
}

- (KWSqlResult *)selectInt:(NSString *)sql params:(NSDictionary *)params {
    NSAssert(sql.length > 0, @"");
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block int resultCount = 0;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:sql withParameterDictionary:params];
        
        if (resultSet && [resultSet next]) {
            resultCount = [resultSet intForColumnIndex:0];
        }
        [resultSet close];
    }];
    
    return [KWSqlResult resultWithNumber:resultCount];
}

- (KWSqlResult *)selectOne:(NSString *)sql params:(NSDictionary *)params{
    NSAssert(sql.length > 0, @"");
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block id value = nil;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:sql withParameterDictionary:params];
        if (resultSet && [resultSet next]) {
            value = [resultSet objectForColumnIndex:0];
        }
        
        [resultSet close];
    }];
    return [KWSqlResult resultWithValue:value];
}

- (KWSqlResult *)selectRow:(NSString *)sql params:(NSDictionary *)params {
    NSAssert(sql.length > 0, @"");
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block NSDictionary *row = nil;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:sql withParameterDictionary:params];
        if (resultSet && [resultSet next]) {
            row = [resultSet resultDictionary];
        }
        
        [resultSet close];
    }];
    return [KWSqlResult resultWithArray:@[row]];	
}

- (KWSqlResult *)selectArray:(NSString *)sql  params:(NSDictionary *)params{
    NSAssert(sql.length > 0, @"");
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block NSMutableArray *resArr = nil;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:sql withParameterDictionary:params];
        if (resultSet) {
            resArr = [NSMutableArray new];
            
            while ([resultSet next]) {
                [resArr addObject:[resultSet resultDictionary]];
            }
            
            [resultSet close];
        }
    }];
    return [KWSqlResult resultWithArray:resArr];		
}

- (KWSqlResult *)execute:(NSString *)sql  params:(NSDictionary *)params{
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block BOOL result = NO;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        result = result = [db executeUpdate:sql withParameterDictionary:params];
    }];
    return  [KWSqlResult resultWithSuccess:result];	
}

- (KWSqlResult *)execute:(NSString *)sql array:(NSArray *)array {
    if (sql == nil || [sql length] == 0) {
        return [KWSqlResult errorResult];
    }
    
    __block BOOL result = NO;
    [self.kwCoreDBQueue inDatabase:^(FMDatabase *db) {
        result = result = [db executeUpdate:sql withArgumentsInArray:array];
    }];
    return  [KWSqlResult resultWithSuccess:result];	 
}

@end

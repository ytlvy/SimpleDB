//
//  FWWrapper.h
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSqlResult.h"
#import "KWFMEnum.h"

@interface KWFMWrapper : NSObject

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path table:(NSString *)table;

- (KWFMWrapper *(^)(NSString *table))table;
- (KWFMWrapper *(^)(Class clazz, NSArray *))create;
- (KWFMWrapper *(^)(NSDictionary *colAndType))createT;

- (KWFMWrapper *(^)())total;
- (KWFMWrapper *(^)(NSString *colum))columTotal;

- (KWFMWrapper *(^)(NSString *colum))selectInt;
- (KWFMWrapper *(^)(NSString *colum))selectOne;
- (KWFMWrapper *(^)(NSArray *colums))selectRow;
- (KWFMWrapper *(^)(NSArray *colums))selectArray;

- (KWFMWrapper *(^)(NSDictionary *params))insert;
- (KWFMWrapper *(^)(NSArray *rows, BOOL reverse))insertArray;

- (KWFMWrapper *(^)(NSDictionary *params))update;


- (KWFMWrapper *(^)(NSArray *colums))addColum;


- (KWFMWrapper *(^)(NSInteger limit, NSInteger offset))limit;


- (KWFMWrapper *(^)())remove;

- (KWFMWrapper *(^)(NSArray *pkeys))primary;
- (KWFMWrapper *(^)(NSDictionary *conditions))where;
- (KWFMWrapper *(^)(NSString *column, NSArray *conditions))whereIn;
- (KWFMWrapper *(^)(NSString *colum, BOOL ASC))sort;
- (KWFMWrapper *(^)(NSString *sortStr))sortStr;


- (KWSqlResult *(^)())commit;

- (KWSqlResult *(^)(NSString *sql))commitSql;

- (KWSqlResult *(^)(NSString *sql, NSDictionary *params))commitSqlAndParams;
@end

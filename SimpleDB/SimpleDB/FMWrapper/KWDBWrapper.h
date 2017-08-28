//
//  KWDBWrapper.h
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSqlResult.h"
@class FMDatabaseQueue;

@interface KWDBWrapper : NSObject

- (instancetype)initWithQueue:(FMDatabaseQueue *)queue;

- (KWSqlResult *)selectInt:(NSString *)sql params:(NSDictionary *)params;
- (KWSqlResult *)selectOne:(NSString *)sql params:(NSDictionary *)params;
- (KWSqlResult *)selectRow:(NSString *)sql params:(NSDictionary *)params;
- (KWSqlResult *)selectArray:(NSString *)sql params:(NSDictionary *)params;
- (KWSqlResult *)execute:(NSString *)sql params:(NSDictionary *)params;
- (KWSqlResult *)execute:(NSString *)sql array:(NSArray *)array;

@end

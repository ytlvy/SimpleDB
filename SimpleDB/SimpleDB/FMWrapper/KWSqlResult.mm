//
//  KWSqlResult.m
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import "KWSqlResult.h"

@implementation KWSqlResult

+ (instancetype)resultWithSuccess:(BOOL)success {
    KWSqlResult *result = [[KWSqlResult alloc] init];
    result.success = success;
    
    return result;
}

+ (instancetype)errorResult {
    KWSqlResult *result = [[KWSqlResult alloc] init];
    result.success = NO;
    
    return result;
}

+ (instancetype)resultWithNumber:(NSInteger)number {
    KWSqlResult *result = [[KWSqlResult alloc] init];
    result.success = YES;
    result.num = number;
    
    return result;	
}

+ (instancetype)resultWithArray:(NSArray *)array {
    KWSqlResult *result = [[KWSqlResult alloc] init];
    result.success = YES;
    result.rows = array;
    
    return result;	
}

+ (instancetype)resultWithValue:(id)value {
    KWSqlResult *result = [[KWSqlResult alloc] init];
    result.success = YES;
    result.value = value;
    
    return result;		
}


@end

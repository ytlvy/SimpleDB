//
//  KWSqlResult.h
//  iTest
//
//  Created by gyj on 2017/7/14.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWSqlResult : NSObject

@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) id value;


@property (nonatomic, assign) BOOL  success;

+ (instancetype)errorResult;
+ (instancetype)resultWithSuccess:(BOOL)success;
+ (instancetype)resultWithNumber:(NSInteger)number;
+ (instancetype)resultWithValue:(id)value;
+ (instancetype)resultWithArray:(NSArray *)array;


@end

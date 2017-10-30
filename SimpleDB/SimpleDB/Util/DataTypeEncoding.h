//
//  DataTypeEncoding.h
//  VChat_iOS
//
//  Created by peter on 15/7/29.
//  Copyright (c) 2015年 xipukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VTypeCode) {
    __TYPE_Unknown,
    __TYPE_Number,
    __TYPE_Array,
    __TYPE_String,
    __TYPE_Dictionary,
    __TYPE_Date,
    __TYPE_Data,
    __TYPE_UIImage,
    __TYPE_Object,
};

@interface DataTypeEncoding : NSObject

/**
 *  动态获取数据property的typecode
 *
 *  @param attribute  runtime  property_getAttributes
 *
 *  @return typecode
 */
+ (VTypeCode)getTypeWithAttribute:(const char*)attribute;

/**
 *  根据TypeCode，将OC类型 转换为 Sql 类型
 *
 *  @param typeCode VTypeCode
 *
 *  @return Sql类型
 */
+ (NSString *)getSqlWithTypeCode:(VTypeCode)typeCode;

/**
 *  动态获取数据property的 typecode， 而后根据typecode ， 将oc类型 转换为 sql类型
 *
 *  @param attribute runtime property_getAttributes
 *
 *  @return typecode
 */
+ (NSString *)getSqlWithAttribute:(const char*)attribute;

@end

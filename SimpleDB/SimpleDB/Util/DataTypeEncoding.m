//
//  DataTypeEncoding.m
//  VChat_iOS
//
//  Created by peter on 15/7/29.
//  Copyright (c) 2015年 xipukeji. All rights reserved.
//

#import "DataTypeEncoding.h"

@implementation DataTypeEncoding

+ (VTypeCode)getTypeWithAttribute:(const char *)attribute {
    if (attribute[0] != 'T') {
        return __TYPE_Unknown;
    }
    const char * type = &attribute[1];
    if (type[0] == '@' && type[1] != '"') {
        return __TYPE_Unknown;
    }
    char lower = tolower(type[0]);
    if (lower == 'i' || lower == 's' || lower == 'l' || lower == 'q' || lower == 'f' || lower == 'd') {
        return __TYPE_Number;
    }
    
    char typeClazz[128] = { 0 };
    const char * clazz = &type[2];
    const char * clazzEnd = strchr(clazz, '"');
    
    if (clazzEnd && clazz != clazzEnd) {
        unsigned int size = (unsigned int)(clazzEnd - clazz);
        strncpy(&typeClazz[0], clazz, size);
        if (!strcmp((const char *)typeClazz, "NSNumber")) {
            return __TYPE_Number;
        } else if (!strcmp((const char *)typeClazz, "NSString")) {
            return __TYPE_String;
        } else if (!strcmp((const char *)typeClazz, "NSDate")) {
            return __TYPE_Date;
        } else if (!strcmp((const char *)typeClazz, "NSArray")) {
            return __TYPE_Array;
        } else if (!strcmp((const char *)typeClazz, "NSDictionary")) {
            return __TYPE_Dictionary;
        } else if (!strcmp((const char *)typeClazz, "NSData")) {
            return __TYPE_Data;
        } else if (!strcmp((const char *)typeClazz, "UIImage")) {
            return __TYPE_UIImage;
        } else {
            return __TYPE_Object;
        }
    }
    return __TYPE_Unknown;
}

+ (NSString *)getSqlWithTypeCode:(VTypeCode)typeCode {
    NSString * sqlStrWithTypeCode = nil;
    
    switch (typeCode) {
        case __TYPE_Number:
        {
            sqlStrWithTypeCode = @"INTEGER DEFAULT 0";
        }
            break;
        case __TYPE_Data:
        {
            sqlStrWithTypeCode = @"BLOB";
        }
            break;
        case __TYPE_UIImage:
        {
            sqlStrWithTypeCode = @"BLOB";
        }
            break;
            
        case __TYPE_Date:
        {
            sqlStrWithTypeCode = @"TIMESTAMP default (datetime('now', 'localtime'))";
        }
            break;
            
        default:
        {
            sqlStrWithTypeCode = @"TEXT";
        }
            break;
    }
    return sqlStrWithTypeCode;
}

+ (NSString *)getSqlWithAttribute:(const char *)attribute {
    VTypeCode typeCode = [DataTypeEncoding getTypeWithAttribute:attribute];
    return [DataTypeEncoding getSqlWithTypeCode:typeCode];
}

@end

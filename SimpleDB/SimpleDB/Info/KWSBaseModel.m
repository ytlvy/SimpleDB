//
//  KWSBaseModel.m
//  KWSing
//
//  Created by gyj on 16/6/22.
//  Copyright © 2016年 kuwo.cn. All rights reserved.
//

#import "KWSBaseModel.h"

@interface KWSBaseModel()
@property (nonatomic, assign) NSInteger p_rowid;
@end

@implementation KWSBaseModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        [self pure_customInit:dict]; 
    }
    return self;
}

- (NSDictionary *)fmColumnMap {
    
    BOOL isUseMap = NO;
    
    NSArray *allProperties;
    NSArray *fmPropertyArr      = [[self class] fmPropertyArray];
    NSDictionary *fmPropertyMap = [[self class] fmPropertyMap];
    if (!fmPropertyArr) {
        isUseMap = YES;
        allProperties = [fmPropertyMap allKeys];
    }
    else {
        allProperties = fmPropertyArr;
    }
    
    NSAssert([allProperties count] > 0, @"fmPropertyMap 未定义");
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in allProperties) {
        id value = [self valueForKey:key];
        
        NSString *column;
        if (isUseMap) {
            column = fmPropertyMap[key];
        }
        else {
            column  = key;
        }
        
        if (value == nil || value == [NSNull null]) {
            [dictionary setObject:[NSNull null] forKey:column];
        }
        else if ([value isKindOfClass:[NSNumber class]]
                 || [value isKindOfClass:[NSString class]]
                 || [value isKindOfClass:[NSDate class]]) {
            
            [dictionary setObject:value forKey:column];
        }
        else if([value isKindOfClass:[NSDictionary class]]) {
           NSAssert(0, @"Invalid type for %@ (%@)", NSStringFromClass([self class]) ,key); 
        }
        else if([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *n_arr = [NSMutableArray new];
            [(NSArray *)value enumerateObjectsUsingBlock:^(KWSBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[KWSBaseModel class]]) {
                    [n_arr addObject: [obj toDictionary]];
                }
            }]; 
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:n_arr options:NSJSONWritingPrettyPrinted error:nil];
            if(jsonData) {
                [dictionary setObject:jsonData forKey:column];
            }
            else {
                NSAssert(NO, @"");
            }
        }
        else if ([value isKindOfClass:[NSObject class]]) { //建联
            if ([value respondsToSelector:@selector(fmColumnMap)]) {
                [dictionary setObject:[value fmColumnMap] forKey:column];
            }
            else {
                NSAssert(0, @"Invalid type for %@ (%@)", NSStringFromClass([self class]) ,key);
                NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
            }
        }
        else {
            NSAssert(0, @"Invalid type for %@ (%@)", NSStringFromClass([self class]) ,key);
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    
    return [dictionary copy];
}

+ (NSDictionary *)fmPropertyMap {
    
    return nil;
}

+ (NSArray *)fmConditions {
    NSAssert(NO, @"==ERROR== 虚拟方法需要子类实现");
    return nil;
}


+ (NSArray *)fmPropertyArray {
    return nil;
}

+ (NSArray *)fmPrimaryKeys {
    return nil;
}

+ (NSString *)fmSortString {
    return @"";
}

- (void)pure_customInit:(NSDictionary *)dic {
	
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *m_dic = [NSMutableDictionary new];
    
    Class YourClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(YourClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        char const *attributes = property_getAttributes(property);
        NSString *attributesString = [NSString stringWithCString:attributes encoding:[NSString defaultCStringEncoding]];
        if([attributesString localizedCaseInsensitiveContainsString:@"R,"]) {
            continue;
        }
        
        if([[self valueForKey:propertyName] isKindOfClass:[NSArray class]]) {
            NSMutableArray *n_arr = [NSMutableArray new];
            NSArray *data = (NSArray *)[self valueForKey:propertyName];
            [data enumerateObjectsUsingBlock:^(KWSBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[KWSBaseModel class]]) {
                    [n_arr addObject: [obj toDictionary]];
                }
            }];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:n_arr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if(jsonData) {
                [m_dic setObject:jsonStr forKey:propertyName];
            }
            else {
                NSAssert(NO, @"");
            }
        }
        else if([[self valueForKey:propertyName] isKindOfClass:[KWSBaseModel class]]) {
            KWSBaseModel *model = (KWSBaseModel *)[self valueForKey:propertyName];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if(jsonData) {
                [m_dic setObject:jsonStr forKey:propertyName];
            }
            else {
                NSAssert(NO, @"");
            }
        }
        else {
            [m_dic setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    return m_dic;
}

@end

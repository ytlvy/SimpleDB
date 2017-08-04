//
//  KWSBaseInfo.m
//  KWSing
//
//  Created by peter on 16/4/18.
//  Copyright © 2016年 kuwo.cn. All rights reserved.
//

#import "KWSBaseInfo.h"
#import <CoreGraphics/CGBase.h>

static NSString * const TYPE_INT_NAME     = @"int";
static NSString * const TYPE_DOUBLE_NAME  = @"double";
static NSString * const TYPE_ID_NAME      = @"id";

static NSString * _getPropertyName(objc_property_t property) {
    const char * propertyName = property_getName(property);
    return [NSString stringWithCString:propertyName encoding:[NSString defaultCStringEncoding]];
}

static NSString * _getPropertyType(objc_property_t property) {
    const char * type = property_getAttributes(property);
    NSString * typeStr = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeStr componentsSeparatedByString:@","];
    if ([attributes count] <= 0) {
        return nil;
    }
    NSString * typeAttribute = [attributes firstObject];
    if ([typeAttribute length] < 1) {
        return nil;
    }
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (!strcmp(rawPropertyType, @encode(float)) ||
        !strcmp(rawPropertyType, @encode(CGFloat)) ||
        !strcmp(rawPropertyType, @encode(double))) {
        return TYPE_DOUBLE_NAME;
    }
    else if (!strcmp(rawPropertyType, @encode(int)) ||
             !strcmp(rawPropertyType, @encode(long)) ||
             !strcmp(rawPropertyType, @encode(NSInteger)) ||
             !strcmp(rawPropertyType, @encode(NSUInteger))) {
        return TYPE_INT_NAME;
    }
    else if (!strcmp(rawPropertyType, @encode(id))) {
        return TYPE_ID_NAME;
    }
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        NSString * className = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
        if (className) {
            return className;
        }
    }
    
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface KWSPropertiesHelper ()

@property (nonatomic, assign)             objc_property_t property;
@property (nonatomic, readwrite, copy)    NSString        * className;
@property (nonatomic, readwrite, copy)    NSString        * propertyName;
@property (nonatomic, readwrite, weak)    Class           clazz;

@property (nonatomic, readwrite, assign)  BOOL            isPrimitive;
@property (nonatomic, readwrite, assign)  BOOL            isModelsArray;
@property (nonatomic, readwrite, assign)  BOOL            isModel;

@end

@implementation KWSPropertiesHelper

- (instancetype)initWithProperty:(objc_property_t)property {
    self = [super init];
    if (self) {
        self.property = property;
        self.propertyName = _getPropertyName(property);
        self.className = _getPropertyType(property);
        
        _isPrimitive = [@[TYPE_INT_NAME, TYPE_DOUBLE_NAME, TYPE_ID_NAME] containsObject:self.className];
        if (!_isPrimitive) {
            self.clazz = NSClassFromString(self.className);
            if (!(_isModelsArray = [_clazz isSubclassOfClass:[NSArray class]])) {
                _isModel = [_clazz isSubclassOfClass:[KWSBaseInfo class]];
            }
        }
    }
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KWSBaseInfo ()

@end

@implementation KWSBaseInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self _parseWithDict:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    /**
     防止KVC赋值崩溃
     */
    
    NSAssert(NO, @"==ERROR== Undefined key : %@", key);
    
}

#pragma mark - Public Method

- (void)parseJson:(NSDictionary *)json map:(NSDictionary *)map {
    NSDictionary *propertiesDict = [self _propertiesDict];
    [map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        *stop = ![self _parseWithDict:json propertiesDict:propertiesDict key:key obj:obj check:YES];
    }];
    
}

- (void)parseDict:(NSDictionary *)dict {
    [self _parseWithDict:dict];
}

- (NSDictionary *)modelToJson {
    NSMutableDictionary *muteDictionary = [NSMutableDictionary dictionary];
    
    unsigned int propertiesCount = 0;
    //get all properties of current class
    Class searchClass = [self class];
    while (searchClass != [KWSBaseInfo class]) {
        objc_property_t * properties = class_copyPropertyList(searchClass, &propertiesCount);
        for (int iProperties = 0; iProperties < propertiesCount; ++iProperties) {
            objc_property_t property = properties[iProperties];
            
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            id value = [self valueForKey:propertyName];
            if (!value || value == [NSNull null]) {
                continue;
            }
            
            if (![self isPropertyReadOnly:property]) {
                [muteDictionary setValue:value forKey:propertyName];
            }
            
        }
        free(properties);
        searchClass = [searchClass superclass];
    }
    return [muteDictionary copy];
}

- (void)copyPropertiesWithObjec:(id)obj clazz:(Class)clazz {
    unsigned int propertesCount = 0;
    
    Class searchClass = clazz;
    while (searchClass != [KWSBaseInfo class]) {
        objc_property_t * properties = class_copyPropertyList(searchClass, &propertesCount);
        
        for (int i = 0 ; i < propertesCount ; i++) {
            const char * propertyChar   = property_getName(properties[i]);
            NSString   *	propertyStr = [NSString stringWithCString:propertyChar
                                                          encoding:NSUTF8StringEncoding];
            id value                    = [obj valueForKey:propertyStr];
            
            
            if (!value || value == [NSNull null]) {
                continue;
            }
            
            if (![self isPropertyReadOnly:properties[i]]) {
                [self setValue:value forKey:propertyStr];
            }
        }
        free(properties);
        searchClass = [searchClass superclass];
    }
}

#pragma  mark - private method


- (BOOL)isPropertyReadOnly:(objc_property_t)property {
    const char *propertyAttributes = property_getAttributes(property);
    
    NSArray *attributes =
    [[NSString stringWithUTF8String:propertyAttributes]
     componentsSeparatedByString:@","];
    
    return [attributes containsObject:@"R"];
    
}

- (NSDictionary *)_propertiesDict {
    static dispatch_once_t onceToken;
    static NSMutableDictionary * __classProperties = nil;
    dispatch_once(&onceToken, ^{
        __classProperties = [NSMutableDictionary dictionaryWithCapacity:128];
    });
    
    NSString * className = NSStringFromClass(self.class);
    __block NSMutableDictionary * propertiesDict = [__classProperties objectForKey:className];
    if (!propertiesDict) {
        [self _enumPropertiesWithBlock:^(KWSPropertiesHelper *helper, int total) {
            if (!propertiesDict) {
                propertiesDict = [NSMutableDictionary dictionaryWithCapacity:total];
            }
            propertiesDict[helper.propertyName] = helper;
        }];
        if (!propertiesDict) {
            propertiesDict = [NSMutableDictionary new];
        }
        __classProperties[className] = propertiesDict;
    }
    
    return [propertiesDict copy];
}

- (void)_parseWithDict:(NSDictionary *)dict {
    
    NSDictionary *propertiesDict = [self _propertiesDict];
    
    if ([self.class respondsToSelector:@selector(modelCustomAllPropertyMapper)]) {
        NSDictionary *customAllMapper = [(id <KWSBaseProtocol>)self.class modelCustomAllPropertyMapper];
        [customAllMapper enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self _parseWithDict:dict propertiesDict:propertiesDict key:key obj:obj check:YES];
        }];
    } else if ([self.class respondsToSelector:@selector(modelCustomPartPropertyMapper)]) {
        [self _parseWithDict:dict propertiesDict:propertiesDict];
        NSDictionary *customPartMapper = [(id <KWSBaseProtocol>)self.class modelCustomPartPropertyMapper];
        [customPartMapper enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self _parseWithDict:dict propertiesDict:propertiesDict key:key obj:obj check:YES];
        }];
    } else {
        [self _parseWithDict:dict propertiesDict:propertiesDict];
    }
}

- (BOOL)_parseWithDict:(NSDictionary *)dict propertiesDict:(NSDictionary *)propertiesDict {
    for (NSString *key in dict) {
        [self _parseWithDict:dict propertiesDict:propertiesDict key:key obj:key check:NO];
    }
    return YES;
}

- (BOOL)_parseWithDict:(NSDictionary *)dict propertiesDict:(NSDictionary *)propertiesDict key:(id)key obj:(id)obj check:(BOOL)check{
    KWSPropertiesHelper * propertiesHelper = [propertiesDict objectForKey:key];
    if ([key isEqualToString:@"id"]) {
        if (propertiesHelper && [propertiesHelper.propertyName isEqualToString:key]) {
            id parseObject = [dict objectForKey:obj];
            [self setValue:parseObject forKey:key];
        }
        //id 时候暂时不处理
    } else if (propertiesHelper) {
        id resultObject = nil;
        id parseObject = [dict objectForKey:obj];
        if (!parseObject || [parseObject isKindOfClass:[NSNull class]]) {
            return NO;
        }
        NSString * propertyName = propertiesHelper.propertyName;
        Class propertyClass = propertiesHelper.clazz;
        if (propertiesHelper.isPrimitive) {
            [self setValue:parseObject forKey:propertyName];
        } else {
            if (propertiesHelper.isModelsArray) {
                if ([parseObject isKindOfClass:[NSDictionary class]]) {
                    if([[propertyClass alloc] respondsToSelector:@selector(initWithDict:)]) {
                        resultObject = [[propertyClass alloc] initWithDict:parseObject];
                    }
                    else {
                        NSAssert(NO, @"");
                    }
                } 
                else if ([parseObject isKindOfClass:[NSArray class]]) {
                    if([[propertyClass alloc] respondsToSelector:@selector(initWithArray:)]) {
                        resultObject = [[propertyClass alloc] initWithArray:parseObject];
                    }
                    else {
                        NSMutableArray *m_arr = [NSMutableArray new];
                        [(NSArray *)parseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if([obj isKindOfClass:[NSDictionary class]] && [[propertyClass alloc] respondsToSelector:@selector(initWithDict:)]) {
                                [m_arr addObject:[[propertyClass alloc] initWithDict:obj]]; 
                            }
                            else {
                                NSAssert(NO, @"");
                            }
                        }]; 
                        resultObject = m_arr;
                    }
                }
            } else if (propertiesHelper.isModel) {
                if ([parseObject isKindOfClass:[NSDictionary class]]) {
                    resultObject = [[propertyClass alloc] initWithDict:parseObject];
                }
            } else {
                resultObject = parseObject;
                if (![resultObject isKindOfClass:propertyClass]) {
                    
                }
                if ([resultObject isKindOfClass:[NSNull class]]) {
                    resultObject = @"";
                }
                
                if ([resultObject isKindOfClass:[NSString class]]) {
                    if ([self.class respondsToSelector:@selector(propertyListOfNeedKW_UrlDecode)]) {
                        NSArray *properties = [(id <KWSBaseProtocol>)self.class propertyListOfNeedKW_UrlDecode];
                        if ([properties containsObject:propertyName]) {
                            resultObject = resultObject;
                        }
                    }
                }
                
            }
            [self setValue:resultObject forKey:propertyName];
        }
    }
    else {
        if (check) {
            NSAssert(NO, @"====属性书写错误=====");
        }
    }
    return YES;
}

- (void)_enumPropertiesWithBlock:(void (^)(KWSPropertiesHelper * helper, int total))processBlock {
    unsigned int propertiesCount = 0;
    //get all properties of current class
    Class searchClass = [self class];
    while (searchClass != [KWSBaseInfo class]) {
        objc_property_t * properties = class_copyPropertyList(searchClass, &propertiesCount);
        for (int iProperties = 0; iProperties < propertiesCount; ++iProperties) {
            objc_property_t property = properties[iProperties];
            KWSPropertiesHelper * tempHelper = [[KWSPropertiesHelper alloc] initWithProperty:property];
            if (processBlock) {
                processBlock(tempHelper, propertiesCount);
            }
        }
        free(properties);
        searchClass = [searchClass superclass];
    }
}

@end

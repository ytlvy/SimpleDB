//
//  NSDictionary+KWCategories.m
//  KWCategories
//
//  Created by Peter on 03/03/2017.
//  Copyright © 2017 iastrolien. All rights reserved.
//

#import "NSDictionary+KWCategories.h"

#define KW_NUMBERVALUE_TOVALUE(_type_)                                                      \
if (key.length <= 0) return defaultValue;                                                   \
id value = [self objectForKey:key];                                                         \
if (!value || value == [NSNull null]) return defaultValue;                                  \
if ([value isKindOfClass:[NSString class]]) value = kw_numberValueFromId(value);            \
if ([value isKindOfClass:[NSNumber class]]                                                  \
    || [value respondsToSelector:@selector(_type_)])                                        \
    return [value _type_];                                                                  \
return defaultValue;

#define KW_CLASSVAlUE_TOVALUE(_class_)                                                      \
if (key.length <= 0) return defaultValue;                                                   \
id value = [self objectForKey:key];                                                         \
if (!value || value == [NSNull null]) return defaultValue;                                  \
if ([value isKindOfClass:[_class_ class]]) return (_class_ *)value;                         \
return defaultValue;

/**
 Get NSNumber Object from 'id' value
 */
static NSNumber *kw_numberValueFromId(id value) {
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lowerValue = ((NSString *)value).lowercaseString;
        if ([lowerValue isEqualToString:@"true"] || [lowerValue isEqualToString:@"yes"]) return @(YES);
        if ([lowerValue isEqualToString:@"false"] || [lowerValue isEqualToString:@"no"]) return @(NO);
        if ([lowerValue isEqualToString:@"nil"] || [lowerValue isEqualToString:@"null"]) return nil;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        value = [numberFormatter numberFromString:(NSString *)value];
        return (NSNumber *)value;
    }
    return nil;
}


@implementation NSDictionary (KWCategories)

- (char)kw_charValueForKey:(NSString *)key {
    return [self kw_charValueForKey:key defaultValue:0];
}

- (char)kw_charValueForKey:(NSString *)key defaultValue:(char)defaultValue {
    KW_NUMBERVALUE_TOVALUE(charValue);
}

- (unsigned char)kw_unsignedCharValueForKey:(NSString *)key {
    return [self kw_unsignedCharValueForKey:key defaultValue:0];
}

- (unsigned char)kw_unsignedCharValueForKey:(NSString *)key defaultValue:(unsigned char)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedCharValue);
}

- (short)kw_shortValueForKey:(NSString *)key {
    return [self kw_shortValueForKey:key defaultValue:0];
}

- (short)kw_shortValueForKey:(NSString *)key defaultValue:(short)defaultValue {
    KW_NUMBERVALUE_TOVALUE(shortValue);
}

- (unsigned short)kw_unsignedShortValueForKey:(NSString *)key {
    return [self kw_unsignedShortValueForKey:key defaultValue:0];
}

- (unsigned short)kw_unsignedShortValueForKey:(NSString *)key defaultValue:(unsigned short)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedShortValue);
}

- (int)kw_intValueForKey:(NSString *)key {
    return [self kw_intValueForKey:key defaultValue:0];
}

- (int)kw_intValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    KW_NUMBERVALUE_TOVALUE(intValue);
}

- (unsigned int)kw_unsignedIntValueForKey:(NSString *)key {
    return [self kw_unsignedIntValueForKey:key defaultValue:0];
}

- (unsigned int)kw_unsignedIntValueForKey:(NSString *)key defaultValue:(unsigned int)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedIntValue);
}

- (long)kw_longValueForKey:(NSString *)key {
    return [self kw_longValueForKey:key defaultValue:0];
}

- (long)kw_longValueForKey:(NSString *)key defaultValue:(long)defaultValue {
    KW_NUMBERVALUE_TOVALUE(longValue);
}

- (unsigned long)kw_unsignedLongValueForKey:(NSString *)key {
    return [self kw_unsignedLongValueForKey:key defaultValue:0];
}

- (unsigned long)kw_unsignedLongValueForKey:(NSString *)key defaultValue:(unsigned long)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedLongValue);
}

- (long long)kw_longLongValueForKey:(NSString *)key {
    return [self kw_longLongValueForKey:key defaultValue:0];
}

- (long long)kw_longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    KW_NUMBERVALUE_TOVALUE(longLongValue);
}

- (unsigned long long)kw_unsignedLongLongValueForKey:(NSString *)key {
    return [self kw_unsignedLongLongValueForKey:key defaultValue:0];
}

- (unsigned long long)kw_unsignedLongLongValueForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedLongLongValue);
}

- (float)kw_floatValueForKey:(NSString *)key {
    return [self kw_floatValueForKey:key defaultValue:0.0f];
}

- (float)kw_floatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    KW_NUMBERVALUE_TOVALUE(floatValue);
}

- (double)kw_doubleValueForKey:(NSString *)key {
    return [self kw_doubleValueForKey:key defaultValue:0.0f];
}

- (double)kw_doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue {
    KW_NUMBERVALUE_TOVALUE(doubleValue);
}

- (BOOL)kw_boolValueForKey:(NSString *)key {
    return [self kw_boolValueForKey:key defaultValue:NO];
}

- (BOOL)kw_boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    KW_NUMBERVALUE_TOVALUE(boolValue);
}

- (NSInteger)kw_integerValueForKey:(NSString *)key {
    return [self kw_integerValueForKey:key defaultValue:0];
}

- (NSInteger)kw_integerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    KW_NUMBERVALUE_TOVALUE(integerValue);
}

- (NSUInteger)kw_unsignedIntegerValueForKey:(NSString *)key {
    return [self kw_unsignedIntegerValueForKey:key defaultValue:0];
}

- (NSUInteger)kw_unsignedIntegerValueForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue {
    KW_NUMBERVALUE_TOVALUE(unsignedIntegerValue);
}

- (NSString *)kw_stringValueForKey:(NSString *)key {
    return [self kw_stringValueForKey:key defaultValue:nil];
}

- (NSString *)kw_stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    KW_CLASSVAlUE_TOVALUE(NSString);
}

- (NSNumber *)kw_numberValueForKey:(NSString *)key {
    return [self kw_numberValueForKey:key defaultValue:nil];
}

- (NSNumber *)kw_numberValueForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue {
    KW_CLASSVAlUE_TOVALUE(NSNumber);
}

- (NSArray *)kw_arrayValueForKey:(NSString *)key {
    return [self kw_arrayValueForKey:key defalutValue:nil];
}

- (NSArray *)kw_arrayValueForKey:(NSString *)key defalutValue:(NSArray *)defaultValue {
    KW_CLASSVAlUE_TOVALUE(NSArray);
}

- (NSDictionary *)kw_dictionaryValueForKey:(NSString *)key {
    return [self kw_dictionaryValueForKey:key defaultValue:nil];
}

- (NSDictionary *)kw_dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    KW_CLASSVAlUE_TOVALUE(NSDictionary);
}

@end

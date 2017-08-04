//
//  NSDictionary+KWCategories.h
//  KWCategories
//
//  Created by Peter on 03/03/2017.
//  Copyright © 2017 iastrolien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KWCategories)

/**
 Get Value From Dictionary
 */
- (char)kw_charValueForKey:(NSString *)key;
- (char)kw_charValueForKey:(NSString *)key defaultValue:(char)defaultValue;
- (unsigned char)kw_unsignedCharValueForKey:(NSString *)key;
- (unsigned char)kw_unsignedCharValueForKey:(NSString *)key defaultValue:(unsigned char)defaultValue;
- (short)kw_shortValueForKey:(NSString *)key;
- (short)kw_shortValueForKey:(NSString *)key defaultValue:(short)defaultValue;
- (unsigned short)kw_unsignedShortValueForKey:(NSString *)key;
- (unsigned short)kw_unsignedShortValueForKey:(NSString *)key defaultValue:(unsigned short)defaultValue;
- (int)kw_intValueForKey:(NSString *)key;
- (int)kw_intValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (unsigned int)kw_unsignedIntValueForKey:(NSString *)key;
- (unsigned int)kw_unsignedIntValueForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;
- (long)kw_longValueForKey:(NSString *)key;
- (long)kw_longValueForKey:(NSString *)key defaultValue:(long)defaultValue;
- (unsigned long)kw_unsignedLongValueForKey:(NSString *)key;
- (unsigned long)kw_unsignedLongValueForKey:(NSString *)key defaultValue:(unsigned long)defaultValue;
- (long long)kw_longLongValueForKey:(NSString *)key;
- (long long)kw_longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (unsigned long long)kw_unsignedLongLongValueForKey:(NSString *)key;
- (unsigned long long)kw_unsignedLongLongValueForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue;
- (float)kw_floatValueForKey:(NSString *)key;
- (float)kw_floatValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)kw_doubleValueForKey:(NSString *)key;
- (double)kw_doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)kw_boolValueForKey:(NSString *)key;
- (BOOL)kw_boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSInteger)kw_integerValueForKey:(NSString *)key;
- (NSInteger)kw_integerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (NSUInteger)kw_unsignedIntegerValueForKey:(NSString *)key;
- (NSUInteger)kw_unsignedIntegerValueForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;
- (NSString *)kw_stringValueForKey:(NSString *)key;
- (NSString *)kw_stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSNumber *)kw_numberValueForKey:(NSString *)key;
- (NSNumber *)kw_numberValueForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSArray *)kw_arrayValueForKey:(NSString *)key;
- (NSArray *)kw_arrayValueForKey:(NSString *)key defalutValue:(NSArray *)defaultValue;
- (NSDictionary *)kw_dictionaryValueForKey:(NSString *)key;
- (NSDictionary *)kw_dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;


@end

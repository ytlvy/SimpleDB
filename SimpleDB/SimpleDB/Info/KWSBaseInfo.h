//
//  KWSBaseInfo.h
//  KWSing
//
//  Created by peter on 16/4/18.
//  Copyright © 2016年 kuwo.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, KSAttationType) {
    KSAttationType_Unknown,
    KSAttationType_NotAttation, // 未关注
    KSAttationType_PayAttationed, // 已经关注
    KSAttationType_ByAttationed,  // 被关注
    KSAttationType_PayAttationedTogether, // 相互关注
};

typedef NS_ENUM(NSInteger, KWSMatchInfoType) {
    KWSMatchInfoType_Normal,
    KWSMatchInfoType_Match          = 5,     ///< 内链(比赛)
    KWSMatchInfoType_OutsideURL     = 6,     ///< 外链
    KWSMatchInfoType_GreatestHits   = 7,     ///< 精选集
    KWSMatchInfoType_Pay            = 9,     ///< 内链(支付)
    KWSMatchInfoType_InsideURL      = 10,    ///< 内链
};

@interface KWSPropertiesHelper : NSObject

@property (nonatomic, readonly, copy)    NSString    * className;
@property (nonatomic, readonly, copy)    NSString    * propertyName;
@property (nonatomic, readonly, weak)    Class       clazz;

@property (nonatomic, readonly, assign)  BOOL        isPrimitive;
@property (nonatomic, readonly, assign)  BOOL        isModelsArray;
@property (nonatomic, readonly, assign)  BOOL        isModel;

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@protocol KWSBaseProtocol <NSObject>
@optional

/**
 *  自定义model 与 json 对应map
 *  全部查找， 不会检索类property
 */
+ (NSDictionary *)modelCustomAllPropertyMapper;

/**
 *  自定义model 与 json 对应map
 *  部分查找， 会检索类property
 */
+ (NSDictionary *)modelCustomPartPropertyMapper;

+ (NSArray *)propertyListOfNeedKW_UrlDecode;

@end

@interface KWSBaseInfo : NSObject <KWSBaseProtocol>

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)parseJson:(NSDictionary *)json map:(NSDictionary *)map;
- (void)parseDict:(NSDictionary *)dict;
- (NSDictionary *)modelToJson;
- (void)copyPropertiesWithObjec:(id)obj clazz:(Class)clazz;

@end


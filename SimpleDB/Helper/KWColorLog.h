//
//  KWColorLog.h
//  KWUtility
//
//  Created by gyj on 2016/12/26.
//  Copyright © 2016年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#define FILE_NAME [NSString stringWithUTF8String:__FILE__]

#define KSLogError(format, ...) do { [KWColorLog logError:FILE_NAME line:__LINE__ token:nil form:format, ##__VA_ARGS__];} while (0)
#define KSLogWarn(format, ...) do { [KWColorLog logWarnning:FILE_NAME line:__LINE__ token:@"" form:format, ##__VA_ARGS__];} while (0)
#define KSLogInfo(format, ...) do { [KWColorLog logInfo:FILE_NAME line:__LINE__ token:@"" form:format, ##__VA_ARGS__];} while (0)
#define KSLogDebug(format, ...) do { [KWColorLog logDebug:FILE_NAME line:__LINE__ token:@"" form:format, ##__VA_ARGS__];} while (0)
#define KSLogVerbose(format, ...) do { [KWColorLog logVerbose:FILE_NAME line:__LINE__ token:@"" form:format, ##__VA_ARGS__];} while (0)


#define KSLogTokenError(userToken, format, ...) do { [KWColorLog logError:FILE_NAME line:__LINE__ token:userToken form:format, ##__VA_ARGS__];} while (0)
#define KSLogTokenWarn(userToken,format, ...) do{ [KWColorLog logWarnning:FILE_NAME line:__LINE__ token:userToken form:format, ##__VA_ARGS__];} while (0)
#define KSLogTokenInfo(userToken, format, ...) do{ [KWColorLog logInfo:FILE_NAME line:__LINE__ token:userToken form:format, ##__VA_ARGS__];} while (0)
#define KSLogTokenDebug(userToken, format, ...) do{ [KWColorLog logDebug:FILE_NAME line:__LINE__ token:userToken form:format, ##__VA_ARGS__];} while (0)
#define KSLogTokenVerbose(userToken, format, ...) do { [KWColorLog logVerbose:FILE_NAME line:__LINE__ token:userToken form:format, ##__VA_ARGS__];} while (0)

#else

#define KSLogVerbose(format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogDebug(format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogInfo(format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogWarn(format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogError(format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)

#define KSLogTokenError(token, format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogTokenWarn(token,format, ...) do{ (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogTokenInfo(token, format, ...) do{ (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogTokenDebug(token, format, ...) do{ (NSLog)(format, ##__VA_ARGS__);} while (0)
#define KSLogTokenVerbose(token, format, ...) do { (NSLog)(format, ##__VA_ARGS__);} while (0)

#endif

typedef NS_ENUM(NSInteger, KWColorLogLevel) {
    KWColorLogLevelError,
    KWColorLogLevelWarnning,
    KWColorLogLevelInfo,
    KWColorLogLevelDebug,
    KWColorLogLevelVerbose,
};

@interface KWColorLog : NSObject

+ (KWColorLogLevel)currentLogLevel;

+ (void)updateLogLevel:(KWColorLogLevel)level;

+ (void)logError:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)logWarnning:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)logInfo:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)logDebug:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)logVerbose:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

@end

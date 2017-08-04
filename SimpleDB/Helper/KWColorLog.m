//
//  KWColorLog.m
//  KWUtility
//
//  Created by gyj on 2016/12/26.
//  Copyright © 2016年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWColorLog.h"

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color

#define XCODE_COLORLOG_PREFIX(lev)  fprintf(stderr, "========" lev "=======start <%s : %d> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __func__)

#define XCODE_COLORLOG_PREPEND(lev) fprintf(stderr, "================" lev "================end\n")

static NSString *XCODE_COLORS_ESCAPE = @"";
static NSString *ColorError = @"";
static NSString *ColorWarnning = @"";
static NSString *ColorInfo = @"";
static NSString *ColorDebug = @"";
static NSString *ColorVerbose = @"";

static KWColorLogLevel _level = KWColorLogLevelVerbose;

@implementation KWColorLog
+ (void)load {
#ifdef DEBUG
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0)) {
        XCODE_COLORS_ESCAPE = @"\033[";
        ColorError = @"fg169,42,128;";
        ColorWarnning = @"fg255,203,36;";
        ColorInfo = @"fg99,99,99;";
        ColorDebug = @"fg122,122,122;";
        ColorVerbose = @"fg155,155,155;";
    }
#endif
}

+ (KWColorLogLevel)currentLogLevel {
    return _level;
}

+ (void)updateLogLevel:(KWColorLogLevel)level {
    _level = level;
}

+ (void)logError:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
    
#ifdef DEBUG
    if ( _level < KWColorLogLevelError ) {
        return;
    }
    
    NSString *formatStr = @"";
    if(token.length > 0) {
        formatStr = [NSString stringWithFormat:@"%@%@==%@==ERROR==%@==%ld==%@%@;", XCODE_COLORS_ESCAPE,ColorError, token, [file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    else {
        formatStr = [NSString stringWithFormat:@"%@%@==ERROR==%@==%ld==%@%@;", XCODE_COLORS_ESCAPE,ColorError, [file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    
    va_list args;
    va_start(args, format);
    formatStr = [[NSString alloc] initWithFormat:formatStr arguments:args];
    va_end(args);
    
    NSLog(@"%@", formatStr);
    
#endif
}

+ (void)logWarnning:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
    
#ifdef DEBUG
    if ( _level < KWColorLogLevelWarnning ) {
        return;
    }
    
    NSString *formatStr;
    if(token.length > 0) {
        formatStr = [NSString stringWithFormat:@"%@%@==%@==WARNING==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE, ColorWarnning, token, [file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    else {
        formatStr = [NSString stringWithFormat:@"%@%@==WARNING==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE, ColorWarnning,[file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    
    va_list args;
    va_start(args, format);
    formatStr = [[NSString alloc] initWithFormat:formatStr arguments:args];
    va_end(args);
    
    NSLog(@"%@", formatStr);
#endif
}

+ (void)logInfo:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
#ifdef DEBUG
    if ( _level < KWColorLogLevelInfo ) {
        return;
    }
    
    NSString *formatStr;
    if(token.length > 0) {
        formatStr = [NSString stringWithFormat:@"%@%@==%@==INFO==%@==%ld==%@%@;", XCODE_COLORS_ESCAPE,  ColorInfo, token, [file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    else {
        formatStr = [NSString stringWithFormat:@"%@%@==INFO==%@==%ld==%@%@;", XCODE_COLORS_ESCAPE,  ColorInfo, [file lastPathComponent], (long)line, format, XCODE_COLORS_ESCAPE];
    }
    va_list args;
    va_start(args, format);
    formatStr = [[NSString alloc] initWithFormat:formatStr arguments:args];
    va_end(args);
    
    NSLog(@"%@", formatStr);
#endif
}

+ (void)logDebug:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
#ifdef DEBUG
    if ( _level < KWColorLogLevelDebug ) {
        return;
    }
    
    NSString *formatStr;
    if(token.length > 0) {
        formatStr = [NSString stringWithFormat:@"%@%@==%@==DEBUG==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE, ColorDebug, token, [file lastPathComponent], (long)line,  format, XCODE_COLORS_ESCAPE];
    }
    else {
        formatStr = [NSString stringWithFormat:@"%@%@==DEBUG==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE, ColorDebug, [file lastPathComponent], (long)line,  format, XCODE_COLORS_ESCAPE];
    }
    va_list args;
    va_start(args, format);
    formatStr = [[NSString alloc] initWithFormat:formatStr arguments:args];
    va_end(args);
    
    NSLog(@"%@", formatStr);
#endif
}

+ (void)logVerbose:(NSString *)file line:(NSInteger)line token:(NSString *)token form:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
#ifdef DEBUG
    if ( _level < KWColorLogLevelVerbose ) {
        return;
    }
    
    NSString *formatStr;
    if(token.length > 0) {
        formatStr = [NSString stringWithFormat:@"%@%@==%@==VERBOS==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE,  ColorVerbose, token, [file lastPathComponent], (long)line,  format, XCODE_COLORS_ESCAPE];
    }
    else {
        formatStr = [NSString stringWithFormat:@"%@%@==VERBOS==%@==%ld==%@%@;",XCODE_COLORS_ESCAPE,  ColorVerbose,[file lastPathComponent], (long)line,  format, XCODE_COLORS_ESCAPE];
    }
    
    va_list args;
    va_start(args, format);
    formatStr = [[NSString alloc] initWithFormat:formatStr arguments:args];
    va_end(args);
    
    NSLog(@"%@", formatStr);
#endif
}
@end

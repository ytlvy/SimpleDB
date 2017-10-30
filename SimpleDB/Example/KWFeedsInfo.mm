//
//  KWFeedsInfo.m
//  KWPlayer
//
//  Created by gyj on 2017/6/30.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWFeedsInfo.h"
#import "KWFeedVideoInfo.h"
#import "NSDate+YLPExtension.h"
#import "NSDictionary+KWCategories.h"

@implementation KWFeedsInfo

+ (instancetype)example {
    KWFeedsInfo *info = [[self alloc] init];
    
    info.title = @"你最爱的视频";
    info.desc = @"这个人很懒没留下任何信息";
    return info;
}

+ (NSArray *)fmPrimaryKeys {
    return nil;
}

+ (NSArray *)fmConditions {
    return @[@"persistentId"];
}

+ (NSArray *)fmPropertyArray {
    return @[@"persistentId",
             @"title",
             @"desc", 
             @"imgUrl",
             @"commnentCnt",
             @"playCnt",
             @"source",
             @"userNick",
             @"userAvatar",
             @"data",
             @"isLiked",
//             @"iconName",
//             @"iconColor",
             ];
}

+ (NSDictionary *)modelCustomPartPropertyMapper {
    return @{
             @"persistentId" : @"id",
             @"imgUrl" : @"img",
             @"commnentCnt" : @"comment_count",
             @"playCnt"  : @"listencnt",
             @"data" : @"data"
             };
}

- (void)pure_customInit:(NSDictionary *)dic {
    NSDictionary *creator = [dic kw_dictionaryValueForKey:@"creator"];
    if(creator) {
        self.userNick = [creator kw_stringValueForKey:@"name"];
        self.userAvatar = [creator kw_stringValueForKey:@"img"];
    }
}


- (NSString *)convertDurationToTime {
    if (self.duration <= 0) return @"00:00";
    NSString *endTime = [NSDate timeFromTimeInterval:self.duration * 1000 format:@"mm:ss"];
    return endTime;
}

#pragma mark - Setter & Getter 
- (void)setData:(NSArray *)data {
    if(![data isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *tempData = [NSMutableArray arrayWithCapacity:data.count];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            KWFeedVideoInfo *feedVideoInfo = [[KWFeedVideoInfo alloc] initWithDict:obj];
            [tempData addObject:feedVideoInfo];
        } else if ([obj isKindOfClass:[KWFeedVideoInfo class]]) {
            [tempData addObject:obj];
        }
    }];
    _data = [tempData copy];
}

#pragma mark - FMDB 解析
+(NSString *)fmSortString {
    return @" ORDER BY rowid DESC";
}

// FMDB特殊解析
- (void) parseValue:(id)data property:(NSString *)property {
    if ([property isEqualToString:@"data"] && [data isKindOfClass:[NSArray class]]) {
        NSMutableArray *m_data = [NSMutableArray new];
        [(NSArray *)data enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KWFeedVideoInfo *vInfo = [[KWFeedVideoInfo alloc] initWithDict:obj];
            if (vInfo) {
                [m_data addObject:vInfo];
            }
        }];
        
        if([m_data count]>0) self.data = [m_data copy];
    }
}

@end

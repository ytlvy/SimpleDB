//
//  KWFeedsInfoDBManager.m
//  KWPlayer
//
//  Created by gyj on 2017/6/30.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWFeedsInfoDBManager.h"
#import "KWFeedsInfo.h"
#import "KWSimpleDBManagerPrivate.h"


@implementation KWFeedsInfoDBManager

+ (id)sharedInstance {
    static id s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
    });
    return s_instance;
}

- (instancetype)init
{
    self = [super initWithPath:@"kwFeeds.db.sqlite"];
    if (self) {
                
    }
    return self;
}

- (void)virtual_configManager {
    self.tableName = @"tb_feeds";
    self.propertyClazz = [KWFeedsInfo class];
    self.tableIdentifier = @"kFeedsTableVersion";
    self.currentVersion = 2;
}

- (BOOL)upgradeFrom1To2 {
    self.dbWrapper.table(self.tableName).addColum(@[@"iconName1"]).commit();
    return self.dbWrapper.table(self.tableName).addColum(@[@"iconColor1"]).commit();
}

@end

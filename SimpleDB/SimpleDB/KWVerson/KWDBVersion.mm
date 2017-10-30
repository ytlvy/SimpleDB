//
//  KWDBVersion.m
//  iTest
//
//  Created by gyj on 2017/7/17.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import "KWDBVersion.h"
#import "KWSqlWrapper.h"
#import "KWFMWrapper.h"

@interface KWDBVersion() 

@property (nonatomic, strong) KWFMWrapper *dbWrapper;
@property (nonatomic, strong) NSString *versionTable;

@end

@implementation KWDBVersion
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
    self = [super init];
    if (self) {
        self.versionTable = @"version";
        self.dbWrapper.table(_versionTable).createT(@{@"identifier":@(KWColumType_String), @"value":@(KWColumType_Number), }).commit();
    }
    return self;
}

- (void)checkUpgrade:(NSString *)identifier curVer:(NSInteger)ver addColums:(NSArray *)colums{

    NSAssert(identifier.length > 0, @"");
    NSAssert(ver > 0, @"");
    KWSqlResult *result = self.dbWrapper.table(_versionTable).selectInt(@"value").where(@{@"identifier":identifier}).commit();
    if(!result.success) {
        return ;
    }
    
    if (result.num < 1) {
        result = self.dbWrapper.table(_versionTable).insert(@{@"value" : @(ver), @"identifier":identifier}).commit();
        if(!result.success) {
            NSAssert(NO, @"");
        }
    } 
    else if (result.num < ver) {
        result = self.dbWrapper.table(identifier).addColum(colums).commit();
        self.dbWrapper.table(_versionTable).update(@{@"value" : @(ver)}).where(@{@"identifier":identifier}).commit();
        if(!result.success) {
            NSAssert(NO, @"");
        }
    }	

}

- (void)checkUpgrade:(NSString *)identifier curVer:(NSInteger)ver blk:(BOOL(^)(NSInteger oldVer))upgradeBlk {
    NSAssert(identifier.length > 0, @"");
    NSAssert(ver > 0, @"");
    KWSqlResult *result = self.dbWrapper.table(_versionTable).selectInt(@"value").where(@{@"identifier":identifier}).commit();
    if(!result.success) {
        NSAssert(NO, @"");
        return;
    }
    
    if (result.num < 1) {
        result = self.dbWrapper.table(_versionTable).insert(@{@"value" : @(ver), @"identifier":identifier}).commit();
        if(!result.success) {
            NSAssert(NO, @"");
        }
    } 
    else if (result.num < ver) {
        if(upgradeBlk) {
            if(upgradeBlk(result.num)) { 
                self.dbWrapper.table(_versionTable).update(@{@"value" : @(ver)}).where(@{@"identifier":identifier}).commit();
                if(!result.success) {
                    NSAssert(NO, @"");
                }
            }
        }
    }	
}

- (KWFMWrapper *)dbWrapper {
	if(_dbWrapper == nil) {
		_dbWrapper = [[KWFMWrapper alloc] initWithPath:@"kw_version.db"];
	}
	return _dbWrapper;
}

@end

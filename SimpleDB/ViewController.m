//
//  ViewController.m
//  SimpleDB
//
//  Created by gyj on 2017/8/4.
//  Copyright © 2017年 com.ytlvy. All rights reserved.
//

#import "ViewController.h"
#import "KWDBVersion.h"
#import "KWFeedsInfo.h"
#import "KWFeedsInfoDBManager.h"
#import "KWColorLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Main";
    
    [self dbTest];
}

- (void)dbTest {
    
    [[KWFeedsInfoDBManager sharedInstance] deleteAll];
    
    KWFeedsInfo *feedInfo = [KWFeedsInfo example];
    KSLogInfo(@"begin to insert model");
    BOOL suc = [[KWFeedsInfoDBManager sharedInstance] insertModel:feedInfo];
    if(!suc) {
        KSLogError(@"insert model error");
    }

    NSArray *models = [[KWFeedsInfoDBManager sharedInstance] allModel];
    NSAssert([models count] == 1, @"");
    KWFeedsInfo *info = [models firstObject];
    
    KSLogInfo(@"model from db : %@, rowid: %ld", info.title, info.p_rowid);
}

@end

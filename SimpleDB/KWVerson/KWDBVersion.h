//
//  KWDBVersion.h
//  iTest
//
//  Created by gyj on 2017/7/17.
//  Copyright © 2017年 ytlvy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWDBVersion : NSObject

+ (id)sharedInstance;
- (void)checkUpgrade:(NSString *)identifier curVer:(NSInteger)ver addColums:(NSArray *)colums;
- (void)checkUpgrade:(NSString *)identifier curVer:(NSInteger)ver blk:(void(^)(NSInteger oldVer))upgradeBlk;

@end

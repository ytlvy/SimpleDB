//
//  KWFeedVideoInfo.h
//  KWPlayer
//
//  Created by gyj on 2017/6/30.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWSBaseModel.h"

@interface KWFeedVideoInfo : KWSBaseModel 

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString* definition;
@property(nonatomic, assign) NSInteger size;


@end

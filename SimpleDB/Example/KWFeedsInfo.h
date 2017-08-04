//
//  KWFeedsInfo.h
//  KWPlayer
//
//  Created by gyj on 2017/6/30.
//  Copyright © 2017年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "KWSBaseModel.h" 
@class KWFeedVideoInfo;
@class OnlineMediaItemInfo;

@interface KWFeedsInfo : KWSBaseModel

@property(nonatomic, assign) NSInteger persistentId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *commnentCnt;
@property(nonatomic, assign) NSInteger playCnt;
@property(nonatomic, assign) NSInteger duration;

@property(nonatomic, copy) NSString  *source;

@property(nonatomic, strong) NSArray *data; ///KWFeedVideoInfo

@property(nonatomic, copy) NSString *userNick;
@property(nonatomic, copy) NSString *userAvatar;
@property (nonatomic, assign) NSInteger isLiked;

@property (nonatomic, strong) OnlineMediaItemInfo *mediaInfo;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isReloading;// relaod 相关歌曲标识
@property(nonatomic, assign) BOOL fetchedRelated;
@property(nonatomic, assign) BOOL fetchedsong;


- (NSString *)convertDurationToTime;

+ (instancetype)example;







@end

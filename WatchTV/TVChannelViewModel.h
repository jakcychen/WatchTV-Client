//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TVChannel;


/// TVChannelViewController ViewModel.
@interface TVChannelViewModel : NSObject


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/// 是否正在擷取資料.
@property (nonatomic, readonly) BOOL fetching;

/// 頻道 models.
@property (nullable, nonatomic, readonly) NSArray <TVChannel *> *models;


///-----------------------------------------------------------------------------
/// @name Public methods
///-----------------------------------------------------------------------------

/// 擷取資料.
- (void)fethModels;

/** 
 搜尋頻道.
 
 @param key 搜尋 tile 或是描述, 當 key = nil, 代表搜尋結束了.
 */
- (void)searchChannelTitleOrDescription:(nullable NSString *)key;

/**
 頻道是否已經收藏.
 
 @param channel 頻道.
 @return 收藏與否.
 */
- (BOOL)channelExistInFavoirte:(TVChannel *)channel;

/**
 新增一筆收藏的頻道, 如果已經有收藏此筆頻道, 將不做任何事.
 
 @param channel 頻道.
 */
- (void)addChannelToFavorite:(TVChannel *)channel;

/**
 移除一筆收藏的頻道, 如果未收藏此頻道, 將不做任何事.
 
 @param channel 頻道.
 */
- (void)removeChannelFromFavorite:(TVChannel *)channel;

@end

NS_ASSUME_NONNULL_END

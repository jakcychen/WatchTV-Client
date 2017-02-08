//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TVChannel;


/// TVFavoriteViewController ViewModel.
@interface TVFavoriteViewModel : NSObject


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/// 收藏頻道 models.
@property (nullable, nonatomic, readonly) NSArray <TVChannel *> *models;


///-----------------------------------------------------------------------------
/// @name Public methods
///-----------------------------------------------------------------------------

/// 擷取資料.
- (void)fetchModels;

/**
 移除一筆收藏的頻道, 如果未收藏此頻道, 將不做任何事.
 
 @param channel 頻道.
 */
- (void)removeChannelFromFavorite:(TVChannel *)channel;

@end

NS_ASSUME_NONNULL_END

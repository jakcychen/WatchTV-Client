//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const APIServiceHostName;

@class TVChannel;


/**
 *  API Service.
 */
@interface TVAPIService : NSObject


///-----------------------------------------------------------------------------
/// @name Class properties
///-----------------------------------------------------------------------------

/**
 *  頻道列表.
 */
@property (nonatomic, readonly, class,  nullable) NSArray <TVChannel *> *channelList;

@end

NS_ASSUME_NONNULL_END

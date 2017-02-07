//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <AVKit/AVKit.h>

/**
 *  播放頻道的 ViewController.
 */
@interface TVPlayerViewController : AVPlayerViewController


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 *  頻道 URL string.
 */
@property (nonatomic, copy) NSString *channelURL;

@end

//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <AVKit/AVKit.h>

@class TVChannel;


/// 播放頻道的 ViewController.
@interface TVPlayerViewController : AVPlayerViewController


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/// 播放的頻道.
@property (nonatomic, weak) TVChannel *channel;

@end

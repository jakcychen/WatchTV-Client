//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "TVChannel.h"
#import "TVPlayerViewController.h"


@interface TVPlayerViewController ()<AVPlayerViewControllerDelegate>

@end


@implementation TVPlayerViewController

#pragma mark - LifeCycle
- (void)dealloc
{
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

#pragma mark - AVPlayerViewControllerDelegate
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController
{
    return NO;
}

#pragma mark - Private
#pragma mark 初始設置
- (void)__setup
{
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.delegate = self;
    
    NSString *url =
    [NSString stringWithFormat:@"http://watchtv.heroku.com/streaming?contentId=%@&streamingId=%@"
    ,_channel.contentId, _channel.streamingId];
    
    NSURL *URL  = [NSURL URLWithString:url];
    self.player = [AVPlayer playerWithURL:URL];
}

@end

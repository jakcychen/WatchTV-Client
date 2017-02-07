//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "TVPlayerViewController.h"


@interface TVPlayerViewController ()<AVPlayerViewControllerDelegate>

@end


@implementation TVPlayerViewController

#pragma mark - LifeCycle
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
    self.delegate = self;
    NSURL *URL    = [NSURL URLWithString:_channelURL];
    self.player   = [AVPlayer playerWithURL:URL];
}

@end

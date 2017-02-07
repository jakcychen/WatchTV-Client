//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

@import AVFoundation;
#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // Default 是黑色的, 當 Push 到 TVSettingController,
    // 因為 TVSettingController.hidesBottomBarWhenPushed = YES,
    // 會造成 UINavigationBar 有黑色區塊.
    _window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

@end

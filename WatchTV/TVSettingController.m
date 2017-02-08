//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>
#import <WebImage/WebImage.h>

#import "TVSettingController.h"


@implementation TVSettingController

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self __cleanCache:indexPath];
    }
    else if(indexPath.row == 1)
    {
        [self __removeFavoriteDB:indexPath];
    }
    
}

#pragma mark - Private
#pragma mark 清除暫存
- (void)__cleanCache:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
        [[SDImageCache sharedImageCache]cleanDisk];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *cachesPath       = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
    
        [fileManager removeItemAtPath:cachesPath error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
    });
}

#pragma 清除收藏 db
- (void)__removeFavoriteDB:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
        
        [favoriteDB removeAll];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
    });
}

@end

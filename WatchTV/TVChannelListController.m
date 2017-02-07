//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//


#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVAPIService.h"
#import "TVChannelCell.h"
#import "TVPlayerViewController.h"
#import "TVChannelListController.h"

@interface TVChannelListController ()<UISearchBarDelegate>

@property (nonatomic, assign) BOOL fetching;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, copy) NSArray <TVChannel *> *dataSource;
@property (nonatomic, copy) NSArray <TVChannel *> *searchSource;

@end


@implementation TVChannelListController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Why reload, 因為可能在 TVFavoriteListController 移除收藏, 所以每次進來都 reload,
    // 懶得用 SRPPlist Notification 判斷.
    if(_dataSource.count)
    {
        [self __reloadData];
    }
    else
    {
        [self reloadItemClicked:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_searchBar resignFirstResponder];

    if([segue.identifier isEqualToString:@"toTVPlayerViewController"])
    {
        TVChannel *channel = sender;

        NSString *channelURL =
        [NSString stringWithFormat:@"%@/api/v2/streaming?contentId=%@&streamingId=%@"
        ,APIServiceHostName ,channel.contentId, channel.streamingId];
    
        TVPlayerViewController *player = segue.destinationViewController;
        player.channelURL = channelURL;
    }
}

#pragma mark - IBAction
#pragma mark Reload item clicked
- (IBAction)reloadItemClicked:(id)sender
{
    if(_fetching) { return; }
    
    _fetching = YES;
    
    self.navigationItem.rightBarButtonItem = _loadingItem;
    
    [self __reset];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _dataSource = [TVAPIService.channelList copy];
        
        [self __reloadData];
        
        _fetching = NO;
    });
}

#pragma mark - Private
#pragma mark 初始設置
- (void)__setup
{
    [self.tableView registerClass:[TVChannelCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark Reload 資料
- (void)__reloadData
{
    // 如果目前搜尋狀態下
    if(_searching)
    {
        NSPredicate *filter =
        [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (description contains[cd] %@)",
        _searchBar.text, _searchBar.text];

        _searchSource = [[_dataSource filteredArrayUsingPredicate:filter]copy];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.navigationItem.rightBarButtonItem = _reloadItem;
        self.tableView.tableHeaderView = _searchBar;
        [self.tableView reloadData];
    });
}

#pragma mark Reset
- (void)__reset
{
    _searchBar.text = nil;
    _searching      = NO;
    _searchSource   = nil;
    _dataSource     = nil;
    _searchBar.showsCancelButton   = NO;
    self.tableView.tableHeaderView = nil;
    
    [_searchBar resignFirstResponder];
    [self.tableView reloadData];
}

@end

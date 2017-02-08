//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import "TVChannel.h"
#import "TVChannelCell.h"
#import "TVChannelViewModel.h"
#import "TVPlayerViewController.h"
#import "TVChannelViewController.h"


@interface TVChannelViewController ()

@property (nonatomic, strong) TVChannelViewModel *viewModel;

@end


@implementation TVChannelViewController

#pragma mark - LifeCycle
- (void)dealloc
{
    [_viewModel removeObserver:self forKeyPath:@"models"];
    [_viewModel removeObserver:self forKeyPath:@"fetching"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Why reload, 因為可能在 TVFavoriteListController 移除收藏, 所以每次進來都 reload,
    // 懶得用 SRPPlist Notification 判斷.
    if(_viewModel.models.count)
    {
        [self __updateUIAfterFetchOrSearch];
    }
    else
    {
        [self __fetchData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TVPlayerViewController *player = segue.destinationViewController;
    player.channel = sender;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"fetching"])
    {
        [self __updateUIByFetching];
    }
    else if([keyPath isEqualToString:@"models"])
    {
        [self __updateUIAfterFetchOrSearch];
    }
}

#pragma mark - IBAction
#pragma mark ReloadItem clicked
- (IBAction)reloadItemClicked:(id)sender
{
    [self __fetchData];
}

#pragma mark - Private
#pragma mark 初始設置
- (void)__setup
{
    [self.tableView registerClass:[TVChannelCell class] forCellReuseIdentifier:@"Cell"];
    
    _viewModel = [[TVChannelViewModel alloc]init];
    
    [_viewModel addObserver:self forKeyPath:@"models" options:NSKeyValueObservingOptionNew context:nil];
    [_viewModel addObserver:self forKeyPath:@"fetching" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 擷取資料
- (void)__fetchData
{
    [self __resetSearch];
    [_viewModel fethModels];
}

#pragma mark 擷取或搜尋後更新 UI
- (void)__updateUIAfterFetchOrSearch
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_tableView reloadData];
    });
}

#pragma mark 擷取過程更新 UI
- (void)__updateUIByFetching
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _searchBar.hidden = (_viewModel.fetching);
        self.navigationItem.rightBarButtonItem = (_viewModel.fetching) ? _loadingItem : _reloadItem;
    });
}

#pragma mark 重置搜尋
- (void)__resetSearch
{
    _searchBar.text = nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    [_viewModel searchChannelTitleOrDescription:nil];
}

@end

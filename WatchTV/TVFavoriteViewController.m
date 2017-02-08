//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVChannelCell.h"
#import "TVFavoriteViewModel.h"
#import "TVPlayerViewController.h"
#import "TVFavoriteViewController.h"


@interface TVFavoriteViewController ()<TVChannelCellDelegate>

@property (nonatomic, strong) TVFavoriteViewModel *viewModel;

@end


@implementation TVFavoriteViewController

#pragma mark - LifeCycle
- (void)dealloc
{
    [_viewModel removeObserver:self forKeyPath:@"models"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_viewModel fetchModels];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TVPlayerViewController *player = segue.destinationViewController;
    player.channel = sender;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"models"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(TVChannelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = _viewModel.models[indexPath.row];
    
    [cell configureWithChannel:channel favorited:YES];
    
    cell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = _viewModel.models[indexPath.row];
    
    [self performSegueWithIdentifier:@"toTVPlayerViewController" sender:channel];
}

#pragma mark - TVChannelDelegate
- (void)favoriteButtonClickedInCell:(TVChannelCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TVChannel *channel     = _viewModel.models[indexPath.row];
    
    [_viewModel removeChannelFromFavorite:channel];
}

#pragma mark - Private
#pragma mark 初始設置
- (void)__setup
{
    [self.tableView registerClass:[TVChannelCell class] forCellReuseIdentifier:@"Cell"];
    
    _viewModel = [[TVFavoriteViewModel alloc]init];
    
    [_viewModel addObserver:self forKeyPath:@"models" options:NSKeyValueObservingOptionNew context:nil];
}

@end

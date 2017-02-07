//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVChannelCell.h"
#import "TVPlayerViewController.h"
#import "TVFavoriteListController.h"


@interface TVFavoriteListController ()<TVChannelCellDelegate>

@property (nonatomic, copy) NSArray <TVChannel *> *dataSource;

@end


@implementation TVFavoriteListController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self __reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TVChannel *channel = sender;

    NSString *channelURL =
    [NSString stringWithFormat:@"http://watchtv.heroku.com/streaming?contentId=%@&streamingId=%@"
    ,channel.contentId, channel.streamingId];
    
    TVPlayerViewController *player = segue.destinationViewController;
    player.channelURL = channelURL;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(TVChannelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = _dataSource[indexPath.row];
    
    [cell configureWithChannel:channel favorited:YES];
    
    cell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = _dataSource[indexPath.row];
    
    [self performSegueWithIdentifier:@"toTVPlayerViewController" sender:channel];
}

#pragma mark - TVChannelDelegate
- (void)favoriteButtonClickedInCell:(TVChannelCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TVChannel *channel     = _dataSource[indexPath.row];
    
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    if([favoriteDB removeWhere:where])
    {
        [self __reloadData];
    }
}

#pragma mark - Private
#pragma mark 初始設置
- (void)__setup
{
    [self.tableView registerClass:[TVChannelCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark Reload data
- (void)__reloadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        SRPPlist *favoriteDB   = [[SRPPlist alloc]initWithName:@"favoriteDB"];
        
        NSArray *query = [favoriteDB queryAllSort:@[sort]];
        _dataSource    = [TVChannel modelsFromArray:query];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
        });
    });
}

@end


//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVChannelListController+Delegations.h"


@interface TVChannelListController ()

@property (nonatomic, assign) BOOL searching;
@property (nonatomic, copy) NSArray <TVChannel *> *dataSource;
@property (nonatomic, copy) NSArray <TVChannel *> *searchSource;

@end


@implementation TVChannelListController (Delegations)

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray <TVChannel *> *dataSource = (self.searching) ? self.searchSource : self.dataSource;
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(TVChannelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray <TVChannel *> *dataSource = (self.searching) ? self.searchSource : self.dataSource;
    
    TVChannel *channel   = dataSource[indexPath.row];
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    BOOL favorited = ([favoriteDB queryWhere:where sort:nil].count > 0);
    
    [cell configureWithChannel:channel favorited:favorited];
    
    cell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray <TVChannel *> *dataSource = (self.searching) ? self.searchSource : self.dataSource;
    TVChannel *channel = dataSource[indexPath.row];
    
    [self performSegueWithIdentifier:@"toTVPlayerViewController" sender:channel];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searching = YES;
    self.searchBar.showsCancelButton = YES;

    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searching    = NO;
    self.searchSource = nil;
    searchBar.text    = nil;
    searchBar.showsCancelButton = NO;
    
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 搜尋 Title 跟描述.
    NSPredicate *filter =
    [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (description contains[cd] %@)",
     searchText, searchText];
    
    self.searchSource = [[self.dataSource filteredArrayUsingPredicate:filter]copy];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - TVChannelDelegate
- (void)favoriteButtonClickedInCell:(TVChannelCell *)cell
{
    NSArray <TVChannel *> *dataSource = (self.searching) ? self.searchSource : self.dataSource;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TVChannel *channel     = dataSource[indexPath.row];
    
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    BOOL favorited = [favoriteDB queryWhere:where sort:nil].count > 0;
    
    if(favorited)
    {
        [favoriteDB removeWhere:where];
    }
    else
    {
        NSDictionary *dic = [channel toDictionary];
        
        [favoriteDB add:dic];
    }
    
    [self.tableView reloadData];
}

@end

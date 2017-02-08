//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import "TVChannel.h"
#import "TVChannelViewModel.h"
#import "TVChannelViewController+Delegations.h"


@implementation TVChannelViewController (Delegations)

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(TVChannelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = self.viewModel.models[indexPath.row];
    BOOL favorited     = [self.viewModel channelExistInFavoirte:channel];
    
    [cell configureWithChannel:channel favorited:favorited];
    
    cell.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVChannel *channel = self.viewModel.models[indexPath.row];
    
    [self performSegueWithIdentifier:@"toTVPlayerViewController" sender:channel];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    // 可能第一次 search 時
    if(!searchBar.text.length)
    {
        [self.viewModel searchChannelTitleOrDescription:@""];
    }
    
    // 可能 Cancel 反灰, 再按 Cancel
    else
    {
        [self.viewModel searchChannelTitleOrDescription:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self.viewModel searchChannelTitleOrDescription:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.viewModel searchChannelTitleOrDescription:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - TVChannelCellDelegate
- (void)favoriteButtonClickedInCell:(TVChannelCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TVChannel *channel     = self.viewModel.models[indexPath.row];
    
    if([self.viewModel channelExistInFavoirte:channel])
    {
        [self.viewModel removeChannelFromFavorite:channel];
    }
    else
    {
        [self.viewModel addChannelToFavorite:channel];
    }
}

@end

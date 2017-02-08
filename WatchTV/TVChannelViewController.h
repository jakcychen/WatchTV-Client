//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>

@class TVChannelViewModel;


/// 頻道列表 ViewController.
@interface TVChannelViewController : UIViewController


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/// ViewModel.
@property (nonatomic, readonly) TVChannelViewModel *viewModel;

/// TableView.
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/// Search Bar.
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

/// Reload item, in stroyboard view docker.
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadItem;

/// Loading item, in stroyboard view docker.
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loadingItem;

@end

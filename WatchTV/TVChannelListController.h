//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  頻道列表 ViewController.
 */
@interface TVChannelListController : UITableViewController


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 *  Search Bar.
 */
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

/**
 *  Reload item.
 */
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadItem;

/**
 *  載入中 item.
 */
@property (nonatomic, strong) IBOutlet UIBarButtonItem *loadingItem;

@end

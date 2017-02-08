//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import "TVChannelCell.h"
#import "TVChannelViewController.h"


/// 處理 TVChannelViewController delegations.
@interface TVChannelViewController (Delegations)
<
    UISearchBarDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    TVChannelCellDelegate
>

@end

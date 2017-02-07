//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import "TVChannelCell.h"
#import "TVChannelListController.h"


/**
 *  TVChannelListController delegation handle category.
 */
@interface TVChannelListController (Delegations)
<
    UISearchBarDelegate,
    TVChannelCellDelegate
>

@end

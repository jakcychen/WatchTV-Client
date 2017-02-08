//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>

@class TVChannel;
@class TVChannelCell;


/// TVChannelCell protocol.
@protocol TVChannelCellDelegate <NSObject>


///-----------------------------------------------------------------------------
/// @name Optional methods
///-----------------------------------------------------------------------------

@optional

/**
 收藏按鈕點擊後的 callback.
 
 @param cell 哪個 Cell 點擊了收藏按鈕.
 */
- (void)favoriteButtonClickedInCell:(TVChannelCell *)cell;

@end


/// Channel cell.
@interface TVChannelCell : UITableViewCell


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------


/// Delegation.
@property (nonatomic, weak) UIViewController <TVChannelCellDelegate> *delegate;


///-----------------------------------------------------------------------------
/// @name Public methods.
///-----------------------------------------------------------------------------

/**
 設置 Cell.
 
 @param channel   頻道 model.
 @param favorited 是否收藏
 */
- (void)configureWithChannel:(TVChannel *)channel favorited:(BOOL)favorited;

@end

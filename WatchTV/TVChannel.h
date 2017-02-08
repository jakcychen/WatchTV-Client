//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPModel/SRPModel.h>


///頻道 model.
@interface TVChannel : SRPModel


///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

///Content Id.
@property (nonatomic, readonly) NSString *contentId;

/// 描述.
@property (nonatomic, readonly) NSString *desc;

/// 圖片 URL.
@property (nonatomic, readonly) NSString *imageUrl;

/// 名稱.
@property (nonatomic, readonly) NSString *name;

/// Streaming Id.
@property (nonatomic, readonly) NSString *streamingId;

@end

//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVFavoriteViewModel.h"


@interface TVFavoriteViewModel ()

@property (nonatomic, copy) NSArray <TVChannel *> *models;

@end


@implementation TVFavoriteViewModel

#pragma mark - Public
#pragma mark 擷取資料
- (void)fetchModels
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    SRPPlist *favoriteDB   = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    [self willChangeValueForKey:@"models"];
    NSArray *results = [favoriteDB queryAllSort:@[sort]];
    _models = [TVChannel modelsFromArray:results];
    [self didChangeValueForKey:@"models"];
}

#pragma mark 移除收藏
- (void)removeChannelFromFavorite:(TVChannel *)channel
{
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    if([favoriteDB removeWhere:where])
    {
        [self fetchModels];
    }
}

@end

//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <SRPPlist/SRPPlist.h>

#import "TVChannel.h"
#import "TVChannelViewModel.h"


@interface TVChannelViewModel ()

@property (nonatomic, assign) BOOL fetching;
@property (nonatomic, copy) NSArray <TVChannel *> *models;
@property (nonatomic, strong) NSPredicate *searchFilter;

@end


@implementation TVChannelViewModel

#pragma mark - Getter
- (NSArray<TVChannel *> *)models
{
    // 當有 _searchFilter 時, 代表正在 search
    if(_searchFilter)
    {
        return [[_models filteredArrayUsingPredicate:_searchFilter]copy];
    }
    
    return _models;
}

#pragma mark - Public
#pragma mark 擷取資料
- (void)fethModels
{
    if(_fetching)
    {
        return;
    }
    
    [self willChangeValueForKey:@"fetching"];
    _fetching = YES;
    [self didChangeValueForKey:@"fetching"];
    
    _models   = nil;
    
    NSString *url = @"http://watchtv.herokuapp.com/api/v2/channels";
    NSURL *URL    = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [self willChangeValueForKey:@"fetching"];
        _fetching = NO;
        [self didChangeValueForKey:@"fetching"];
        
        [self willChangeValueForKey:@"models"];
        _models = [TVChannel modelsFromObject:data];
        [self didChangeValueForKey:@"models"];
    }];
    
    [task resume];
}

#pragma mark 搜尋頻道
- (void)searchChannelTitleOrDescription:(NSString *)key
{
    [self willChangeValueForKey:@"models"];
    
    if(!key)
    {
        _searchFilter = nil;
    }
    else
    {
        _searchFilter =
        [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (description contains[cd] %@)",
        key, key];
    }
    
    [self didChangeValueForKey:@"models"];
}

#pragma mark 是否收藏頻道
- (BOOL)channelExistInFavoirte:(TVChannel *)channel
{
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    return [favoriteDB queryWhere:where sort:nil].count > 0;
}

#pragma mark 新增收藏
- (void)addChannelToFavorite:(TVChannel *)channel
{
    if([self channelExistInFavoirte:channel])
    {
        return;
    }
    
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    
    [self willChangeValueForKey:@"models"];
    [favoriteDB add:[channel toDictionary]];
    [self didChangeValueForKey:@"models"];
}

#pragma mark 移除收藏
- (void)removeChannelFromFavorite:(TVChannel *)channel
{
    if(![self channelExistInFavoirte:channel])
    {
        return;
    }
    
    SRPPlist *favoriteDB = [[SRPPlist alloc]initWithName:@"favoriteDB"];
    NSPredicate *where = [NSPredicate predicateWithFormat:
    @"(contentId == %@) AND (streamingId == %@)", channel.contentId, channel.streamingId];
    
    [self willChangeValueForKey:@"models"];
    [favoriteDB removeWhere:where];
    [self didChangeValueForKey:@"models"];
}

@end

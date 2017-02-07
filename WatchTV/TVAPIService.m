//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import "TVChannel.h"
#import "TVAPIService.h"

NSString * const APIServiceHostName = @"http://watchtv.herokuapp.com";


@implementation TVAPIService

+ (NSArray<TVChannel *> *)channelList
{
    __block NSArray <TVChannel *> *results ;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/v2/channels", APIServiceHostName];
    NSURL *URL    = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        results = [TVChannel modelsFromObject:data];
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return results;
}

@end

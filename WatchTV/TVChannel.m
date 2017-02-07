//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//


#import "TVChannel.h"


@implementation TVChannel

#pragma mark - SRPModel
+ (NSDictionary<NSString *,NSString *> *)keyMapping
{
    return @{@"description" : @"desc"};
}

+ (NSString *)contentIdTransformValue:(id)old
{
    if([old isKindOfClass:[NSString class]])
    {
        return old;
    }
    
    if([old isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", old];
    }
    
    return nil;
}

+ (NSString *)streamingIdTransformValue:(id)old
{
    if([old isKindOfClass:[NSString class]])
    {
        return old;
    }
    
    if([old isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", old];
    }
    
    return nil;
}

@end

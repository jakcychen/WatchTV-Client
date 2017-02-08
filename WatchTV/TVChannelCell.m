//
//  Copyright (c) 2017 shinren.pan@gmail.com All rights reserved.
//

#import <WebImage/WebImage.h>

#import "TVChannel.h"
#import "TVChannelCell.h"


@implementation TVChannelCell

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryView   = [self __favoriteButton];
    }
    
    return self;
}

#pragma mark - Public
- (void)configureWithChannel:(TVChannel *)channel favorited:(BOOL)favorited
{
    self.textLabel.text       = channel.name;
    self.detailTextLabel.text = channel.desc;

    // 收藏按鈕顏色
    self.accessoryView.tintColor =
    favorited ? [UIColor redColor] : [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    NSURL *imageURL = [NSURL URLWithString:channel.imageUrl];
    UIImage *holder = [UIImage imageNamed:@"Image-Placeholder"];
    
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:holder completed:^
    (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if(image)
        {
            CGFloat scale = image.size.width / 44.0;// 縮小成 44 x 44 比例
            
            self.imageView.image =
            (scale > 1) ? [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp] : image;
            
            [self setNeedsLayout];
        }
    }];
}

#pragma mark - Private
#pragma mark 收藏按鈕
- (UIButton *)__favoriteButton
{
    UIImage *img     = [UIImage imageNamed:@"Icon-favorite-n"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame     = CGRectMake(0, 0, 25, 25);
    
    [button setImage:img forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(__favoriteButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark Favorite button clicked
- (void)__favoriteButtonClicked:(id)sender
{
    if([_delegate respondsToSelector:@selector(favoriteButtonClickedInCell:)])
    {
        [_delegate favoriteButtonClickedInCell:self];
    }
}

@end

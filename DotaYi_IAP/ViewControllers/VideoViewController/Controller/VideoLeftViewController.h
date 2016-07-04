//
//  VideoLeftViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"

@protocol ArtileLeftChannelDelegate <NSObject>

-(void) didSelectChannelWithChannleID:(NSString *) theChannelID  AndChannelName:(NSString *) theChannelName AndChannelImageUrl:(NSString *) theChannelImgUrl;//选择频道

@end


@interface VideoLeftViewController : BaseViewController

@property (nonatomic,weak) id<ArtileLeftChannelDelegate> delegate;

-(void) reloadData;

@end

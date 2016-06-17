//
//  HeroRankTableViewCell.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/6/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroRankTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *heroRankHeadImageView;//英雄头像

@property (nonatomic,strong) UILabel *heroRankHeroNameLabel;//英雄名

@property (nonatomic,strong) UILabel *heroRankHeroPointLabel;//积分

@property (nonatomic,strong) UILabel *heroRankUserNameLabel;//用户名

@end

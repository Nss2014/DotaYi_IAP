//
//  GoodAtHeroTableViewCell.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/26.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodAtHeroTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *goodHeroHeadImageView;//头像  40x40

@property (nonatomic,strong) UILabel *goodHeroNameLabel;//名称

@property (nonatomic,strong) UILabel *goodHeroTotalUseLabel;//比赛场次

@property (nonatomic,strong) UILabel *goodHeroWinChanceLabel;//胜率

@property (nonatomic,strong) UIProgressView *goodHeroWinChanceProgressView;//胜率进度条

@property (nonatomic,strong) UILabel *goodHeroPointLabel;//积分

@end

//
//  JJCRankTableViewCell.h
//  DotaYi_IAP
//
//  Created by nssnss on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJCRankTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *rankOrderLabel;//名次

@property (nonatomic,strong) UILabel *rankUserNameLabel;//用户名

@property (nonatomic,strong) UILabel *rankPointLabel;//积分

@property (nonatomic,strong) UILabel *rankTotalPlaysLabel;//总场次

@property (nonatomic,strong) UILabel *rankWinningProbabilityLabel;//胜率

@end

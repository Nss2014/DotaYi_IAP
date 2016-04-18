//
//  SettingsTableViewCell.h
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *ST_backgroundView;

@property (nonatomic,strong) UIImageView *ST_iconImageView;

@property (nonatomic,strong) UILabel *ST_nameLabel;

@property (nonatomic,strong) UIImageView *ST_indicatorImageView;

@property (nonatomic,strong) UILabel *ST_clearCacheLabel;


@end


@interface SettingSection1Cell : UITableViewCell

@property (nonatomic,strong) UIView *SS_backGroundView;

@property (nonatomic,strong) UIImageView *SS_userImageView;

@property (nonatomic,strong) UILabel *SS_userNameLabel;

@end
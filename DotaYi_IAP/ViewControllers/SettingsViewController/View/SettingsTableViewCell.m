//
//  SettingsTableViewCell.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.ST_backgroundView = [[UIView alloc] init];
        
        [self.contentView addSubview:self.ST_backgroundView];
        
        self.ST_iconImageView = [[UIImageView alloc] init];
        
        [self.ST_backgroundView addSubview:self.ST_iconImageView];
        
        self.ST_nameLabel = [[UILabel alloc] init];
        
        self.ST_nameLabel.font = TEXT14_FONT;
        
        self.ST_nameLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.ST_backgroundView addSubview:self.ST_nameLabel];
        
        self.ST_indicatorImageView = [[UIImageView alloc] init];
        
        [self.ST_backgroundView addSubview:self.ST_indicatorImageView];
        
        self.ST_clearCacheLabel = [[UILabel alloc] init];
        
        self.ST_clearCacheLabel.font = TEXT14_FONT;
        
        self.ST_clearCacheLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.ST_clearCacheLabel.textAlignment = NSTextAlignmentRight;

        [self.ST_backgroundView addSubview:self.ST_clearCacheLabel];
        
        WS(ws);
        
        CGFloat padding = 10;
        
        [self.ST_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(padding);
            make.top.equalTo(ws.contentView.mas_top).offset(padding/2);
            make.bottom.equalTo(ws.contentView.mas_bottom).offset(-padding/2);
            make.right.equalTo(ws.contentView.mas_right).offset(-padding);
        }];
        
        [self.ST_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.ST_backgroundView.mas_left).offset(2 * padding);
            make.centerY.equalTo(ws.ST_backgroundView.mas_centerY);
            make.width.mas_equalTo(30);
            make.height.equalTo(ws.ST_iconImageView.mas_width);
        }];
        
        [self.ST_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.ST_iconImageView.mas_right).offset(2 * padding);
            make.top.equalTo(ws.ST_backgroundView.mas_top);
            make.bottom.equalTo(ws.ST_backgroundView.mas_bottom);
            make.right.equalTo(ws.ST_backgroundView.mas_right).offset(-2 * padding);
        }];
        
        [self.ST_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.ST_backgroundView.mas_right).offset(-padding);
            make.centerY.equalTo(ws.ST_backgroundView.mas_centerY);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(15);
        }];
        
        [self.ST_clearCacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.ST_indicatorImageView.mas_left).offset(-padding/2);
            make.centerY.equalTo(ws.ST_backgroundView.mas_centerY);
            make.height.equalTo(ws.ST_backgroundView.mas_height);
            make.width.mas_equalTo(100);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.ST_backgroundView.layer.borderWidth = PIXL1_AUTO;
    
    self.ST_backgroundView.layer.borderColor = SEPRATELINE_GRAYCOLOR.CGColor;
}

@end

@implementation SettingSection1Cell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.SS_backGroundView = [[UIView alloc] init];
        
        self.SS_userImageView = [[UIImageView alloc] init];
        
        self.SS_userNameLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.SS_backGroundView];
        
        [self.SS_backGroundView addSubview:self.SS_userImageView];
        
        [self.SS_backGroundView addSubview:self.SS_userNameLabel];
        
        CGFloat padding = 10;
        
        WS(ws);
        
        [self.SS_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(padding);
            make.top.equalTo(ws.contentView.mas_top).offset(padding/2);
            make.bottom.equalTo(ws.contentView.mas_bottom).offset(-padding/2);
            make.right.equalTo(ws.contentView.mas_right).offset(-padding);
        }];
        
        [self.SS_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.SS_backGroundView.mas_centerX);
            make.top.equalTo(ws.SS_backGroundView.mas_top).offset(padding * 1.5);
            make.height.equalTo(ws.SS_backGroundView.mas_height).multipliedBy(0.5);
            make.width.equalTo(ws.SS_userImageView.mas_height);
        }];
        
        [self.SS_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.SS_userImageView.mas_centerX);
            make.top.equalTo(ws.SS_userImageView.mas_bottom);
            make.width.equalTo(ws.SS_backGroundView.mas_width).multipliedBy(0.5);
            make.bottom.equalTo(ws.SS_backGroundView.mas_bottom);
        }];
        
    }
    return self;
}

-(void)updateConstraints
{
    
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    
    [self.contentView layoutIfNeeded];
    
    self.SS_backGroundView.layer.borderWidth = PIXL1_AUTO;
    
    self.SS_backGroundView.layer.borderColor = SEPRATELINE_GRAYCOLOR.CGColor;
    
    self.SS_userImageView.layer.cornerRadius = self.SS_userImageView.frame.size.width/2;
    
    self.SS_userImageView.clipsToBounds = YES;
    
    self.SS_userNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.SS_userNameLabel.font = TEXT16_FONT;
    
    self.SS_userNameLabel.textColor = COLOR_TITLE_BLACK;
}

@end


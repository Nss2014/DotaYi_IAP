//
//  HeroRankTableViewCell.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/6/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroRankTableViewCell.h"

@implementation HeroRankTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.heroRankHeadImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.heroRankHeadImageView];
        
        self.heroRankHeroNameLabel = [[UILabel alloc] init];
        
        self.heroRankHeroNameLabel.font = TEXT14_FONT;
        
        self.heroRankHeroNameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.heroRankHeroNameLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.heroRankHeroNameLabel];
        
        
        self.heroRankHeroPointLabel = [[UILabel alloc] init];
        
        self.heroRankHeroPointLabel.font = TEXT14_FONT;
        
        self.heroRankHeroPointLabel.textAlignment = NSTextAlignmentCenter;
        
        self.heroRankHeroPointLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.heroRankHeroPointLabel];
        
        
        self.heroRankUserNameLabel = [[UILabel alloc] init];
        
        self.heroRankUserNameLabel.font = TEXT14_FONT;
        
        self.heroRankUserNameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.heroRankUserNameLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.heroRankUserNameLabel];
        
        WS(ws);
        
        [self.heroRankHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top).offset(PADDING_WIDTH/2);
            make.bottom.equalTo(ws.contentView.mas_bottom).offset(-PADDING_WIDTH/2);
            make.width.equalTo(ws.heroRankHeadImageView.mas_height);
        }];
        
        [self.heroRankHeroNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.heroRankHeadImageView.mas_right).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.35);
        }];
        
        [self.heroRankHeroPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.heroRankHeroNameLabel.mas_right);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.25);
        }];
        
        [self.heroRankUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.heroRankHeroPointLabel.mas_right);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.4);
        }];
    }
    return self;
}

@end

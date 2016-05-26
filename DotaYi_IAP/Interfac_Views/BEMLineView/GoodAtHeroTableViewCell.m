//
//  GoodAtHeroTableViewCell.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/26.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "GoodAtHeroTableViewCell.h"

@implementation GoodAtHeroTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.goodHeroHeadImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.goodHeroHeadImageView];
        
        self.goodHeroNameLabel = [[UILabel alloc] init];
        
        self.goodHeroNameLabel.font = TEXT12_BOLD_FONT;
        
        self.goodHeroNameLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.goodHeroNameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.goodHeroNameLabel];
        
        self.goodHeroTotalUseLabel = [[UILabel alloc] init];
        
        self.goodHeroTotalUseLabel.font = TEXT12_BOLD_FONT;
        
        self.goodHeroTotalUseLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.goodHeroTotalUseLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.goodHeroTotalUseLabel];
        
        self.goodHeroWinChanceLabel = [[UILabel alloc] init];
        
        self.goodHeroWinChanceLabel.font = TEXT12_BOLD_FONT;
        
        self.goodHeroWinChanceLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.goodHeroWinChanceLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.goodHeroWinChanceLabel];
        
        self.goodHeroWinChanceProgressView = [[UIProgressView alloc] init];
        
        self.goodHeroWinChanceProgressView.layer.cornerRadius = 4.0;
        
        self.goodHeroWinChanceProgressView.clipsToBounds = YES;
        
        self.goodHeroWinChanceProgressView.trackTintColor = XLS_COLOR_BG_LIGHTGREEN;
        
        self.goodHeroWinChanceProgressView.progressTintColor = XLS_COLOR_MAIN_GREEN;
        
        [self.contentView addSubview:self.goodHeroWinChanceProgressView];
        
        self.goodHeroPointLabel = [[UILabel alloc] init];
        
        self.goodHeroPointLabel.font = TEXT12_BOLD_FONT;
        
        self.goodHeroPointLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.goodHeroPointLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.goodHeroPointLabel];
        
        WS(ws);
        
        [self.goodHeroHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top).offset(PADDING_WIDTH);
            make.width.mas_equalTo(40);
            make.height.equalTo(ws.goodHeroHeadImageView.mas_width);
        }];
        
        [self.goodHeroNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.goodHeroHeadImageView.mas_right).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40)/5 + PADDING_WIDTH);
        }];
        
        [self.goodHeroWinChanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.goodHeroNameLabel.mas_right).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top).offset(PADDING_WIDTH);
            make.height.equalTo(ws.contentView.mas_height).multipliedBy(0.4);
            make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40) * 3/5);
        }];
        
        [self.goodHeroWinChanceProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.goodHeroWinChanceLabel.mas_left);
            make.top.equalTo(ws.goodHeroWinChanceLabel.mas_bottom);
            make.width.equalTo(ws.goodHeroWinChanceLabel.mas_width);
            make.height.mas_equalTo(8);
        }];
        
        [self.goodHeroPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.goodHeroWinChanceProgressView.mas_right).offset(PADDING_WIDTH);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40)/5 - PADDING_WIDTH);
        }];
    }
    return self;
}


@end

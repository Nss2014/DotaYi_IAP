//
//  JJCHeroTableViewCell.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "JJCHeroTableViewCell.h"

@implementation JJCHeroTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.rankOrderLabel = [[UILabel alloc] init];
        
        self.rankOrderLabel.font = TEXT14_FONT;
        
        self.rankOrderLabel.textAlignment = NSTextAlignmentCenter;
        
        self.rankOrderLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.rankOrderLabel];
        
        self.rankUserNameLabel = [[UILabel alloc] init];
        
        self.rankUserNameLabel.font = TEXT14_FONT;
        
        self.rankUserNameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.rankUserNameLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.rankUserNameLabel];
        
        self.rankPointLabel = [[UILabel alloc] init];
        
        self.rankPointLabel.font = TEXT14_FONT;
        
        self.rankPointLabel.textAlignment = NSTextAlignmentCenter;
        
        self.rankPointLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.rankPointLabel];
        
        
        self.rankTotalPlaysLabel = [[UILabel alloc] init];
        
        self.rankTotalPlaysLabel.font = TEXT14_FONT;
        
        self.rankTotalPlaysLabel.textAlignment = NSTextAlignmentCenter;
        
        self.rankTotalPlaysLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.rankTotalPlaysLabel];
    
        WS(ws);
        
        [self.rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.equalTo(ws.contentView.mas_width).multipliedBy(0.25);
        }];
        
        [self.rankUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.rankOrderLabel.mas_right);
            make.top.equalTo(ws.rankOrderLabel.mas_top);
            make.bottom.equalTo(ws.rankOrderLabel.mas_bottom);
            make.width.equalTo(ws.rankOrderLabel.mas_width);
        }];
        
        [self.rankPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.rankUserNameLabel.mas_right);
            make.top.equalTo(ws.rankUserNameLabel.mas_top);
            make.bottom.equalTo(ws.rankUserNameLabel.mas_bottom);
            make.width.equalTo(ws.rankUserNameLabel.mas_width);
        }];
        
        [self.rankTotalPlaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.rankPointLabel.mas_right);
            make.top.equalTo(ws.rankPointLabel.mas_top);
            make.bottom.equalTo(ws.rankPointLabel.mas_bottom);
            make.width.equalTo(ws.rankPointLabel.mas_width);
        }];
    }
    return self;
}
@end

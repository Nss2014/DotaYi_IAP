//
//  ArticleLeftTableCell.m
//  XMT_IAP
//
//  Created by 牛松松 on 16/1/20.
//  Copyright © 2016年 花儿绽放. All rights reserved.
//

#import "ArticleLeftTableCell.h"

@implementation ArticleLeftTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.AL_iconImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.AL_iconImageView];
        
        self.AL_channelNameLabel = [[UILabel alloc] init];
        
        self.AL_channelNameLabel.textColor = WHITE_COLOR;
        
        self.AL_channelNameLabel.font = TEXT14_FONT;
        
        [self.contentView addSubview:self.AL_channelNameLabel];
        
        self.AL_topLineView = [[UIView alloc] init];
        
        self.AL_topLineView.backgroundColor = ARTICLESEP_DEEP_COLOR;
        
        [self.contentView addSubview:self.AL_topLineView];
        
        self.AL_bottomLineView = [[UIView alloc] init];
        
        self.AL_bottomLineView.backgroundColor = ARTICLESEP_TINT_COLOR;
        
        [self.contentView addSubview:self.AL_bottomLineView];
        
        
        WS(ws);
        
        CGFloat padding = 10;
        
        [self.AL_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(padding);
            make.centerY.equalTo(ws.contentView.mas_centerY);
            make.height.equalTo(ws.contentView.mas_height).multipliedBy(0.5);
            make.width.equalTo(ws.AL_iconImageView.mas_height);
        }];
        
        [self.AL_channelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.AL_iconImageView.mas_right).offset(padding/2);
            make.centerY.equalTo(ws.AL_iconImageView.mas_centerY);
            make.right.equalTo(ws.contentView.mas_right).offset(-padding/2);
            make.height.equalTo(ws.contentView.mas_height);
            
        }];
        
        [self.AL_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.mas_bottom).offset(-0.8);
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.height.mas_equalTo(0.8);
        }];
        
        [self.AL_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.AL_topLineView.mas_right);
            make.left.equalTo(ws.AL_topLineView.mas_left);
            make.bottom.equalTo(ws.mas_bottom);
            make.height.equalTo(ws.AL_topLineView.mas_height);
        }];
        
    }
    return self;
}


@end

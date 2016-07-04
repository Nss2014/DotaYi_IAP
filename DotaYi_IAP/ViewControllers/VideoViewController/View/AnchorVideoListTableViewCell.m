//
//  AnchorVideoListTableViewCell.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "AnchorVideoListTableViewCell.h"

@implementation AnchorVideoListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.AH_leftImageView = [[UIImageView alloc] init];
        
        self.AH_leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.AH_leftImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.AH_leftImageView];
        
        self.AH_titleLabel = [[UILabel alloc] init];
        
        self.AH_titleLabel.textColor = COLOR_TITLE_BLACK;
        
        self.AH_titleLabel.font = TEXT14_BOLD_FONT;
        
        self.AH_titleLabel.numberOfLines = 2;
        
        [self.contentView addSubview:self.AH_titleLabel];
        
        self.AH_postTimeLabel = [[UILabel alloc] init];
        
        self.AH_postTimeLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        self.AH_postTimeLabel.font = TEXT12_FONT;
        
        [self.contentView addSubview:self.AH_postTimeLabel];
        
        WS(ws);
        
        CGFloat padding = 10;
                
        //图片宽高比例为147x110
        [self.AH_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(padding);
            make.top.equalTo(ws.contentView.mas_top).offset(padding);
            make.bottom.equalTo(ws.contentView.mas_bottom).offset(-padding);
            make.width.equalTo(ws.AH_leftImageView.mas_height).multipliedBy(147.0/110);
        }];
        
        [self.AH_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.AH_leftImageView.mas_right).offset(padding);
            make.top.equalTo(ws.contentView.mas_top);
            make.right.equalTo(ws.contentView.mas_right).offset(-padding);
            make.height.equalTo(ws.contentView.mas_height).multipliedBy(0.5);
        }];
        
        [self.AH_postTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.AH_titleLabel.mas_left);
            make.right.equalTo(ws.contentView.mas_right);
            make.top.equalTo(ws.AH_titleLabel.mas_bottom);
            make.bottom.equalTo(ws.contentView.mas_bottom);
        }];
        
    }
    return self;
}

@end

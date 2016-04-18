//
//  MainGridTableViewCell.m
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/13.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "MainGridTableViewCell.h"

@implementation MainGridTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.MG_firstItemView = [[GridDetailItemView alloc] init];
        
        [self.contentView addSubview:self.MG_firstItemView];
        
        self.MG_secondItemView = [[GridDetailItemView alloc] init];
        
        [self.contentView addSubview:self.MG_secondItemView];
        
        self.MG_thirdItemView = [[GridDetailItemView alloc] init];
        
        [self.contentView addSubview:self.MG_thirdItemView];
        
        self.firstLineView = [[UIView alloc] init];
        
        [self.contentView addSubview:self.firstLineView];
        
        self.secondLineView = [[UIView alloc] init];
        
        [self.contentView addSubview:self.secondLineView];
        
        WS(ws);
        
        [self.MG_firstItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        [self.MG_secondItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.MG_firstItemView.mas_right);
            make.top.equalTo(ws.MG_firstItemView.mas_top);
            make.bottom.equalTo(ws.MG_firstItemView.mas_bottom);
            make.width.equalTo(ws.MG_firstItemView.mas_width);
        }];
        
        [self.MG_thirdItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.MG_secondItemView.mas_right);
            make.top.equalTo(ws.MG_secondItemView.mas_top);
            make.bottom.equalTo(ws.MG_secondItemView.mas_bottom);
            make.right.equalTo(ws.contentView.mas_right);
        }];
        
        [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
            make.width.mas_equalTo(PIXL1_AUTO);
            make.right.equalTo(ws.MG_firstItemView.mas_right);
        }];
        
        [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.firstLineView.mas_top);
            make.bottom.equalTo(ws.firstLineView.mas_bottom);
            make.width.equalTo(ws.firstLineView.mas_width);
            make.right.equalTo(ws.MG_secondItemView.mas_right);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.firstLineView.backgroundColor = SEPRATELINE_GRAYCOLOR;
    
    self.secondLineView.backgroundColor = SEPRATELINE_GRAYCOLOR;
}

@end

@implementation GridDetailItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.grid_ImageView = [[UIImageView alloc] init];
        
        [self addSubview:self.grid_ImageView];
        
        self.grid_nameLabel = [[UILabel alloc] init];
        
        self.grid_nameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.grid_nameLabel.font = TEXT13_FONT;
        
        [self addSubview:self.grid_nameLabel];
        
        WS(ws);
        
        CGFloat padding = 10;
        
        [self.grid_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top).offset(padding * 1.5);
            make.bottom.equalTo(ws.grid_nameLabel.mas_top);
            make.centerX.equalTo(ws.mas_centerX);
            make.width.equalTo(ws.grid_ImageView.mas_height);
        }];
        
        [self.grid_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.mas_centerX);
            make.bottom.equalTo(ws.mas_bottom);
            make.width.equalTo(ws.mas_width);
            make.height.equalTo(ws.mas_height).multipliedBy(0.4);
        }];
    }
    return self;
}

@end
